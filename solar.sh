#!/bin/bash

description=$(cat <<EOF
Logs the current watt produced by the inverter.
Successfully tested with: deye sun600g3-eu-230 Micro Inverter (e.g. https://www.juskys.de/balkonkraftwerk-mit-2-solarmodulen-wechselrichter-ac-kabel.html).

Parameters:
  -i IP address of the inverter
  -u Username of the web interface
  -p Password of the web interface
  [-d] Delay between measurements in seconds; default is 5s

Example:
  sh solar.sh -i 192.168.178.55 -u admin -p admin -d 1
EOF
)
delay=5

while getopts "i:u:p:d:" opt; do
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

declare -a keys=(
    'webdata_now_p'
    'webdata_today_e'
    'webdata_total_e'
)

echo "date,$(printf "%s," "${keys[@]}")"
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
    echo echo $(printf "%s," "${output[@]}")  | sed 's/,$//'

    sleep $delay
done