FROM ubuntu:20.10

# Some stuff borrowed from:
# https://github.com/owlinux1000/docker_pwn/blob/master/Dockerfile

RUN DEBIAN_FRONTEND="noninteractive" dpkg --add-architecture i386 && \
    DEBIAN_FRONTEND="noninteractive" apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y strace socat gdb gdb-multiarch gcc libc6-dbg libc6-dbg:i386 gcc-multilib g++-multilib curl wget make libssl-dev python3 python3-pip vim git binutils ruby ruby-dev netcat tmux
RUN python3 -m pip install pwntools ropper keystone-engine gdbgui

# peda
# RUN git clone https://github.com/longld/peda.git ~/peda
# RUN echo "source ~/peda/peda.py" >> ~/.gdbinit

RUN echo "set confirm off" >> ~/.gdbinit
RUN echo "set pagination off" >> ~/.gdbinit
RUN echo "set disassembly-flavor intel" >> ~/.gdbinit

# install gef
RUN sh -c "$(curl -fsSL http://gef.blah.cat/sh)"

RUN gem install one_gadget

RUN echo "set number\nsyntax on" >> ~/.vimrc
RUN echo "set -g mouse on" >> ~/.tmux.conf

COPY ./setup /usr/bin/

WORKDIR /pwn

# Tmux is needed for pwntools in docker
# Specifically, when using GDB on a running program 2 terminals are required
CMD tmux
# CMD /bin/bash
