#!/bin/bash

description=$(cat README.md)
delay=5

while getopts "i:u:p:d:h:" opt; do
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
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z "$ip" ] || [ -z "$username" ] || [ -z "$password" ]; then
  echo "IP, username or password is missing.\n"
  echo "$description"
  exit 1
fi

# Keys in javascript code if page
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
    declare -a keys=(
        'webdata_now_p'
        'webdata_today_e'
        'webdata_total_e'
    )
    output=()
    output+=($(date "+%Y-%m-%d %H:%M:%S"));
    response=$(curl http://$ip/status.html -s -u "$username:$password")
    for key in "${keys[@]}"
    do
        value=$(echo "$response" | grep -oE "var $key = \"([0-9]+)\";" | cut -d'"' -f2)
        output+=("$value")
    done

    # if data received, then there was (date + keys.length)
    if [ "${#output[@]}" -gt 1 ]; then
      echo echo $(printf "%s," "${output[@]}") | sed 's/,$//'
    fi

    sleep $delay
done