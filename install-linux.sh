#!/bin/bash

runAsRoot() {
	echo "${@:2}"
  sudo "$0" "${@:2}"
}

runAsUser() {
	username=$1
	command=$2
	su "$username" -c "$command"
}

isGitHasUsername() {
	TMP=$(grep "name = Anh Bui" $HOME/.gitconfig)
	if [[ -z "$TMP" ]]; then
		return "0"
	else
		return "1"
	fi
}

isGitHasEmail() {
	TMP=$(grep "email = b.ducanh96@gmail.com" $HOME/.gitconfig)
	if [[ -z "$TMP" ]]; then
		return "0"
	else
		return "1"
	fi
}

# parse options
SHOULD_OVERRIDE_HOME=
HOME_OVERRIDE=
while getopts ":h:o" opt; do
	case $opt in
		h) HOME_OVERRIDE=$OPTARG
			;;
		o) SHOULD_OVERRIDE_HOME=1
	esac
done

if [[ "$SHOULD_OVERRIDE_HOME" == 1 ]]; then
	HOME="$HOME_OVERRIDE"
fi


if [[ $EUID != 0 ]]; then
	runAsRoot "$0" "$@" -h "$HOME"
  exit $?
else if [[ "$HOME" == "/" || "$HOME" == "/root" ]]; then
	echo "Defaults env_keep += \"HOME\"" > /etc/sudoers.d/1_homeenv
	runAsRoot "$0" "$@" -h "$HOME_OVERRIDE" -o
	exit 1
fi
fi

install() {
	if command -v apt-get >/dev/null 2>&1; then
		echo "install $@"
		sudo apt-get install -y "$@"
	else
		echo "no apt-get, did not install $@"
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
	echo "Cloning repo $2 to $3 as $1"
	pushd "${dest//\~/$HOME}"
	runAsUser "$username" "git clone $target"
	popd
}

uninstall() {
	if command -v apt-get >/dev/null 2>&1; then
		echo "uninstall $@"
	sudo apt-get remove -y "$@"
else
	echo "no apt-get, did not uninstall $@"
	fi
}

# echo "Set up xsel"

# if ! command -v xsel >/dev/null 2>&1; then
# install xsel
# fi
# if ! command -v xclip >/dev/null 2>&1; then
# uninstall xclip
# fi

home=$(dirname "$HOME")
echo "$home"
userlist=$(dirname "$HOME")
echo "User list: $userlist"
username=$(ls "$userlist" -1 | head -n1)
echo "Username: $username"

sudo apt-get update -y
if ! command -v git >/dev/null 2>&1; then
	install git
fi

echo ".gitconfig"
cat ~/.gitconfig
if [[ isGitHasUsername = "0" ]]; then
name=$(read -p "input your name for Git: ")
/usr/bin/git config --global user.name "$name"
fi

if [[ isGitHasEmail = "0" ]]; then
	email=$(read -p "input your email for Git:")
	/usr/bin/git config --global user.email "$email"
fi

if [[ ! -f "$HOME/.ssh/id_github" ]]; then
	echo "Prepare git ssh key"
	mkdir -p "$HOME/.ssh"
	runAsUser "$username" "ssh-keygen -t ed25519 -C '$email' -f id_github"
	mv -f id_github* "$HOME/.ssh"
	echo "Please add ~/.ssh/id_github.pub to https://github.com/settings/keys before proceeding"
	exit 1
fi
echo "Initializing ssh-agent with github key"
eval `ssh-agent -s`; ssh-add $HOME/.ssh/id_github

if ! command -v keychain >/dev/null 2>&1; then
	install keychain
fi

echo "Prepare projects directory"
mkdir -p "$HOME/projects"

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

./install_tmux.sh

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
  tmp_llvm_install=`mktemp`
  bash < <(wget -q -O - https://apt.llvm.org/llvm.sh | sed -e '$ a apt-get install -y clang-tidy-$LLVM_VERSION')
fi

(cd ~/.vim/bundle/YouCompleteMe && python3 install.py --clang-completer --system-libclang)

echo "Reload Bash configs"
source ~/.bashrc
bind -f ~/.inputrc

echo "Set up correct permissions for projects directory"
sudo chown -R "$username":"$username" ~/projects
