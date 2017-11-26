#!/usr/bin/env bash
#read
#echo "HTTP/1.1 200 OK"
#echo 
#echo Hello!  
#exit 0
# [ "${1}" = "serve" ] && { netcat -lp 8080 -e ./${0}; exit; }
set -x
[ "${1}" = "serve" ] && { socat TCP4-LISTEN:8080 EXEC:${0}; exit; }

while read -t 30 x; do 
  x=${x//$'\r'}
  echo "received: ${x}" >> rawlog.log
  [[ $x =~ GET\ .* ]] && {
    echo "received a get request: ${x}" >> logfile.log
    GETREQUEST="${x#GET /}"
    GETREQUEST="${GETREQUEST%HTTP/1.1}"
    #cat headers.txt
    #cat ${GETREQUEST}
    #exit 0
  }
  [[ $x =~ Host:.* ]] && {
    echo "`date` received host line: ${x}" >> logfile.log
  }
  [ -z "${x}" ] && {
    [ -e $GETREQUEST ] || exit 0
    echo "`date` Sending ${GETREQUEST}" >> logfile.log
    echo $'HTTP/1.0 200 OK\r'
    echo $'HTTP/1.0 200 OK\r' >> logfile.log
    echo "Content-Length:`stat -c "%s" ${GETREQUEST}`"
    echo 
    cat $GETREQUEST
    exit 0
  }
done
