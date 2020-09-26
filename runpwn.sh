#!/bin/bash

# rm it: Delete container after use
# volume: Mount shared folder
# e LANG.CUTF-8: To get pwntools to stop complaining about UTF8
# security-opt seccomp=unconfined: So GDB can turn off ASLR
docker run --rm -it \
	--volume="`pwd`:/pwn:rw" \
	-e LANG=C.UTF-8 \
	--security-opt seccomp=unconfined \
	pwncontainer # pwncontainer = my pwn container
