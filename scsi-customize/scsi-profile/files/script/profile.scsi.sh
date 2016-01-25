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

#THIS_TTY=`ps aux | grep $$ | grep bash | awk '{ print $7 }'`
THIS_TTY=`ps aux | awk "{ if (\\$2 == $$) print \\$7 }"`
SESS_SRC=`who | grep $THIS_TTY | awk '{ print $6 }'`
ppid=`ps -aef | awk "{ if (\\$2 == $$) print \\$3 }"`
CONN=`ps aux| awk "{ if (\\$2 == \"$ppid\") print \\$11 \\$12}"`
MODE=""
echo $CONN|grep su &>/dev/null && MODE=su
echo $CONN|grep sshd &>/dev/null && MODE=ssh
echo $CONN|grep telnet &>/dev/null && MODE=tel

# Okay...Now who we be?
if [ `/usr/bin/whoami` = "root" ] ; then
  USR=priv
else
  USR=nopriv
fi

case $MODE in
ssh)
        SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
        if [ $SSH_IP ] ; then
                SSH_FLAG=1
        fi
        SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
        if [ $SSH2_IP ] ; then
                SSH_FLAG=2
        fi
        if [ $SSH_FLAG -eq 2 ] ; then
          CONN=ssh2
        fi

        fcolor="\[\033[01;35m\]"
	rfcolor="\[\033[01;31m\]"
        ;;
tel)
        fcolor="\[\033[01;30m\]"
	rfcolor="\[\033[01;31m\]"
        ;;
*)
        fcolor="\[\033[01;33m\]"
	rfcolor="\[\033[01;31m\]"
        ;;
esac

rmcolor="\[\033[0m\]"
rdircolor="\[\033[01;34m\]"
dircolor="\[\033[01;32m\]"
scrcolor="\[\033[01;36m\]"
if [ ! $MODE = "" ]
then
        MODE=${MODE}:
fi

if [ -z "$WINDOW" ]
then
        S_WIN=""
else
        S_WIN="[$WINDOW]"
fi
case $USR in
priv)
        PS1="${scrcolor}${S_WIN}${rfcolor}${MODE}\h ${rdircolor}\W #${rmcolor} "
        ;;
*)
        PS1="${scrcolor}${S_WIN}${fcolor}${MODE}\u@\h ${dircolor}\W \$${rmcolor} "
        ;;
esac
export PS1
#eval `dircolors -b /etc/DIR_COLORS`
#export LS_COLORS
export ECHANGELOG_USER="scsi <scsichen@gmail.com>"
export MAILTO="scsi <scsichen@gmail.com>"

#if ping -c 1 192.168.2.14 -W 1 >/dev/null 2>&1
#then
#	export all_proxy=http://192.168.2.14:3128
#	export ftp_proxy=http://192.168.2.14:3128
#	export http_proxy=http://192.168.2.14:3128
#	export https_proxy=http://192.168.2.14:3128
#	export no_proxy="localhost,127.0.0.0/8,192.168.9.80/16,140.92.86.147/24,140.92.86.147,*.ris"
#fi

