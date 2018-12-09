gitstatus() {
  if [ "$#" -ne 0 ]; then
    git "$@"
  else
    git status
  fi
}

alias g=gitstatus
