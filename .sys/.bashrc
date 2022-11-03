#         ____
#  _   _ / ___|  UmbralGoat [Vox]
# | | | | |  _   https://www.github.com/VoxT1
# | |_| | |_| |  https://www.twitter.com/umbralgoat
#  \__,_|\____|  ψι#6283
#
# The .bashrc file for my root user.

# Prompt
PS1='\[\033[01;31m\]\u@\h\[\033[00m\] \[\033[01;31m\]{\[\033[00m\] \w \[\033[01;31m\]} #\[\033[00m\] '

# List dir every cd
function cd {
    builtin cd "$@"
    RET=$?
    clear && exa -lh --color=always --group-directories-first
    return $RET
}

## Exports ##
export VISUAL=nvim
export EDITOR=nvim
export LFS=/mnt/scratch
export LFS_TGT=x86_64-lfs-linux-gnu


## Aliases ##
# Lists #
alias ls='exa -ahl --color=always --group-directories-first'
alias la='exa -ahl --color=always --group-directories-first'

# Shortcuts #
alias c='clear'
alias q='exit'

# Navigation #
alias h='cd /'
alias to='cd'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# System Things #
alias gmk='grub-mkconfig -o /boot/grub/grub.cfg'
alias kered='cd /usr/src/linux && make menuconfig'
alias kerbuild='cd /usr/src/linux && make -j14 && make modules_install && make install'

alias mkc="$EDITOR /etc/portage/make.conf"
alias fst="$EDITOR /etc/fstab"

