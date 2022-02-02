#!/bin/bash
set -e

BASE_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

source $BASE_DIR/.bash_colors

TARGET=${TARGET:-$HOME}

installVim(){
	_install ".vim .vimrc" "vim"
}

installBash(){
	_install ".bashrc .bash_aliases .bash_functions .bash_colors" "bash"
	_install ".screenrc" "screen"
	_install ".inputrc" "inputrc"
	_install ".tmux.conf" "tmux"
}
installGit(){
	_install ".gitconfig" "git"	
}
installSlate(){
	_install ".slate" "slate"
}
installKarabiner(){
	echo -ne "\033[00;${COLOR_WHITE}mInstalling karabiner configuration file...\033[0m"
	ln -sf "${BASE_DIR}/karabiner/private.xml" "${TARGET}/Library/Application Support/Karabiner/private.xml"
	echo -e "[\033[01;${COLOR_GREEN}mDone\033[0m]"
}
installTerminalStuff(){
	_install ".dircolors" "dircolors"
}
installIrssi(){
	_install ".irssi" "irssi"
}
_install(){
	echo -ne "\033[00;${COLOR_WHITE}mInstalling $2 configuration...\033[0m"
	for f in $1; do
		ln -sf "${BASE_DIR}/${f}" "${TARGET}/${f}"
	done
	echo -e "[\033[01;${COLOR_GREEN}mDone\033[0m]"
}
case "$1" in
	"dev-linux")
		bash $0 "bash"
		installGit
		installVim
	;;
	"mac")
		bash $0 "dev-linux"
		installSlate
#		installKarabiner
	;;
	"linux")
		bash $0 "dev-linux"
		installIrssi
	;;
	"bash")
		installBash
		installTerminalStuff
	;;
	*)
		echo "$0 (dev-linux | mac | linux | bash)"
		exit 1
	;;
esac
