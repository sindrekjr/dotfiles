## custom stuff
source $HOME/scripts/bash/auto-ssh-agent

# aliases
alias gitdir='cd $GITDIR'

# PS1
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[00m\]\n$ '

# set GPG_TTY for gpgsigning in wsl shell
export GPG_TTY=$(tty)
