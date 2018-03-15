#!/usr/bin/env bash


# Copyright (c) 2018, Praki Prakash <praki.prakash@gmail.com>. Some rights reserved.

# Bash utility functions. Some dependency on Ubuntu package management (for now)


# Query if package is installed
# Globals:
#   None
# Arguments:
#   package
# Returns:
#   Nothing
install_if_needed() {
    dpkg-query -W $1 > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
        sudo apt-get install $1
    fi
}

# Install an NPM package when it's not installed
# Globals:
#   None
# Arguments:
#   package or -g package
# Returns:
#   Nothing
npm_install_if_needed() {
    if [ $1 == '-g' ]
    then
        npm list $* || sudo npm install $*
    else
        npm list $* || npm install $*
    fi
}

# Download a HTTP resource unless it's already in ${DOWNLOAD_DIR} directory
# Globals:
#   DOWNLOAD_DIR
# Arguments:
#   HTTP resource
# Returns:
#   Nothing
download_if_needed() {
    if [ -z ${DOWNLOAD_DIR}/$1 ]; then
        wget -P ${DOWNLOAD_DIR} $1
    fi
}

# https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path
pathadd() {
    newelement=${1%/}
    if [ -d "$1" ] && ! echo $PATH | grep -E -q "(^|:)$newelement($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH="$PATH:$newelement"
        else
            PATH="$newelement:$PATH"
        fi
    fi
}

pathrm() {
    PATH="$(echo $PATH | sed -e "s;\(^\|:\)${1%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}
