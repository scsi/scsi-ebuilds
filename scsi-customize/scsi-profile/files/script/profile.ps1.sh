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
    local ppid1=`ps -ho ppid $PPID`
    local ppid2=`ps -ho ppid $ppid1`
    local ppid3=`ps -ho ppid $ppid2`
    readonly SUUSER=`ps -ho user $ppid3`
    MODE=[$SUUSER]su:
    fcolor="\[\033[01;33m\]"
    rfcolor="\[\033[01;31m\]"
  else
    MODE=
    fcolor="\[\033[01;33m\]"
    rfcolor="\[\033[01;31m\]"
  fi
  rmcolor="\[\033[0m\]"
  rdircolor="\[\033[01;94m\]"
  dircolor="\[\033[01;92m\]"
  scrcolor="\[\033[01;96m\]"
  tmuxcolor="\[\033[01;92m\]"

  [[ $WINDOW ]] && S_WIN="${scrcolor}[$WINDOW]" || S_WIN=""
  [[ $TMUX_PANE ]] && T_WIN="${tmuxcolor}[${TMUX_PANE:1}]" || T_WIN=""
  [[ $USER = root ]] && PS1="${S_WIN}${T_WIN}${rfcolor}${MODE}\h ${rdircolor}\W #${rmcolor} " \
                 || PS1="${S_WIN}${T_WIN}${fcolor}${MODE}\u@\h ${dircolor}\W \$${rmcolor} "
  export PS1
}
setps1
unset setps1
