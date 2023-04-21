#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

description=$(cat $SCRIPTPATH/README.md)
delay=390

while getopts "i:u:p:d:h" opt; do
  case $opt in
    i)
      ip="$OPTARG"
      ;;
    u)
      username="$OPTARG"
      ;;
    p)
      password="$OPTARG"
      ;;
    d)
      delay="$OPTARG"
      ;;
    h)
      titles=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "$description"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      echo "$description"
      exit 1
      ;;
  esac
done

if [ -z "$ip" ] || [ -z "$username" ] || [ -z "$password" ]; then
  echo "IP, username or password is missing!\n\n"
  echo "$description"
  exit 1
fi

# Keys in javascript code of html status.html page
declare -a keys=(
    'webdata_now_p'
    'webdata_today_e'
    'webdata_total_e'
)

if [ "$titles" == true ]; then
  echo "date,$(printf "%s," "${keys[@]}")" | sed 's/,$//'
fi

while true
do
    output=()
    output+=($(date +%FT%T));
    response=$(curl http://$ip/status.html -s -u "$username:$password")
    for key in "${keys[@]}"
    do
        value=$(echo "$response" | grep -oE "var $key = \"([0-9\.]+)\";" | cut -d'"' -f2)
        output+=("$value")
    done

    # if data received, then there was (date + keys.length)
    if [ "${#output[@]}" -gt 1 ]; then
      echo $(printf "%s," "${output[@]}") | sed 's/,$//'
    fi

    sleep $delay
done