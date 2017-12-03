# Bash web server and client

Do not actually use this for anything.
It is a simple bash scripting example.

## Tips

* both the client and server should be sending CRLF rather than just LF
* the current implementation does not fully follow this requirement
* access to parent directory `..` and shell escapes is not done.
* test first with just netcat as the client or netcat as the server
* once that part is working, use `curl` or `wget` as a client.
* some versions of netcat do not allow the `-e` parameter.
