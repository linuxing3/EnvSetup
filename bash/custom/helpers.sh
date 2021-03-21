#!/usr/bin/env bash

LOG_LEVEL_1=1
LOG_LEVEL_2=2
LOG_LEVEL_3=3
DEFAULT_LOG_LEVEL="$LOG_LEVEL_1"

DEBUG_LEVEL_1=1
DEBUG_LEVEL_2=2
DEBUG_LEVEL_3=3
DEBUG_LEVEL_DEFAULT=$DEBUG_LEVEL_1
DEBUG_LEVEL_NONE=0

DOH_CLOUDFLARE=1
DOH_GOOGLE=2

DEFAULT_OPENSSL_BIN="openssl"
ACME_OPENSSL_BIN="openssl"
HIDDEN_VALUE="[hidden](please add '--output-insecure' to see this value)"

SYSLOG_ERROR="user.error"
SYSLOG_INFO="user.info"
SYSLOG_DEBUG="user.debug"

#error
SYSLOG_LEVEL_ERROR=3
#info
SYSLOG_LEVEL_INFO=6
#debug
SYSLOG_LEVEL_DEBUG=7
#debug2
SYSLOG_LEVEL_DEBUG_2=8
#debug3
SYSLOG_LEVEL_DEBUG_3=9

SYSLOG_LEVEL_DEFAULT=$SYSLOG_LEVEL_ERROR
#none
SYSLOG_LEVEL_NONE=0

NOTIFY_LEVEL_DISABLE=0
NOTIFY_LEVEL_ERROR=1
NOTIFY_LEVEL_RENEW=2
NOTIFY_LEVEL_SKIP=3

NOTIFY_LEVEL_DEFAULT=$NOTIFY_LEVEL_RENEW

NOTIFY_MODE_BULK=0
NOTIFY_MODE_CERT=1

__INTERACTIVE=""
if [ -t 1 ]; then
  __INTERACTIVE="1"
fi

__green() {
  if [ "${__INTERACTIVE}${ACME_NO_COLOR:-0}" = "10" -o "${ACME_FORCE_COLOR}" = "1" ]; then
    printf '\33[1;32m%b\33[0m' "$1"
    return
  fi
  printf -- "%b" "$1"
}

__red() {
  if [ "${__INTERACTIVE}${ACME_NO_COLOR:-0}" = "10" -o "${ACME_FORCE_COLOR}" = "1" ]; then
    printf '\33[1;31m%b\33[0m' "$1"
    return
  fi
  printf -- "%b" "$1"
}

_printargs() {
  _exitstatus="$?"
  if [ -z "$NO_TIMESTAMP" ] || [ "$NO_TIMESTAMP" = "0" ]; then
    printf -- "%s" "[$(date)] "
  fi
  if [ -z "$2" ]; then
    printf -- "%s" "$1"
  else
    printf -- "%s" "$1='$2'"
  fi
  printf "\n"
  # return the saved exit status
  return "$_exitstatus"
}

_dlg_versions() {
  echo "Diagnosis versions: "
  echo "openssl:$ACME_OPENSSL_BIN"
  if _exists "${ACME_OPENSSL_BIN:-openssl}"; then
    ${ACME_OPENSSL_BIN:-openssl} version 2>&1
  else
    echo "$ACME_OPENSSL_BIN doesn't exists."
  fi

  echo "apache:"
  if [ "$_APACHECTL" ] && _exists "$_APACHECTL"; then
    $_APACHECTL -V 2>&1
  else
    echo "apache doesn't exists."
  fi

  echo "nginx:"
  if _exists "nginx"; then
    nginx -V 2>&1
  else
    echo "nginx doesn't exists."
  fi

  echo "socat:"
  if _exists "socat"; then
    socat -V 2>&1
  else
    _debug "socat doesn't exists."
  fi
}

