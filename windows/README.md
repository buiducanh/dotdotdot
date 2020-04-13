# Instructions to set up Windows with WSL
## Set up WSL
1. Open PowerShell as Administrator and run:
```PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
2. Restart computer when prompted
3. go to Microsoft Store, install Ubuntu
4. launch Ubuntu to finish initialization
## Set up terminal
1. install [wsltty](https://github.com/mintty/wsltty)
2. download [gruvbox theme](https://github.com/morhetz/gruvbox-contrib/tree/master/mintty) and place it into %APPDATA%/wsltty/themes
3. download [Console NF font](https://github.com/whitecolor/my-nerd-fonts/blob/master/Consolas%20NF/Consolas%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf)
4. configure font and theme in wsltty
## Setup autohotkey for custom global windows hotkey
1. Install [Autohotkey](https://github.com/Lexikos/AutoHotkey_L/releases)
2. run shell:startup
3. copy [autohotkey.ahk](https://github.com/buiducanh/dotdotdot/blob/master/autohotkey.ahk) into the startup path, run it for your current session if necessary
## Setup linux
1. open wsltty
2. download [install-linux.sh](https://github.com/buiducanh/dotdotdot/blob/master/install-linux.sh)
3. run script to setup
## Setup github ssh key
[Add ssh key](https://github.com/settings/keys)
