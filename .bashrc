# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -n "$DBRC_SOURCED" ]
then
    return
fi
DBRC_SOURCED=1

export HOST=`hostname`

# per-system config and whatnot; created by user
# if anything is absent bash will print a warning
# for now, DBRC_USEFUCK and DBRC_USENE are expected
source $HOME/.bashrc_system

source $HOME/.bashrc_history
source $HOME/.bashrc_prompt
source $HOME/.bashrc_colors
source $HOME/.bashrc_aliases

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# useful
shopt -s cdspell

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export GPG_TTY=$(tty)

if [ -n "$DBRC_USENE" ]
then
    if [ -z "$TMUX" ]
    then
        if [ -z "$DBR_NEOFETCHCALLED" ]
        then
            neofetch
            DBR_NEOFETCHCALLED=1
        fi
    fi
fi

