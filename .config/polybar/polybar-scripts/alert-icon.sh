#!/bin/bash

#set -x

dunst_running="$(ps aux | grep dunst | grep -v grep)"

if [[ -z `echo $dunst_running` ]]; then
	echo 'X'
	exit 0;
fi

if [[ $(dunstctl is-paused) == false ]]; then
	echo ' '
else
	echo ' '
fi
#set +x
