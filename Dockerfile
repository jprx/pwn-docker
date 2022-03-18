FROM ubuntu:20.04
LABEL maintainer="ImFaisalKhalid"

# Note: I shamelessly stole this from Ravi and modified it :)

# Some stuff borrowed from:
# https://github.com/owlinux1000/docker_pwn/blob/master/Dockerfile

# This command installs a bunch of packages
RUN DEBIAN_FRONTEND="noninteractive" dpkg --add-architecture i386 && \
    DEBIAN_FRONTEND="noninteractive" apt-get update -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y \ 
    strace \
    ltrace \ 
    gdb \
    gdb-multiarch \
    gcc \
    gdbserver \
    libc6-dbg \
    libc6-dbg:i386 \
    gcc-multilib \
    g++-multilib \
    curl \
    wget \
    make \
    python3 \
    python3-pip \
    vim \
    binutils \
    ruby \
    ruby-dev \
    netcat \
    tmux \
    git \
    file \
    iputils-ping \
    patchelf \
    zsh

# This command installs a bunch of Python packages
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install pwntools \
    ropgadget \
    z3-solver \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe

# Sets config settings for GDB, VIM, and TMUX
RUN echo "set confirm off" >> ~/.gdbinit && \
    echo "set pagination off" >> ~/.gdbinit && \
    echo "set disassembly-flavor intel" >> ~/.gdbinit && \
    echo "set number\nsyntax on\nset showmatch\nset ruler\nset autoindent\nset shiftwidth=4\nset smartindent\nset smarttab\nset softtabstop=4\nset foldcolumn=1" >> ~/.vimrc && \
    echo "inoremap { {}<Esc>ha\ninoremap ( ()<Esc>ha\ninoremap [ []<Esc>ha" >> ~/.vimrc && \
    echo "set -g mouse on" >> ~/.tmux.conf
 
# This installs GEF for gdb support and ohmyzsh for terminal theme support (along with plugins for autosuggestion and command highlighting)
RUN wget -O ~/.gdbinit-gef.py -q https://github.com/hugsy/gef/raw/master/gef.py && \ 
    echo source ~/.gdbinit-gef.py >> ~/.gdbinit && \
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    chsh -s $(which zsh) && \
    cd ~/.oh-my-zsh/custom/plugins && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

# Changes theme, adds the zsh plugins, and changes prompt to add Ravi's name
# NOTE: To change zsh theme, just change 'apple' on first line to theme of choice
# NOTE: To change prompt (apple icon and 'SIGPwny'), change it in second line after second echo
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="apple"/' ~/.zshrc && \
    sed -i 's/echo -n ""/echo -n " SIGPwny ->"/' ~/.oh-my-zsh/themes/apple.zsh-theme && \
    sed -i 's/plugins=(git)/plugins=(zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc && \
    zsh

# Copy setup file to container and change starting directory to /pwn
COPY ./setup /usr/bin/
WORKDIR /pwn

# Tmux is needed for GDB when running 2 programs
CMD tmux
