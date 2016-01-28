#!/bin/bash
set -e

BASE_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
installVim(){
	_install ".vim .vimrc" "vim"
}

installBash(){
	_install ".bashrc .bash_aliases .bash_functions" "bash"
	_install ".screenrc" "screen"
	_install ".inputrc" "inputrc"
}
installGit(){
	_install ".gitconfig" "git"	
}
_install(){
	echo -n "Installing $2 configuration..."
	for f in $1; do
		ln -sf $BASE_DIR/$f ~/$f
	done
	echo "[Done]"
}
case "$1" in
	"dev-linux")
		bash $0 "bash"
		installGit
		installVim
	;;
	"bash")
		installBash
	;;
	*)
		echo "$0 (dev-linux|bash)"
		exit 1
	;;
esac
