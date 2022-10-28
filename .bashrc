#         ____
#  _   _ / ___|  UmbralGoat [Vox]
# | | | | |  _   https://www.github.com/VoxT1
# | |_| | |_| |  https://www.twitter.com/umbralgoat
#  \__,_|\____|  ψι#6283
#
# My .bashrc configuration, feel free to harvest some aliases.

### Run startx on TTY login ###

#if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#startx
#fi

### Ignore capitalization for autocomplete ###
bind "set completion-ignore-case on"

### List dir every cd & clear ###
function cd {
    builtin cd "$@"
    RET=$?
    clear && exa -lh --color=always --group-directories-first
    return $RET
}
alias clear='clear && exa -lh --color=always --group-directories-first'

### Archive Extraction ###
ex (){
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

### Startup ###
neofetch
# pfetch
# exa -lh --color=always --group-directories-first

## Prompt ##
export PS1='\e[0;32m\u@\h {\e[0m \w \e[0;32m} Ψ\e[0m '

## Exports ##
export VISUAL=nvim
export EDITOR=nvim
export LFS=/mnt/scratch
export LFS_TGT=x86_64-lfs-linux-gnu
export JAVA_HOME=/opt/jdk-18.0.1.1/

# PATH #
export PATH="$HOME/.emacs.d/bin/":$PATH
export PATH="$HOME/.local/bin/":$PATH
export PATH="/usr/lib64/qt5/bin/":$PATH
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/.cabal/bin":$PATH

### Administration ###
export SUPERUSER=doas
#export SUPERUSER=sudo

### Aliases ###
## Superuser ##
alias root="$SUPERUSER su"

## Shortcuts ##
alias x="startx"
alias q="exit"
alias c="clear"
alias to="cd"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias h="cd $HOME"
alias mkdir="mkdir -pv"
alias lsb="lsblk"
alias bid="$SUPERUSER blkid"
alias nfet="neofetch"
alias iso="tree /media/hdd/ISOs/"

## List ##
alias ls='exa -ahl --color=always --group-directories-first'  # All files and dirs
alias la='exa -ahl --color=always --group-directories-first'  # All files and dirs
alias ll='exa -lh --color=always --group-directories-first'   # Long format
alias lt='exa -aT --color=always --group-directories-first'   # Tree listing
alias l.='exa -a | egrep "^\."'                               # Lists dotfiles

## Youtube Downloading ##
alias yta-aac="youtube-dl --extract-audio --audio-format aac"
alias yta-best="youtube-dl --extract-audio --audio-format best"
alias yta-flac="youtube-dl --extract-audio --audio-format flac"
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a"
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3"
alias ytv="youtube-dl -f bestvideo+bestaudio"

## Vim and Emacs ##
alias v="vim"
alias nv="nvim"
alias sv="$SUPEUSER vim"
alias snv="$SUPERUSER nvim"
alias em="emacs"
alias sem="$SUPERUSER emacs"

## Safety-net ##
alias mv="mv -iv"
alias rm="rm -iv"
alias cp="cp -iv"

## Colorize Grep Output ##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## Git ##
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

## Portage ##
alias emi="time $SUPERUSER emerge -v"                                   # Emerge
alias emr="$SUPERUSER emerge -c"                                        # Depclean
alias emd="$SUPERUSER emerge --deselect"                                # Deselect from @world
alias emS="$SUPERUSER emerge --sync"                                    # Sync
alias ems="$SUPERUSER emerge -s"                                        # Search
alias emu="time $SUPERUSER emerge -uv"                                  # Update single package
alias emU="$SUPERUSER emerge --sync && time doas emerge -uvDN @world"   # Update @world
alias emmod="$SUPERUSER emerge @module-rebuild"                         # Rebuild modules
alias emt="$SUPERUSER qlop -H"                                          # Show time that a package took to compile
alias pkg="qlist -I | wc -l"                                            # Package count
alias news="$SUPERUSER eselect news read"                               # Show news

# Repos/Overlays #
alias repen="$SUPERUSER eselect repository enable"    # Enable repository
alias repds="$SUPERUSER eselect repository disable"   # Disable repository
#alias reprm="$SUPERUSER eselect repository remove"    # Remove repository

## Kernel ##
alias kered="cd /usr/src/linux && $SUPERUSER make menuconfig"
alias kerbuild="cd /usr/src/linux && time $SUPERUSER make -j14 && $SUPERUSER make modules_install && $SUPERUSER make install"
alias gmk="$SUPERUSER grub-mkconfig -o /boot/grub/grub.cfg"

## Gentoo Services ##
alias ruadd="$SUPERUSER rc-update add"
alias rudel="$SUPERUSER rc-update del"

## Gentoo System Files ##
alias mkc="$SUPERUSER $EDITOR /etc/portage/make.conf"
alias fst="$SUPERUSER $EDITOR /etc/fstab"

## Pacman ##
#alias pmi="sudo pacman -S"
#alias pmr="sudo pacman -Rscn"
#alias pms="sudo pacman -Ss"
#alias pmS="sudo pacman -Syyy"
#alias pmU="sudo pacman -Syuu"
#alias pri="paru -S"
#alias prr="paru -Rscn"
#alias prs="paru -Ss"
#alias pU="paru -Syuu"

## Apt ##
#alias api="$SUPERUSER apt install"
#alias apr="$SUPERUSER apt remove"
#alias apar="$SUPERUSER apt autoremove"
#alias apU="$SUPERUSER apt update && $SUPERUSER apt upgrade"

## XBPS ##
#alias xbi="$SUPERUSER xbps-install"
#alias xbiS="$SUPERUSER xbps-install -S"
#alias xbiU="$SUPERUSER xbps-install -Su"
#alias xbrR="$SUPERUSER xbps-remove -R"
#alias xbq="$SUPERUSER xbps-query"
#alias xbqR="$SUPERUSER xbps-query -R"

## User Configs ##
alias brc="$EDITOR ~/.bashrc"
alias xrc="$EDITOR ~/.xinitrc"
alias xmc="$EDITOR ~/.xmonad/xmonad.hs"
alias xbrc="$EDITOR ~/.config/xmobar/xmobarrc.hs"
#alias dwme="$SUPERUSER $EDITOR /etc/portage/savedconfig/x11-wm/dwm-6.2.h"
#alias dwmb="$SUPERUSER emerge dwm"
#alias hlc="$EDITOR ~/.config/herbstluftwm/autostart"
#alias bsc="$EDITOR ~/.config/bspwm/bspwmrc"
#alias sxc="$EDITOR ~/.config/sxhkd/sxhkdrc"
#alias pbc="$EDITOR ~/.config/polybar/config"
#alias pbl="$EDITOR ~/.config/polybar/launch.sh"
alias alc="$EDITOR ~/.config/alacritty/alacritty.yml"

## Rick Roll ##
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

## Power Shortcuts ##
alias log="kill -9 -1"
alias reboot="$SUPERUSER reboot"
alias poweroff="$SUPERUSER poweroff"

### Starship Prompt ###
#eval "$(starship init bash)"
