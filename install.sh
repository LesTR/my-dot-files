#!/bin/bash
set -e
DRY_RUN=${2:-"false"}

BASE_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

source $BASE_DIR/.bash_colors

TARGET=${TARGET:-$HOME}

installVim(){
	_install ".vim .vimrc" "vim"
}

installBash(){
	_install ".bashrc .shell_aliases .shell_functions .bash_colors" "bash"
	_install ".screenrc" "screen"
	_install ".inputrc" "inputrc"
	_install ".tmux.conf" "tmux"
}
installZsh(){
	_install ".zshrc .shell_functions .shell_aliases .p10k.zsh" "zsh"
	_install ".screenrc" "screen"
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
	if [ "${DRY_RUN}" == "false" ]; then
		ln -sf "${BASE_DIR}/karabiner/private.xml" "${TARGET}/Library/Application Support/Karabiner/private.xml"
	else
		echo Executing: ln -sf "${BASE_DIR}/karabiner/private.xml" "${TARGET}/Library/Application Support/Karabiner/private.xml"
	fi
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
		if [ "${DRY_RUN}" == "false" ]; then
			ln -sf "${BASE_DIR}/${f}" "${TARGET}/${f}"
		else
			echo Executing: ln -sf "${BASE_DIR}/${f}" "${TARGET}/${f}"
		fi
	done
	echo -e "[\033[01;${COLOR_GREEN}mDone\033[0m]"
}
case "$1" in
	"dev-linux")
		bash $0 "bash" ${DRY_RUN}
		installGit
		installVim
	;;
	"mac")
		bash $0 "dev-linux" ${DRY_RUN}
		installZsh
#		installSlate
#		installKarabiner
	;;
	"linux")
		bash $0 "dev-linux" ${DRY_RUN}
		installIrssi
	;;
	"bash")
		installBash
		installTerminalStuff
	;;
	*)
		echo "$0 (dev-linux | mac | linux | bash) <?DRY_RUN:true/false>"
		exit 1
	;;
esac
