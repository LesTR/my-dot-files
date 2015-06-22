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
httpshare () {
	echo -e "Starting simple HTTP server. Listening on:\n"
	for ip in $(ifconfig | grep "inet " | grep -v "127.0" | awk '{ print $2 }'); do echo -e "\thttp://${ip}:8000"; done
	echo ""
	python -m SimpleHTTPServer 8000 2>/dev/null
}

myjshon () {
	python -m json.tool
}

merckProxy () {
	case "$1" in
		"start")
			echo "Starting proxy"
			export http_proxy=$merck_proxy
			export https_proxy=$merck_proxy
			export ftp_proxy=$merck_proxy
			export ALL_PROXY=$merck_proxy
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
				echo "Running"
			fi
		;;
		*)
			echo "merckProxy (start|stop|status)"
		;;
	esac
}
