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

clone() {
  username="$1"
  target="$2"
  dest="$3"
  su "$username" -c "git clone $target ${dest//\~/$HOME}"
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

userlist=$(dirname "$HOME")
username=$(ls "$userlist" -1 | head -n1)

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
  clone "$username" git@github.com:buiducanh/dotdotdot.git ~/projects/
else
  (cd ~/projects/dotdotdot && git pull)
fi

echo "Prepare build toolchains"
if ! command -v make >/dev/null 2>&1; then
  install build-essential
fi

if ! command -v cmake >/dev/null 2>&1; then
  install cmake
fi

if ! command -v aclocal >/dev/null 2>&1; then
  install autotools-dev
  install automake
fi

echo "Prepare .ssh config"
symlinkSafe ~/projects/dotdotdot/.ssh/config ~/.ssh/config

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
  clone "$username" https://github.com/tmux/tmux.git
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
  clone "$username" https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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

if ! command -v ag >/dev/null 2>&1; then
  echo "Install silversearcher-ag"
  install silversearcher-ag
fi

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  echo "Install vim plugins"
  clone "$username" https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall
python3installed=$(apt -qq list python3-dev | grep -c "installed")
if [[ "$python3installed" -eq 0 ]]; then
  echo "Install python3-dev"
  install python3-dev
fi

clanginstalled=$(apt list --installed | grep -c "clang")
if [[ "$clanginstalled" -eq 0 ]]; then
  echo "Install clang"
  bash -c "$(wget -q -O - https://apt.llvm.org/llvm.sh | sed -e '\$ a apt-get install -y clang-tidy-\$LLVM_VERSION')"
fi

(cd ~/.vim/bundle/YouCompleteMe && python3 install.py --clang-completer --system-libclang)

echo "Reload Bash configs"
source ~/.bashrc
bind -f ~/.inputrc

echo "Set up correct permissions for projects directory"
sudo chown -R "$username":"$username" ~/projects

pipnotinstalled=$(python3 -m pip 2>&1 | grep -c "No module named")
if [[ "$pipnotinstalled" -eq 1 ]]; then
  echo "Install pip"
  install python3-pip
  su "$username" -c "python3 -m pip install --upgrade pip setuptools wheel"
fi

if [[ ! -f ~/projects/.pythonenv/bin/activate ]]; then
  echo "Initializing Python env using venv"
  venvinstalled=$(apt list --installed | grep -c "python3-venv")
  if [[ "$venvinstalled" -eq 0 ]]; then
    echo "Installing python3 venv"
    install python3-venv
  fi
  su "$username" -c "mkdir -p $HOME/projects/.pythonenv"
  su "$username" -c "python3 -m venv $HOME/projects/.pythonenv"
  source ~/projects/.pythonenv/bin/activate
fi

gripinstalled=$(python3 -m pip list | grep -c "grip")
if [[ "$gripinstalled" -eq 0 ]]; then
  echo "Install grip"
  su "$username" -c "source ~/projects/.pythonenv/bin/activate; python3 -m pip install grip"
fi

griptokeninstalled=$(cat ~/.grip/settings.py | grep -c "PASSWORD")
if [[ "$griptokeninstalled" -eq 0 ]]; then
  echo "Installing python grip token"
  wopen https://github.com/settings/tokens
  token=$(read -p "Paste token here: ")
  su "$username" -c "mkdir ~/.grip"
  su "$username" -c "echo \"PASSWORD = '$token'\" > ~/.grip/settings.py"
fi
