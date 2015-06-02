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
	python -m SimpleHTTPServer 8000
}

myjshon () {
	python -m json.tool
}

merckProxy () {
	case "$1" in
		"start")
			echo "Starting proxy"
			export http_proxy=$merck_proxy
			export ALL_PROXY=$merck_proxy
			echo "[DONE]"
		;;
		"stop")
			echo "Stopping proxy"
			unset http_proxy
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
