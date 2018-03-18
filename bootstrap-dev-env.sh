#!/usr/bin/env bash

# Bootstrap development environment on a new compute node

sudo apt-get update && sudo apt-get install emacs git unzip

if [[ ! -d ~/dot-emacs ]] 
then
	(cd ~ && git clone https://github.com/MonadicT/dot-emacs.git)
else
	(cd ~/dot-emacs && git pull)
fi
