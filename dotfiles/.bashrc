## standard stuff
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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


## custom stuff
source $HOME/.sh/auto-ssh-agent.sh
source $HOME/.sh/gitdir.sh
source $HOME/.sh/kube.sh
source $HOME/.sh/ps1.sh
source $HOME/.sh/nvm.sh

# inject environment variables
if [ -f ~/.env ]; then
  while IFS= read -r line 
  do
    if [[ "$line" == \#* ]] || [[ "$line" == "" ]]; then
      continue
    fi

    name="${line%%=*}"
    value="${line#*=}"

    # if a value starts with WIN:, assume WSL and fetch variable from Windows
    if [[ "$value" == WIN:* ]]; then
      cd /mnt/c
      win_value=$(/mnt/c/Windows/System32/cmd.exe /C "echo %${value#WIN:}%" | tr -d '\r')
      export "${name}=${win_value}"
    else
      export "${name}=${value}"
    fi
  done < ~/.env
fi
cd ~

# set GPG_TTY for gpgsigning in wsl shell
export GPG_TTY=$(tty)

# add kubectl krew to path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# default completion behavior for cd
compopt -o bashdefault cd

# mcfly
if command -v mcfly >/dev/null 2>&1; then
    eval "$(mcfly init bash)"
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi
