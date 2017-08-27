#!/bin/bash
dotdotdot=$1
rm ~/.bashrc ~/.bash_aliases ~/.tmux.conf ~/.vimrc
ln -s $dotdotdot/.bashrc ~/.bashrc
ln -s $dotdotdot/.bash_aliases ~/.bash_aliases
ln -s $dotdotdot/.vimrc ~/.vimrc
ln -s $dotdotdot/.tmux.conf ~/.tmux.conf
