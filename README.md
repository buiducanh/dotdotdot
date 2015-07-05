# Tmux
_ .tmux.conf
_ Set vim mode
_ Make Prefix C-j

# Bash Config
_ get xclip and make aliases
_ .bash_aliases
_ .bashrc

# Install Git
_ make ssh key
_ git-prompt.sh

# Swap keys
_ xkb config symbols to make CapsLock into Ctrl
_ files: pc, capslock */usr/share/X11/xkb/symbols/*
_ Learn to use rules?
_ Delete /var/lib/xkb/*.xkm for ubuntu to recompile keymap

# Install Vim full
_ Delete vim-tiny and install vim-gnome
_ Set jk to be escape mode
_ .vimrc


# Install Grive2 with support for Drive Rest Api
_ Set up folder
_ Make crontab -e for hourly backup

# Fix Ubuntu
_ Sleep messes up wireless because state is still asleep (nmcli nm)
_ http://askubuntu.com/questions/452826/wireless-networking-not-working-after-resume-in-ubuntu-14-04
_ make this script in /etc/pm/sleep.d/ :
        #!/bin/sh

        case "${1}" in
            resume|thaw)
            nmcli nm sleep false
                    ;;
        esac
