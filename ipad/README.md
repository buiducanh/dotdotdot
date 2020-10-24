# iSH Shell
## Boot minimal root filesystem to get apk command
1. go to https://alpinelinux.org/downloads/
2. find and download Minimal Root Filesystem for x86
3. Back in the app, tap the Cog icon above the keyboard > Filesystems > Import > select that file.
3. (The app crashed?) Start the app again and go back to the Cog > Filesystems > alpine-minirootfs-.... > Boot from This Filesystem

## Install necessary tools
```
apk add vim
apk add openssh
apk add openssh-keygen
apk add git
apk add zsh
```

```
# install oh-my-zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

## Modify default login shell
1. vim /etc/passwd
2. modify root shell to zsh
