# Password generator
genpasswd() {
	local l=$1
	[ "$l" == "" ] && l=20
	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

createTmpDir () {
	local TMZ=$(date +%s)
	mkdir "tmp_$TMZ"
	cd "tmp_$TMZ"
}

tmpclone () {
	createTmpDir
	git clone $1
	cd `ls`
}
showMyIps () {
	ifconfig | grep "inet " | grep -v "127.0" | awk '{ print $2 }'
}
httpshare () {
	local port=8000
	if [[ -n "$1" && -d $1 ]]; then
		cd $1 || return -1
	elif [[ "$1" =~ "[0-9]+" ]]; then
		port=$1
	fi
	[ -n "$2" ] && port=$2

	echo -e "Sharing $(pwd)/ via simple HTTP server. Listening on:\n"
	for ip in $(ifconfig | grep "inet " | grep -v "127.0" | awk '{ print $2 }'); do echo -e "\thttp://${ip}:${port}"; done
	echo ""
	python -m SimpleHTTPServer $port 2>/dev/null
}

myjshon () {
	python -m json.tool
}

myProxy () {
	if [ -z "$my_proxy" ]; then
		echo "Bad configuration, \$my_proxy is missing"
		return -1
	fi
	case "$1" in
		"start")
			echo "Starting proxy"
			echo "Using proxy: $my_proxy"
			export http_proxy=$my_proxy
			export https_proxy=$my_proxy
			export ftp_proxy=$my_proxy
			export ALL_PROXY=$my_proxy
			echo "[DONE]"
		;;
		"stop")
			echo "Stopping proxy"
			unset http_proxy
			unset https_proxy
			unset ftp_proxy
			unset ALL_PROXY
			echo "[DONE]"
		;;
		"status")
			if [ -z "$ALL_PROXY" ]; then
				echo "Not running"
			else
				echo "[Running]"
				echo "Using proxy: $my_proxy"
			fi
		;;
		*)
			echo "merckProxy (start|stop|status)"
			return 1
		;;
	esac
}
complete -W "start stop status" myProxy

reverseAdiblePing () {
	local ip=$1
	if [ -z "$ip" ]; then
		echo "Usage reverseAdiblePing <ip>"
		return 1
	fi
	while true; do ping -t 1 -c 1 -W 20 "$ip"; if [ $? != 0 ] ;then echo -en "\a"; fi;sleep 1;done
}

workspace() {
	WORKSPACE=${WORKSPACE:-"${HOME}/data/workspace"}
	if [ ! -d "$WORKSPACE" ]; then
		echo "$WORKSPACE does not exist. Check your \$WORKSPACE variable." >&2
		return 1
	fi
	cd "$WORKSPACE/$1"
}
if ([ -n "$WORKSPACE" ]) || ([ -d "${HOME}/data/workspace" ]); then
	complete -W "$(echo `workspace && ls | cut -f 1 -d ' ' | uniq | tr '\n' ' '`;)" workspace
fi

JAVA_HOME_LIBEXEC=${JAVA_HOME_LIBEXEC:-"/usr/libexec/java_home"}
java_version() {
	if [ ! -x "$JAVA_HOME_LIBEXEC" ]; then
		echo "$JAVA_HOME_LIBEXEC does not exist. Check your \$JAVA_HOME_LIBEXEC variable." >&2
		return 1
	fi
	
	if [ -z "$1" ]; then
		"$JAVA_HOME_LIBEXEC" -V
		return 1
	fi
	export JAVA_HOME=$($JAVA_HOME_LIBEXEC -v $1)
}
complete -W "$($JAVA_HOME_LIBEXEC -V 2>&1 >/dev/null | grep -v "^Matching Java" | cut -f 1 -d ',' | tr -d ' '| uniq | grep -v "^$"| tr '\n' ' ')" java_version
