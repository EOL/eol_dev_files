# ~/.bashrc: executed by bash(1) for non-login shells.
#  see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases_private ]; then
    . ~/.bash_aliases_private
fi

# enable color support of ls and also add handy aliases
#if [ "$TERM" != "dumb" ]; then
#    eval "`dircolors -b`"
#    alias ls='ls -G'
#    alias dir='ls --color=auto --format=vertical'
#    alias vdir='ls --color=auto --format=long'
#fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
#export JAVA_HOME=/usr
export JRUBY_HOME=/usr/local/jruby
export EC2_HOME=/usr/local/ec2-api-tools
export SVN_EDITOR=vim
export EDITOR=vim
export LC_CTYPE=en_US.UTF-8

# MacPorts

export PATH=/opt/local/bin:/opt/local/sbin:$HOME/bin:/usr/local/bin:$PATH:$JRUBY_HOME/bin:$EC2_HOME/bin
# export PATH=$HOME/bin:/usr/local/bin:$PATH:$JRUBY_HOME/bin:$EC2_HOME/bin
export MANPATH=/opt/local/share/man:$MANPATH
export CDPATH=.:~/code
export RUBYOPT="-rubygems"
export GEM_EDITOR="mvim"
export NODE_PATH=/usr/local/lib/node_modules

# Terminal colours (after installing GNU coreutils)
NM="\[\033[0;38m\]" #means no background and white lines
HI="\[\033[0;33m\]" #change this for letter colors
HII="\[\033[0;31m\]" #change this for letter colors
SI="\[\033[0;33m\]" #this is for the current directory
IN="\[\033[0m\]"

PS1='\[\033[01;34m\]\w\[\033[00m\]\$$IN '
export PS1="$HI\u $HI\h $HI\w$HI $IN"
export JEWELER_OPTS="--rspec --cucumber"


# fix colors for OS X
export LSOPTIONS=" -G "
export CLICOLOR=YES
export LSCOLORS=dxfxcxdxbxegedabagacad

if [ -f $HOME/.git_colors ]; then
  . $HOME/.git_colors
fi

if [[ -s $HOME/.rvm/scripts/rvm ]] ; then source $HOME/.rvm/scripts/rvm ; rvm default ; fi
