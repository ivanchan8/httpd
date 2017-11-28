#!/usr/bin/env bash
#read
#echo "HTTP/1.1 200 OK"
#echo 
#echo Hello!  
#exit 0
# [ "${1}" = "serve" ] && { netcat -lp 8080 -e ./${0}; exit; }
set -x  # comment this line out to turn off debug trace output
[ "${1}" = "serve" ] && { socat TCP4-LISTEN:8080 EXEC:${0}; exit; }

# read input line into variable x, with 30 second timeout
while read -t 30 x; do 
  # replace end of line with \r
  x=${x//$'\r'}         
  echo "received: ${x}" >> rawlog.log
  [[ $x =~ GET\ .* ]] && {
    echo "received a get request: ${x}" >> logfile.log
    GETREQUEST="${x#GET /}"
    GETREQUEST="${GETREQUEST%HTTP/1.1}"
  }
  [[ $x =~ Host:.* ]] && {
    echo "`date` received host line: ${x}" >> logfile.log
  }
  # detect empty line (end of client headers), and try to send response
  [ -z "${x}" ] && {
    [ -e $GETREQUEST ] || exit 0
    echo "`date` Sending ${GETREQUEST}" >> logfile.log
    # report successful get request
    echo $'HTTP/1.0 200 OK\r'
    echo $'HTTP/1.0 200 OK\r' >> logfile.log
    # report file size
    echo "Content-Length:`stat -c "%s" ${GETREQUEST}`"
    # send empty line to client to signal end of headers
    echo 
    # output requested file
    cat $GETREQUEST
    exit 0
  }
done