#class
_syslog() {
  _exitstatus="$?"
  if [ "${SYS_LOG:-$SYSLOG_LEVEL_NONE}" = "$SYSLOG_LEVEL_NONE" ]; then
    return
  fi
  _logclass="$1"
  shift
  if [ -z "$__logger_i" ]; then
    if _contains "$(logger --help 2>&1)" "-i"; then
      __logger_i="logger -i"
    else
      __logger_i="logger"
    fi
  fi
  $__logger_i -t "$PROJECT_NAME" -p "$_logclass" "$(_printargs "$@")" >/dev/null 2>&1
  return "$_exitstatus"
}

_log() {
  [ -z "$LOG_FILE" ] && return
  _printargs "$@" >>"$LOG_FILE"
}

_info() {
  _log "$@"
  if [ "${SYS_LOG:-$SYSLOG_LEVEL_NONE}" -ge "$SYSLOG_LEVEL_INFO" ]; then
    _syslog "$SYSLOG_INFO" "$@"
  fi
  _printargs "$@"
}

_err() {
  _syslog "$SYSLOG_ERROR" "$@"
  _log "$@"
  if [ -z "$NO_TIMESTAMP" ] || [ "$NO_TIMESTAMP" = "0" ]; then
    printf -- "%s" "[$(date)] " >&2
  fi
  if [ -z "$2" ]; then
    __red "$1" >&2
  else
    __red "$1='$2'" >&2
  fi
  printf "\n" >&2
  return 1
}

_usage() {
  __red "$@" >&2
  printf "\n" >&2
}

__debug_bash_helper() {
  # At this point only do for --debug 3
  if [ "${DEBUG:-$DEBUG_LEVEL_NONE}" -lt "$DEBUG_LEVEL_3" ]; then
    return
  fi
  # Return extra debug info when running with bash, otherwise return empty
  # string.
  if [ -z "${BASH_VERSION}" ]; then
    return
  fi
  # We are a bash shell at this point, return the filename, function name, and
  # line number as a string
  _dbh_saveIFS=$IFS
  IFS=" "
  # Must use eval or syntax error happens under dash. The eval should use
  # single quotes as older versions of busybox had a bug with double quotes and
  # eval.
  # Use 'caller 1' as we want one level up the stack as we should be called
  # by one of the _debug* functions
  eval '_dbh_called=($(caller 1))'
  IFS=$_dbh_saveIFS
  eval '_dbh_file=${_dbh_called[2]}'
  if [ -n "${_script_home}" ]; then
    # Trim off the _script_home directory name
    eval '_dbh_file=${_dbh_file#$_script_home/}'
  fi
  eval '_dbh_function=${_dbh_called[1]}'
  eval '_dbh_lineno=${_dbh_called[0]}'
  printf "%-40s " "$_dbh_file:${_dbh_function}:${_dbh_lineno}"
}

_debug() {
  if [ "${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}" -ge "$LOG_LEVEL_1" ]; then
    _log "$@"
  fi
  if [ "${SYS_LOG:-$SYSLOG_LEVEL_NONE}" -ge "$SYSLOG_LEVEL_DEBUG" ]; then
    _syslog "$SYSLOG_DEBUG" "$@"
  fi
  if [ "${DEBUG:-$DEBUG_LEVEL_NONE}" -ge "$DEBUG_LEVEL_1" ]; then
    _bash_debug=$(__debug_bash_helper)
    _printargs "${_bash_debug}$@" >&2
  fi
}

#output the sensitive messages
_secure_debug() {
  if [ "${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}" -ge "$LOG_LEVEL_1" ]; then
    if [ "$OUTPUT_INSECURE" = "1" ]; then
      _log "$@"
    else
      _log "$1" "$HIDDEN_VALUE"
    fi
  fi
  if [ "${SYS_LOG:-$SYSLOG_LEVEL_NONE}" -ge "$SYSLOG_LEVEL_DEBUG" ]; then
    _syslog "$SYSLOG_DEBUG" "$1" "$HIDDEN_VALUE"
  fi
  if [ "${DEBUG:-$DEBUG_LEVEL_NONE}" -ge "$DEBUG_LEVEL_1" ]; then
    if [ "$OUTPUT_INSECURE" = "1" ]; then
      _printargs "$@" >&2
    else
      _printargs "$1" "$HIDDEN_VALUE" >&2
    fi
  fi
}

