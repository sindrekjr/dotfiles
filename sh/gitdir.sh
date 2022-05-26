gitdir() {
  if [ -z $GITDIR ]; then
    printf "error: GITDIR is not set\n" >&2
    return
  fi

  cd $GITDIR/$1
}

# gitdir autocompletion for subdirectories
_gitdir_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local files=$(ls $GITDIR)
  COMPREPLY=($(compgen -W "$files" -- $cur))
}

complete -F _gitdir_complete gitdir
