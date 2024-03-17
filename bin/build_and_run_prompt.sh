#!/usr/bin/env bash

# This script exists for the sole reason that I don't want to
# upload binary files (in this case, the logoutprompt executable) to github.

CC="gcc"
CFLAGS="-O2"

if ! [ -e "$HOME/bin/logoutprompt" ] || [ "$HOME/bin/logoutprompt.c" -nt "$HOME/bin/logoutprompt" ]
then
    "$CC" $CFLAGS $HOME/bin/logoutprompt.c -o $HOME/bin/logoutprompt
fi

if [ "$1" == "DEBUG" ]
then
    $HOME/bin/logoutprompt $HOME/bin/debugitems
else
    $HOME/bin/logoutprompt $HOME/bin/promptitems
fi

