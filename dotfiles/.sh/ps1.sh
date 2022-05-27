if [ -f "$HOME/kube-ps1/kube-ps1.sh" ] ; then
    source $HOME/kube-ps1/kube-ps1.sh
    kube='`kube_ps1`'
fi

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) colours=yay;;
esac

## build PS1
PS1='${debian_chroot:+($debian_chroot)}'

# directory
if [ "$colours" = yay ] ; then
    PS1="$PS1\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[33m\]\w\[\033[36m\]"
else
    PS1="$PS1\u@\h \w"
fi

# git
git='`__git_ps1`'
PS1="$PS1$git"
if [ "$colours" = yay ] ; then
    PS1="$PS1\[\033[00m\]"
fi

# kube
PS1="$PS1 $kube"

# prompt
PS1="$PS1\n$ "

unset colours
