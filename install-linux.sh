#!/bin/bash

if [[ $EUID != 0 ]]; then
  sudo "$0" "$@"
  exit $?
fi

install() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y "$@"
  fi
}

symlinkSafe() {
  target="$1"
  dest="$2"
  tmpdest="$dest"".orig"
  if  [[ -e "$dest" ]]; then
    if [[ ! -L "$dest" ]]; then
      mv "$dest" "$tmpdest"
    fi
  fi
  ln -sf "$target" "$dest"
}

uninstall() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get remove -y "$@"
  fi
}

# echo "Set up xsel"

# if ! command -v xsel >/dev/null 2>&1; then
#   install xsel
# fi
# if ! command -v xclip >/dev/null 2>&1; then
#   uninstall xclip
# fi

sudo apt-get update -y
if ! command -v git >/dev/null 2>&1; then
  echo "Install git"
  install git
  name=$(read -p "input your name for Git: ")
  email=$(read -p "input your email for Git: ")
  /usr/bin/git config --global user.name "$name"
  /usr/bin/git config --global user.email "$email"
  if [[ ! -f ~/.ssh/id_rsa ]]; then
    echo "Prepare git ssh key"
    ssh-keygen -t rsa -b 4096 -c "$email"
  fi
fi
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

if ! command -v keychain >/dev/null 2>&1; then
  echo "Install keychain"
  install keychain
fi

echo "Prepare projects directory"
mkdir -p ~/projects

echo "Prepare dotfiles"
if [[ ! -d "$HOME/projects/dotdotdot" ]]; then
  git clone git@github.com:buiducanh/dotdotdot.git ~/projects/
else
  (cd ~/projects/dotdotdot && git pull)
fi

echo "Prepare build toolchains"
if ! command -v make >/dev/null 2>&1; then
  install build-essential
fi

if ! command -v aclocal >/dev/null 2>&1; then
  install autotools-dev
  install automake
fi

echo "Prepare .ssh config"
symlinkSafe ~/projects/dotdotdot/.ssh/config ~/.ssh/config
chown "$USER":"$USER" ~/.ssh/config

echo "Prepare git prompt"
symlinkSafe ~/projects/dotdotdot/git-prompt.sh ~/.git-prompt.sh

echo "Prepare bashrc"
symlinkSafe ~/projects/dotdotdot/.bashrc ~/.bashrc

echo "Prepare bash_aliases"
symlinkSafe ~/projects/dotdotdot/.bash_aliases ~/.bash_aliases

echo "Prepare inputrc"
symlinkSafe ~/projects/dotdotdot/.inputrc ~/.inputrc

if [[ ! $(echo "$(tmux -V | cut -d' ' -f2) > 2" | bc) -eq 1 ]]; then
  echo "Install tmux"
  if command -v tmux >/dev/null 2>&1; then
    echo "Uninstall tmux version below 2"
    uninstall tmux
  fi
  tmpdir=$(mktemp -d)
  install libevent-dev
  install libncurses5-dev
  pushd "$tmpdir"
  git clone https://github.com/tmux/tmux.git
  sh autogen.sh \
  && ./configure && make
  rm /usr/bin/tmux
  mv ./tmux/tmux /usr/bin/
  popd
fi

echo "Prepare tmux.conf"
symlinkSafe ~/projects/dotdotdot/.tmux.conf ~/.tmux.conf

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  echo "Install tmux plugin manager"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  tmux run-shell ~/.tmux/plugins/tpm/bindings/install_plugins
fi

if [ -z "$(vim --version | grep -- -clipboard)" ]; then
  echo "Install vim"
  install vim-gnome
fi

echo "Prepare vimrc"
symlinkSafe ~/projects/dotdotdot/.vimrc ~/.vimrc

echo "Prepare YouCompleteMe Conf for vim"
if [[ ! -d ~/.vim ]]; then
  mkdir ~/.vim
fi
symlinkSafe ~/projects/dotdotdot/.ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py

if ! command -v ack >/dev/null 2>&1; then
  echo "Install ack-grep"
  install ack-grep
fi

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  echo "Install vim plugins"
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall

echo "Reload Bash configs"
source ~/.bashrc
bind -f ~/.inputrc
