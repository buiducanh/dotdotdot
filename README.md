# Tmux
- .tmux.conf
- Set vim mode
- Make Prefix C-j

# Bash Config
- get xclip and make aliases
- .bash_aliases
- .bashrc

# Install Git
- make ssh key
- git-prompt.sh

# Swap keys
- xkb config symbols to make CapsLock into Ctrl
- files: pc, capslock */usr/share/X11/xkb/symbols/*
- Learn to use rules?
- Delete /var/lib/xkb/*.xkm for ubuntu to recompile keymap

# Install Vim full
- Delete vim-tiny and install vim-gnome
- Set jk to be escape mode
- .vimrc


# Install Grive2 with support for Drive Rest Api
- Set up folder
- Make crontab -e for hourly backup

# Fix Ubuntu
- Sleep messes up wireless because state is still asleep (nmcli nm)
- http://askubuntu.com/questions/452826/wireless-networking-not-working-after-resume-in-ubuntu-14-04
- make this script in /etc/pm/sleep.d/ :
        #!/bin/sh

        case "${1}" in
            resume|thaw)
            nmcli nm sleep false
                    ;;
        esac
