#!/bin/bash

if [[ $EUID != 0 ]]; then
  sudo "$0" "$@"
  exit $?
fi

install() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install "$@"
  fi
}

uninstall() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get remove "$@"
  fi
}

echo "Set up xsel"

if ! command -v xsel >/dev/null 2>&1; then
  install xsel
fi
if ! command -v xclip >/dev/null 2>&1; then
  uninstall xclip
fi

echo "Install git"
if ! command -v git >/dev/null 2>&1; then
  install git
fi

echo "Prepare projects and downloads directory"
mkdir -p ~/projects
mkdir -p ~/downloads

echo "Prepare dotfiles"
if [ ! -d ~/projects/dotdotdot ]; then
  git clone https://github.com/buiducanh/dotdotdot.git ~/projects/
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

echo "Prepare git prompt"
cat ~/projects/dotdotdot/git-prompt.sh > ~/.git-prompt.sh

echo "Prepare bashrc"
cat ~/projects/dotdotdot/.bashrc > ~/.bashrc

echo "Prepare bash_aliases"
cat ~/projects/dotdotdot/.bash_aliases > ~/.bash_aliases

echo "Prepare inputrc"
cat ~/projects/dotdotdot/.inputrc > ~/.inputrc

echo "Install tmux"
if [[ ! $(echo "$(tmux -V | cut -d' ' -f2) > 2" | bc) -eq 1 ]]; then
  install libevent-dev
  install libncurses5-dev
  (cd ~/downloads && git clone https://github.com/tmux/tmux.git)
  (cd ~/downloads/tmux \
  && sh autogen.sh \
  && ./configure && make)
  rm /usr/bin/tmux
  mv ~/downloads/tmux/tmux /usr/bin/

fi

echo "Prepare tmux.conf"
cat ~/projects/dotdotdot/.tmux.conf > ~/.tmux.conf

echo "Install tmux plugin manager"
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  tmux run-shell ~/.tmux/plugins/tpm/bindings/install_plugins
fi

echo "Install vim"
if [ -z "$(vim --version | grep -- -clipboard)" ]; then
  install vim-gnome
fi

echo "Prepare vimrc"
cat ~/projects/dotdotdot/.vimrc > ~/.vimrc

echo "Install vim plugins"
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  install ack-grep
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall
