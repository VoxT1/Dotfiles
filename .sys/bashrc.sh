#!/bin/sh
#         ____
#  _   _ / ___|  UmbralGoat [Vox]
# | | | | |  _   https://www.github.com/VoxT1
# | |_| | |_| |  https://www.twitter.com/umbralgoat
#  \__,_|\____|  ψι#6283
#
# A script to be placed in /etc/profile.d/ primarily to source the user's .bashrc file.

# Fix .bashrc
source ~/.bashrc

# Anything else
export __GL_SHADER_DISK_CACHE_PATH=$XDG_CACHE_HOME
