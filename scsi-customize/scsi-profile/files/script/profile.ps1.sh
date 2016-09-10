setps1(){
  #THIS_TTY=`ps -ho tty $$`
  # http://stackoverflow.com/questions/5615570/in-a-script-vs-in-a-subshell
  [[ -z "$PPID" ]] && PPID=`ps -ho ppid $$`
  local MODE CONN fcolor rfcolor rmcolor rdircolor dircolor scrcolor
  CONN=`ps -ho cmd $PPID`
  if [[ $CONN =~ sshd ]]; then
    MODE=ssh:
    fcolor="\[\033[01;35m\]"
    rfcolor="\[\033[01;31m\]"
  elif [[ $CONN =~ telnet ]]; then
    MODE=tel:
    fcolor="\[\033[01;30m\]"
    rfcolor="\[\033[01;31m\]"
  elif [[ $CONN =~ su ]]; then
    MODE=su:
    fcolor="\[\033[01;33m\]"
    rfcolor="\[\033[01;31m\]"
  else
    MODE=
    fcolor="\[\033[01;33m\]"
    rfcolor="\[\033[01;31m\]"
  fi
  rmcolor="\[\033[0m\]"
  rdircolor="\[\033[01;34m\]"
  dircolor="\[\033[01;32m\]"
  scrcolor="\[\033[01;36m\]"

  [ -n "$WINDOW" ] && S_WIN="[$WINDOW]" || S_WIN=""
  [ $USER = root ] && PS1="${scrcolor}${S_WIN}${rfcolor}${MODE}\h ${rdircolor}\W #${rmcolor} " \
                 || PS1="${scrcolor}${S_WIN}${fcolor}${MODE}\u@\h ${dircolor}\W \$${rmcolor} "
  export PS1
}
setps1
unset setps1

