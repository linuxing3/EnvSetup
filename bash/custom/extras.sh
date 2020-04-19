 
RCol='\e[0m'   
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

alias nis="npm install --save "
alias svim='sudo vim'

alias install='sudo apt get install'
alias update='sudo apt-get update; sudo apt-get upgrade'

alias ..="cd .."
alias ...="cd ..; cd .."

alias www='python -m SimpleHTTPServer 8000'

alias sock5='ssh -D 8080 -q -C -N -f root@xunqinji.top'

alias caddystatus="ssh root@xunqinji.top 'bash -s' < local.script.sh"
alias trojanstatus="ssh root@xunqinji.top ARG1="arg1" ARG2="arg2" 'bash -s' < local_script.sh"

function params() {
  while [ "$1" != "" ]; do
      case $1 in
          -s  )   shift
                  SERVER=$1 ;;
          -d  )   shift
                  DATE=$1 ;;
          --paramter|p ) shift
                  PARAMETER=$1;;
          -h|help  )   usage # function call
                  exit ;;
          * )     usage # All other parameters
                  exit 1
      esac
      shift
  done
}


function selectmenu() {
  PS3='Please enter your choice: '
  options=("Option 1" "Option 2" "Option 3" "Quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "Option 1")
              echo "you chose choice 1"
              ;;
          "Option 2")
              echo "you chose choice 2"
              ;;
          "Option 3")
              echo "you chose choice $REPLY which is $opt"
              ;;
          "Quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}


function abspath() {
  FILE="$0"
  while [[ -h ${FILE} ]]; do
      FILE="`readlink "${FILE}"`"
  done
  pushd "`dirname "${FILE}"`" > /dev/null
  DIR=`pwd -P`
  popd > /dev/null
}


function gnudate() {
    if hash gdate 2> /dev/null; then
        gdate "$@"
    else
        date "$@"
    fi
}
