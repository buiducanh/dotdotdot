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
alias wopen='cmd.exe /C start '

# begin:Journaling
function openJournal() {
  offset="$1"
  JOURNAL_DIR='/Volumes/GoogleDrive/My Drive/journal'
  year=$(date +%Y)
  month=$(date +%b)
  weekofm=$(echo $((($(date +%-d)-1)/7+1)))
  file=
  if [[ -z "$offset" ]]; then
    file=$(date +"%a %b %d %Y")
  else
    file=$(date -v "-$offset""d" +"%a %b %d %Y")
  fi
  newentry="$JOURNAL_DIR/$year/$month/$weekofm/$file.md"
  journaldir=$(dirname "$newentry")
  mkdir -p "$journaldir"
  echo "$newentry"
}

function vimJournal() {
  d="$1"
  vim "$(openJournal $1)"
}
# endn:Journaling
