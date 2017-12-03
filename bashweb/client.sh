#!/usr/bin/env bash
logmsg(){
  printf "%s" "$@" >> client.log
}
[ -z $2 ] && PORT=8081
HOST=${1}
[ -z "${1}" ] && HOST=localhost
exec 3<> /dev/tcp/${HOST##*://}/${PORT}
logmsg "GET /%s HTTP/1.1\r\n" index.html
printf "GET /%s HTTP/1.1\r\n" index.html
logmsg "%s Host: %s\r\n" "${HOST}" 
printf "%s Host: %s\r\n" "${HOST}" 
logmsg "\r\n"
printf "\r\n"
cat <&3
