# x86-64 Assembly HTTP Server

A minimal HTTP/1.0 server written entirely in x86-64 assembly 
using raw Linux syscalls — no libc, no dependencies.

## How it works

- Creates a TCP socket and binds to port 0x5000 (20480)
- Forks a child process per connection
- Supports GET (read and serve a file) and POST (write to a file)

## Build

```bash
as --64 web_server.as -o web_server.o
ld web_server.o -o web_server

OR

./runas.sh web_server
```

## Run

```bash
./web_server
```

Then in another terminal:
```bash
curl http://localhost:20480/yourfile.txt
curl -X POST --data "hello" http://localhost:20480/yourfile.txt
```

## Syscalls used

socket, bind, listen, accept, fork, read, write, open, close, exit

## Known limitations

- No path sanitization — path traversal is possible
- No bounds checking on the request buffer
- Zombie processes accumulate (no SIGCHLD handler / wait())
- GET truncates files larger than 256 bytes
- No error handling on open() failures
- POST doesn't truncate existing files before writing

