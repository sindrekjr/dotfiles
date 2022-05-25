## custom stuff
source $HOME/sh/auto-ssh-agent.sh
source $HOME/sh/kube-ps1.sh

# aliases
alias gitdir='cd $GITDIR'

# PS1
case "$TERM" in
    xterm-color|*-256color) colours=yay;;
esac

if [ "$colours" = yay ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[00m\] `kube_ps1`\n$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \w `__git_ps1` `kube_ps1`\n$ '
fi
unset colours

# set GPG_TTY for gpgsigning in wsl shell
export GPG_TTY=$(tty)
