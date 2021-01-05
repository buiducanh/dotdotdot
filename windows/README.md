# Instructions to set up Windows with WSL
NOTE: if reading from within install.tar.gz, go straight to `Setup Linux`
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
2. symlink from Windows Terminal Prompt into WSL
```bat
mklink %APPDATA%\Microsoft\Windows\"Start Menu"\Programs\Startup\autohotkey.ahk \\wsl$\Ubuntu\home\<username>\projects\dotdotdot\autohotkey.ahk
```
3. run the autohotkey if you have not
## Setup linux
### Steps
1. open wsltty
2. download [install.tar.gz](https://github.com/buiducanh/dotdotdot/releases)
3. run `./install-linux.sh` script to setup
## Setup github ssh key
[Add ssh key](https://github.com/settings/keys)
