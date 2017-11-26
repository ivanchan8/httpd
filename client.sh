#!/usr/bin/env bash
# parse url
[ -n "${1}" ] && url="${1}" || url="http://localhost/index.html"

protocol="${1}/^http[s]?\/\/\.*$/


set -x
[ -z $2 ] && PORT=8081 || PORT=${2}
HOST=${1}
[ -z "${1}" ] && HOST=localhost
exec 3<> /dev/tcp/${HOST##*://}/${PORT}
printf "GET /%s HTTP/1.1\r\n" index.html | tee -a client.log
printf "%s Host: %s\r\n" "${HOST}" | tee -a client.log
printf "\r\n" | tee -a client.log
cat <&3