_debug2() {
  if [ "${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}" -ge "$LOG_LEVEL_2" ]; then
    _log "$@"
  fi
  if [ "${SYS_LOG:-$SYSLOG_LEVEL_NONE}" -ge "$SYSLOG_LEVEL_DEBUG_2" ]; then
    _syslog "$SYSLOG_DEBUG" "$@"
  fi
  if [ "${DEBUG:-$DEBUG_LEVEL_NONE}" -ge "$DEBUG_LEVEL_2" ]; then
    _bash_debug=$(__debug_bash_helper)
    _printargs "${_bash_debug}$@" >&2
  fi
}

_secure_debug2() {
  if [ "${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}" -ge "$LOG_LEVEL_2" ]; then
    if [ "$OUTPUT_INSECURE" = "1" ]; then
      _log "$@"
    else
      _log "$1" "$HIDDEN_VALUE"
    fi
  fi
  if [ "${SYS_LOG:-$SYSLOG_LEVEL_NONE}" -ge "$SYSLOG_LEVEL_DEBUG_2" ]; then
    _syslog "$SYSLOG_DEBUG" "$1" "$HIDDEN_VALUE"
  fi
  if [ "${DEBUG:-$DEBUG_LEVEL_NONE}" -ge "$DEBUG_LEVEL_2" ]; then
    if [ "$OUTPUT_INSECURE" = "1" ]; then
      _printargs "$@" >&2
    else
      _printargs "$1" "$HIDDEN_VALUE" >&2
    fi
  fi
}

_debug3() {
  if [ "${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}" -ge "$LOG_LEVEL_3" ]; then
    _log "$@"
  fi
  if [ "${SYS_LOG:-$SYSLOG_LEVEL_NONE}" -ge "$SYSLOG_LEVEL_DEBUG_3" ]; then
    _syslog "$SYSLOG_DEBUG" "$@"
  fi
  if [ "${DEBUG:-$DEBUG_LEVEL_NONE}" -ge "$DEBUG_LEVEL_3" ]; then
    _bash_debug=$(__debug_bash_helper)
    _printargs "${_bash_debug}$@" >&2
  fi
}

_secure_debug3() {
  if [ "${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}" -ge "$LOG_LEVEL_3" ]; then
    if [ "$OUTPUT_INSECURE" = "1" ]; then
      _log "$@"
    else
      _log "$1" "$HIDDEN_VALUE"
    fi
  fi
  if [ "${SYS_LOG:-$SYSLOG_LEVEL_NONE}" -ge "$SYSLOG_LEVEL_DEBUG_3" ]; then
    _syslog "$SYSLOG_DEBUG" "$1" "$HIDDEN_VALUE"
  fi
  if [ "${DEBUG:-$DEBUG_LEVEL_NONE}" -ge "$DEBUG_LEVEL_3" ]; then
    if [ "$OUTPUT_INSECURE" = "1" ]; then
      _printargs "$@" >&2
    else
      _printargs "$1" "$HIDDEN_VALUE" >&2
    fi
  fi
}

_upper_case() {
  # shellcheck disable=SC2018,SC2019
  tr 'a-z' 'A-Z'
}

_lower_case() {
  # shellcheck disable=SC2018,SC2019
  tr 'A-Z' 'a-z'
}

_startswith() {
  _str="$1"
  _sub="$2"
  echo "$_str" | grep "^$_sub" >/dev/null 2>&1
}

_endswith() {
  _str="$1"
  _sub="$2"
  echo "$_str" | grep -- "$_sub\$" >/dev/null 2>&1
}

_contains() {
  _str="$1"
  _sub="$2"
  echo "$_str" | grep -- "$_sub" >/dev/null 2>&1
}

