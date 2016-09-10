########### scsi ##############
alias ls='/bin/ls -FN --color=auto'
alias mv='mv -iv'
alias rm='rm -iv'
alias cp='cp -iv --reflink=auto'
alias telnet="telnet -8"
alias iftop="iftop -PB"
alias iftopn="iftop -PBn"
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias cflags='eval export `grep "^CFLAGS=" /etc/make.conf`'
alias uncolor='sed -e "s/^[\[[0-7;]*m//g"'
alias cpubenchmark='time echo "scale=5000; 4*a(1)" | bc -l -q'
if [ "`id -u`" = 0 ]; then
	if ps 1|grep -q systemd; then
		alias poweroff='systemctl poweroff'
		alias reboot='systemctl reboot'
	fi
	#alias gentooupdate='time (layman -S;eix-sync ;emerge -uDNv --with-bdeps=y world;emerge @preserved-rebuild;emerge --depclean -pq)'
	alias gentooupdate='time (layman -S;eix-sync ;emerge -uDNv world;emerge @preserved-rebuild;emerge --depclean -pq)'
fi
export EMERGE_DEFAULT_OPTS="--with-bdeps y"
export NMON="dc-"

if [ ! -z "$DISPLAY" -o "$TERM" =  "xterm" -o "$TERM" = screen ]
then
	if [ $USER = euc ]
	then
		lenv=euc
	else
        	lenv=utf8
	fi

	export LANGUAGE=zh_TW
        case $lenv in
        utf8)
                export LANG=zh_TW.UTF-8
		;;
        big5)
                export LANG=zh_TW.Big5
		export G_FILENAME_ENCODING=Big5
		;;
	euc)
		export LANG=zh_TW.EUC-TW
		;;
        esac
fi
#eval `dircolors -b /etc/DIR_COLORS`
#export LS_COLORS
export ECHANGELOG_USER="scsi <scsichen@gmail.com>"
export MAILTO="scsi <scsichen@gmail.com>"
unset set|grep SSH_ASKPASS

#if ping -c 1 192.168.2.14 -W 1 >/dev/null 2>&1
#then
#	export all_proxy=http://192.168.2.14:3128
#	export ftp_proxy=http://192.168.2.14:3128
#	export http_proxy=http://192.168.2.14:3128
#	export https_proxy=http://192.168.2.14:3128
#	export no_proxy="localhost,127.0.0.0/8,192.168.9.80/16,140.92.86.147/24,140.92.86.147,*.ris"
#fi

