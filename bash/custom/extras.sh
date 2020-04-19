###############################
## Basic tools
###############################

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

function search() {
  sed -n "1,\$p" $1 | grep -m10 -nF $2
}

function init-org-home-directory() {

  today=$(date +%Y-%m-%d-%s)
  cd
  tar cvf "org.$today.tar" org
  rm -rf ~/org
  mkdir -p org
  cd org
  for dir in attach journal roam brain
  do
    rm -f $dir
    mkdir -p $dir
  done

  for file in inbox links snippets tutorials projects
  do
    rm -f "$file.org"
    touch "$file.org"
    echo "* $file org file created $today\n" >> "$file.org" 
  done
  echo "Done! Created org home directory!"
}