_hasfield() {
  _str="$1"
  _field="$2"
  _sep="$3"
  if [ -z "$_field" ]; then
    _usage "Usage: str field  [sep]"
    return 1
  fi

  if [ -z "$_sep" ]; then
    _sep=","
  fi

  for f in $(echo "$_str" | tr "$_sep" ' '); do
    if [ "$f" = "$_field" ]; then
      _debug2 "'$_str' contains '$_field'"
      return 0 #contains ok
    fi
  done
  _debug2 "'$_str' does not contain '$_field'"
  return 1 #not contains
}

# str index [sep]
_getfield() {
  _str="$1"
  _findex="$2"
  _sep="$3"

  if [ -z "$_findex" ]; then
    _usage "Usage: str field  [sep]"
    return 1
  fi

  if [ -z "$_sep" ]; then
    _sep=","
  fi

  _ffi="$_findex"
  while [ "$_ffi" -gt "0" ]; do
    _fv="$(echo "$_str" | cut -d "$_sep" -f "$_ffi")"
    if [ "$_fv" ]; then
      printf -- "%s" "$_fv"
      return 0
    fi
    _ffi="$(_math "$_ffi" - 1)"
  done

  printf -- "%s" "$_str"

}

# Command check function [ complete version }
# check if a command exists
_exists() {
  cmd="$1"
  if [ -z "$cmd" ]; then
    _usage "Usage: _exists cmd"
    return 1
  fi

  if eval type type >/dev/null 2>&1; then
    eval type "$cmd" >/dev/null 2>&1
  elif command >/dev/null 2>&1; then
    command -v "$cmd" >/dev/null 2>&1
  else
    which "$cmd" >/dev/null 2>&1
  fi
  ret="$?"
  _debug3 "$cmd exists=$ret"
  return $ret
}

#a + b
_math() {
  _m_opts="$@"
  printf "%s" "$(($_m_opts))"
}

_h_char_2_dec() {
  _ch=$1
  case "${_ch}" in
    a | A)
      printf "10"
      ;;
    b | B)
      printf "11"
      ;;
    c | C)
      printf "12"
      ;;
    d | D)
      printf "13"
      ;;
    e | E)
      printf "14"
      ;;
    f | F)
      printf "15"
      ;;
    *)
      printf "%s" "$_ch"
      ;;
  esac

}

_URGLY_PRINTF=""
if [ "$(printf '\x41')" != 'A' ]; then
  _URGLY_PRINTF=1
fi

_ESCAPE_XARGS=""
if _exists xargs && [ "$(printf %s '\\x41' | xargs printf)" = 'A' ]; then
  _ESCAPE_XARGS=1
fi

_h2b() {
  if _exists xxd && xxd -r -p 2>/dev/null; then
    return
  fi

  hex=$(cat)
  ic=""
  jc=""
  _debug2 _URGLY_PRINTF "$_URGLY_PRINTF"
  if [ -z "$_URGLY_PRINTF" ]; then
    if [ "$_ESCAPE_XARGS" ] && _exists xargs; then
      _debug2 "xargs"
      echo "$hex" | _upper_case | sed 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/g' | xargs printf
    else
      for h in $(echo "$hex" | _upper_case | sed 's/\([0-9A-F]\{2\}\)/ \1/g'); do
        if [ -z "$h" ]; then
          break
        fi
        printf "\x$h%s"
      done
    fi
  else
    for c in $(echo "$hex" | _upper_case | sed 's/\([0-9A-F]\)/ \1/g'); do
      if [ -z "$ic" ]; then
        ic=$c
        continue
      fi
      jc=$c
      ic="$(_h_char_2_dec "$ic")"
      jc="$(_h_char_2_dec "$jc")"
      printf '\'"$(printf "%o" "$(_math "$ic" \* 16 + $jc)")""%s"
      ic=""
      jc=""
    done
  fi

}

_is_solaris() {
  _contains "${__OS__:=$(uname -a)}" "solaris" || _contains "${__OS__:=$(uname -a)}" "SunOS"
}

