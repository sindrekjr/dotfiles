gitdir() {
  if [ -z $GITDIR ]; then
    printf "\033[31merror: GITDIR is not set\033[0m\n" >&2
    return
  fi

  if [ -d $GITDIR/$1 ]; then
    cd $GITDIR/$1
    return
  fi

  local targets=($(find $GITDIR -type d -name .git -prune | sed "s|$GITDIR/||" | sed "s|/.git$||" | grep "/$1$"))
  local count=${#targets[@]}

  if [ $count -eq 0 ]; then
    printf "\033[31merror: could not find git repository matching '$1'\033[0m\n" >&2
    return 1
  elif [ $count -eq 1 ]; then
    cd $GITDIR/${targets[0]}
  else
    for i in ${!targets[@]}; do
      echo -e "\033[1;32m[$((i + 1))]\033[0m \033[33m${targets[$i]}\033[0m"
    done
    read -p "Select repository (1-$((count))): " selection
    if [[ $selection =~ ^[0-9]+$ ]] && [ $selection -ge 1 ] && [ $selection -le $count ]; then
      cd $GITDIR/${targets[$((selection - 1))]}
    else
      printf "\033[31merror: invalid selection\033[0m\n" >&2
      return 1
    fi
  fi
}

# gitdir autocompletion for subdirectories
_gitdir_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local base_paths=$(find $GITDIR -type d -name .git -prune | sed "s|$GITDIR/||" | sed "s|/.git$||" | sort -u)

  if [[ $cur == */* ]]; then
    local prefix=${cur%/*}/
    local remainder=${cur##*/}
    local matches=$(echo "$base_paths" | grep "^$prefix" | sed "s|^$prefix||")
    COMPREPLY=($(compgen -W "$matches" -- "$remainder"))
  else
    local matches=$(echo "$base_paths" | grep -o "[^/]*$")
    COMPREPLY=($(compgen -W "$matches" -- "$cur"))
  fi
}

complete -F _gitdir_complete gitdir
