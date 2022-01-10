# __     _______
# \ \   / /_   _|  Vox Tetra
#  \ \ / /  | |    https://www.github.com/VoxT1
#   \ V /   | |    https://www.twitter.com/VoxTetra1
#    \_/    |_|    vt#9827
#
# My .bashrc configuration, feel free to harvest some aliases.

### Run startx on login ###

#if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#startx
#fi

### Ignore capitalization for autocomplete ###
bind "set completion-ignore-case on"

### List dir every cd ###
function cd {
    builtin cd "$@"
    RET=$?
    clear && exa -lh --color=always --group-directories-first
    return $RET
}

### Archive Extraction ###
ex ()
{
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
# neofetch
# pfetch
exa -lh --color=always --group-directories-first

export PS1=" \w [$(date +%H:%M:%S)] > "
export VISUAL=nvim
export EDITOR=nvim

### PATH ###
export PATH="$HOME/.emacs.d/bin/":$PATH
export PATH="$HOME/.local/bin/":$PATH
export __GL_SHADER_DISK_CACHE_PATH=$XDG_CACHE_HOME

### Aliases ###
## Superuser ##
alias ds="doas su"
#alias ss="sudo su"

## Bookmarks ##
alias dcol="cd $HOME/College"
alias dgit="cd $HOME/Git"

## Shortcuts ##
alias x="startx"
alias q="exit"
alias c="clear"
alias to="cd"
alias ..="cd .."
alias h="cd $HOME"
alias lsb="lsblk"
alias bid="doas blkid"
alias nfet="neofetch"
alias iso="tree /media/hdd/ISOs/"

alias ls='exa -ahl --color=always --group-directories-first'  # All files and dirs
alias la='exa -ahl --color=always --group-directories-first'  # All files and dirs
alias ll='exa -lh --color=always --group-directories-first'   # Long format
alias lt='exa -aT --color=always --group-directories-first'   # Tree listing
alias l.='exa -a | egrep "^\."'                               # Lists dotfiles

alias yta-aac="youtube-dl --extract-audio --audio-format aac"
alias yta-best="youtube-dl --extract-audio --audio-format best"
alias yta-flac="youtube-dl --extract-audio --audio-format flac"
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a"
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3"
alias ytv="youtube-dl -f bestvideo+bestaudio"

## Vim and Emacs ##
alias vim="nvim"
alias v="nvim"
alias nv="nvim"
alias dv="doas nvim"
alias dnv="doas nvim"
alias em="emacs"
alias dem="doas emacs"

## Confirmation Safety-net ##
alias mv="mv -i"
alias rm="rm -i"
alias cp="cp -i"

## Colorize Grep Output ##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## Git ##
alias dots="/usr/bin/git --git-dir=$HOME/Git/voxDots --work-tree=$HOME"

## Portage ##
alias emi="time doas emerge -v"                                     # Emerge
alias emr="doas emerge -c"                                          # Depclean
alias emS="doas emerge --sync"                                      # Sync
alias ems="doas emerge -s"                                          # Search
alias emu="time doas emerge -uv"                                    # Update single package
alias emU="doas emerge --sync && time doas emerge -uvDN @world"     # Update @world
alias emt="doas qlop -H"                                            # Show time that a package took to compile
alias pkg="qlist -I | wc -l"                                        # Package count
alias news="doas eselect news read"                                 # Show news
# Repos/Overlays #
alias repen="doas eselect repository enable"    # Enable repository
alias repds="doas eselect repository disable"   # Disable repository
alias reprm="doas eselect repository remove"    # Remove repository
# Kernel #
alias ke="cd /usr/src/linux && doas make menuconfig"
alias kb="cd /usr/src/linux && time doas make -j14 && doas make modules_install"
alias gmk="doas grub-mkconfig -o /boot/grub/grub.cfg"

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

## Services ##
alias ruadd="doas rc-update add"
alias rudel="doas rc-update del"

## System Files ##
alias mkc="doas $EDITOR /etc/portage/make.conf"
alias pak="doas $EDITOR /etc/portage/package.accept_keywords"
alias fst="doas $EDITOR /etc/fstab"

## User Configs ##
alias brc="$EDITOR ~/.bashrc"
alias xic="$EDITOR ~/.xinitrc"
alias xrc="$EDITOR ~/.xmonad/xmonad.hs"
alias xbrc="$EDITOR ~/.config/xmobar/xmobarrc.hs"
alias dwme="doas $EDITOR /etc/portage/savedconfig/x11-wm/dwm-6.2.h"
alias dwmb="doas emerge dwm"
alias hlc="$EDITOR ~/.config/herbstluftwm/autostart"
alias bsc="$EDITOR ~/.config/bspwm/bspwmrc"
alias sxc="$EDITOR ~/.config/sxhkd/sxhkdrc"
alias pbc="$EDITOR ~/.config/polybar/config"
alias pbl="$EDITOR ~/.config/polybar/launch.sh"
alias alc="$EDITOR ~/.config/alacritty/alacritty.yml"

## Rick Roll ##
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

## Power Shortcuts ##
alias log="kill -9 -1"
alias reboot="doas reboot"
alias poweroff="doas poweroff"

### Starship Prompt ###
eval "$(starship init bash)"