#_ascii_hex str
#this can only process ascii chars, should only be used when od command is missing as a backup way.
_ascii_hex() {
  _debug2 "Using _ascii_hex"
  _str="$1"
  _str_len=${#_str}
  _h_i=1
  while [ "$_h_i" -le "$_str_len" ]; do
    _str_c="$(printf "%s" "$_str" | cut -c "$_h_i")"
    printf " %02x" "'$_str_c"
    _h_i="$(_math "$_h_i" + 1)"
  done
}

#stdin  output hexstr splited by one space
#input:"abc"
#output: " 61 62 63"
_hex_dump() {
  if _exists od; then
    od -A n -v -t x1 | tr -s " " | sed 's/ $//' | tr -d "\r\t\n"
  elif _exists hexdump; then
    _debug3 "using hexdump"
    hexdump -v -e '/1 ""' -e '/1 " %02x" ""'
  elif _exists xxd; then
    _debug3 "using xxd"
    xxd -ps -c 20 -i | sed "s/ 0x/ /g" | tr -d ",\n" | tr -s " "
  else
    _debug3 "using _ascii_hex"
    str=$(cat)
    _ascii_hex "$str"
  fi
}

#url encode, no-preserved chars
#A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z
#41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a

#a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z
#61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a

#0  1  2  3  4  5  6  7  8  9  -  _  .  ~
#30 31 32 33 34 35 36 37 38 39 2d 5f 2e 7e

#stdin stdout
_url_encode() {
  _hex_str=$(_hex_dump)
  _debug3 "_url_encode"
  _debug3 "_hex_str" "$_hex_str"
  for _hex_code in $_hex_str; do
    #upper case
    case "${_hex_code}" in
      "41")
        printf "%s" "A"
        ;;
      "42")
        printf "%s" "B"
        ;;
      "43")
        printf "%s" "C"
        ;;
      "44")
        printf "%s" "D"
        ;;
      "45")
        printf "%s" "E"
        ;;
      "46")
        printf "%s" "F"
        ;;
      "47")
        printf "%s" "G"
        ;;
      "48")
        printf "%s" "H"
        ;;
      "49")
        printf "%s" "I"
        ;;
      "4a")
        printf "%s" "J"
        ;;
      "4b")
        printf "%s" "K"
        ;;
      "4c")
        printf "%s" "L"
        ;;
      "4d")
        printf "%s" "M"
        ;;
      "4e")
        printf "%s" "N"
        ;;
      "4f")
        printf "%s" "O"
        ;;
      "50")
        printf "%s" "P"
        ;;
      "51")
        printf "%s" "Q"
        ;;
      "52")
        printf "%s" "R"
        ;;
      "53")
        printf "%s" "S"
        ;;
      "54")
        printf "%s" "T"
        ;;
      "55")
        printf "%s" "U"
        ;;
      "56")
        printf "%s" "V"
        ;;
      "57")
        printf "%s" "W"
        ;;
      "58")
        printf "%s" "X"
        ;;
      "59")
        printf "%s" "Y"
        ;;
      "5a")
        printf "%s" "Z"
        ;;

      #lower case
      "61")
        printf "%s" "a"
        ;;
      "62")
        printf "%s" "b"
        ;;
      "63")
        printf "%s" "c"
        ;;
      "64")
        printf "%s" "d"
        ;;
      "65")
        printf "%s" "e"
        ;;
      "66")
        printf "%s" "f"
        ;;
      "67")
        printf "%s" "g"
        ;;
      "68")
        printf "%s" "h"
        ;;
      "69")
        printf "%s" "i"
        ;;
      "6a")
        printf "%s" "j"
        ;;
      "6b")
        printf "%s" "k"
        ;;
      "6c")
        printf "%s" "l"
        ;;
      "6d")
        printf "%s" "m"
        ;;
      "6e")
        printf "%s" "n"
        ;;
      "6f")
        printf "%s" "o"
        ;;
      "70")
        printf "%s" "p"
        ;;
      "71")
        printf "%s" "q"
        ;;
      "72")
        printf "%s" "r"
        ;;
      "73")
        printf "%s" "s"
        ;;
      "74")
        printf "%s" "t"
        ;;
      "75")
        printf "%s" "u"
        ;;
      "76")
        printf "%s" "v"
        ;;
      "77")
        printf "%s" "w"
        ;;
      "78")
        printf "%s" "x"
        ;;
      "79")
        printf "%s" "y"
        ;;
      "7a")
        printf "%s" "z"
        ;;
      #numbers
      "30")
        printf "%s" "0"
        ;;
      "31")
        printf "%s" "1"
        ;;
      "32")
        printf "%s" "2"
        ;;
      "33")
        printf "%s" "3"
        ;;
      "34")
        printf "%s" "4"
        ;;
      "35")
        printf "%s" "5"
        ;;
      "36")
        printf "%s" "6"
        ;;
      "37")
        printf "%s" "7"
        ;;
      "38")
        printf "%s" "8"
        ;;
      "39")
        printf "%s" "9"
        ;;
      "2d")
        printf "%s" "-"
        ;;
      "5f")
        printf "%s" "_"
        ;;
      "2e")
        printf "%s" "."
        ;;
      "7e")
        printf "%s" "~"
        ;;
      #other hex
      *)
        printf '%%%s' "$_hex_code"
        ;;
    esac
  done
}

