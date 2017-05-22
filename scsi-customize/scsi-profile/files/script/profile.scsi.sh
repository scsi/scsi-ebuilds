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
alias uncolor='sed -e "s/^[\[[0-7;]*m//g"'
alias cpubenchmark='time echo "scale=5000; 4*a(1)" | bc -l -q'
if [ "`id -u`" = 0 ]; then
	if ps 1|grep -q systemd; then
		alias poweroff='systemctl poweroff'
		alias reboot='systemctl reboot'
	fi
	#alias gentooupdate='time (layman -S;eix-sync ;emerge -uDNv --with-bdeps=y world;emerge @preserved-rebuild;emerge --depclean -pq)'
	alias gentooupdate='time (date;layman -S;eix-sync ;date;hostname;emerge -uDNv world;emerge @preserved-rebuild;emerge --depclean -pq)'
	alias gentooupdate_no_distcc='time (date;layman -S;eix-sync ;date;hostname;FEATURES=-distcc MAKEOPTS=-j`nproc` emerge -uDNv world;FEATURES=-distcc MAKEOPTS=-j`nproc` emerge @preserved-rebuild;emerge --depclean -pq)'
fi
export EMERGE_DEFAULT_OPTS="--with-bdeps y"
[ `nproc` -gt 8 ] && export NMON="dC-" || export NMON="dc-"

#eval `dircolors -b /etc/DIR_COLORS`
#export LS_COLORS
export ECHANGELOG_USER="scsi <scsichen@gmail.com>"
export MAILTO="scsi <scsichen@gmail.com>"
unset SSH_ASKPASS

#if ping -c 1 192.168.2.14 -W 1 >/dev/null 2>&1
#then
#	export all_proxy=http://bqproxy.iet:3128
#	export ftp_proxy=http://bqproxy.iet:3128
#	export http_proxy=http://bqproxy.iet:3128
#	export https_proxy=http://bqproxy.iet:3128
#	export no_proxy="localhost,127.0.0.0/8,192.168.9.80/16,140.92.86.147/24,140.92.86.147,*.ris"
#fi

