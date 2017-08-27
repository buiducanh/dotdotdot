gitstatus() {
  if [ "$#" -ne 0 ]; then
    git "$@"
  else
    git status
  fi
}

alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'
alias g=gitstatus
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias ggsync='(cd ~/Google\ Drive && grive)'
alias code='/mnt/c/Program\ Files\ \(x86\)/Microsoft\ VS\ Code/Code.exe'
alias win32yank='/usr/local/bin/win32yank'