_json_encode() {
  _j_str="$(sed 's/"/\\"/g' | sed "s/\r/\\r/g")"
  _debug3 "_json_encode"
  _debug3 "_j_str" "$_j_str"
  echo "$_j_str" | _hex_dump | _lower_case | sed 's/0a/5c 6e/g' | tr -d ' ' | _h2b | tr -d "\r\n"
}

#options file
_sed_i() {
  options="$1"
  filename="$2"
  if [ -z "$filename" ]; then
    _usage "Usage:_sed_i options filename"
    return 1
  fi
  _debug2 options "$options"
  if sed -h 2>&1 | grep "\-i\[SUFFIX]" >/dev/null 2>&1; then
    _debug "Using sed  -i"
    sed -i "$options" "$filename"
  else
    _debug "No -i support in sed"
    text="$(cat "$filename")"
    echo "$text" | sed "$options" >"$filename"
  fi
}

_egrep_o() {
  if ! egrep -o "$1" 2>/dev/null; then
    sed -n 's/.*\('"$1"'\).*/\1/p'
  fi
}

#Usage: file startline endline
_getfile() {
  filename="$1"
  startline="$2"
  endline="$3"
  if [ -z "$endline" ]; then
    _usage "Usage: file startline endline"
    return 1
  fi

  i="$(grep -n -- "$startline" "$filename" | cut -d : -f 1)"
  if [ -z "$i" ]; then
    _err "Can not find start line: $startline"
    return 1
  fi
  i="$(_math "$i" + 1)"
  _debug i "$i"

  j="$(grep -n -- "$endline" "$filename" | cut -d : -f 1)"
  if [ -z "$j" ]; then
    _err "Can not find end line: $endline"
    return 1
  fi
  j="$(_math "$j" - 1)"
  _debug j "$j"

  sed -n "$i,${j}p" "$filename"

}

#Usage: multiline
_base64() {
  [ "" ] #urgly
  if [ "$1" ]; then
    _debug3 "base64 multiline:'$1'"
    ${ACME_OPENSSL_BIN:-openssl} base64 -e
  else
    _debug3 "base64 single line."
    ${ACME_OPENSSL_BIN:-openssl} base64 -e | tr -d '\r\n'
  fi
}

#Usage: multiline
_dbase64() {
  if [ "$1" ]; then
    ${ACME_OPENSSL_BIN:-openssl} base64 -d -A
  else
    ${ACME_OPENSSL_BIN:-openssl} base64 -d
  fi
}
