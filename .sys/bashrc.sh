#!/bin/sh
#  _   ___     __
# | \ | \ \   / /  Noctivox
# |  \| |\ \ / /   https://www.github.com/VoxT1
# | |\  | \ V /    https://www.twitter.com/VoxNoctivox
# |_| \_|  \_/     nv#9827
#
# A script to be placed in /etc/profile.d/ primarily to source the user's .bashrc file.

# Fix .bashrc
source ~/.bashrc

# Anything else
export __GL_SHADER_DISK_CACHE_PATH=$XDG_CACHE_HOME
