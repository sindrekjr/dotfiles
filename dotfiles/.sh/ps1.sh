if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) colours=yay;;
esac

## build PS1
PS1='\n${debian_chroot:+($debian_chroot)}'

# directory
if [ "$colours" = yay ] ; then
    PS1+="\[\033[33m\]\w\[\033[36m\]"
else
    PS1+="\w"
fi

# git
PS1+='`__git_ps1`'
if [ "$colours" = yay ] ; then
    PS1+="\[\033[00m\]"
fi

# kube
if [ -f "$HOME/.kube/.sh/kube-ps1.sh" ] ; then
    source $HOME/.kube/.sh/kube-ps1.sh
    PS1+=' `kube_ps1`'
fi

# host
#PS1+="\n\[\033[32m\]\u@\h\[\033[00m\]"

# user
PS1+="\n\[\033[32m\]\u\[\033[00m\]"

# prompt
PROMPTS=("💻" "☕" "🎮" "💡" "🐧" "🚀" "🌰" "🔧" "🔑" "📝" "🔎" "💾" "⚡")
PS1+=" ${PROMPTS[RANDOM % ${#PROMPTS[@]}]} "

unset colours
