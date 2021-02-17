ppids(){
  local str=`ps -ho ppid,cmd $1`
  local cmd=`echo $str|awk '{print $2}'`
  local ppid=`echo $str|awk '{print $1}'`
  echo ppid=$ppid
  [[ $ppid -eq 0 ]] && return
  ppids $ppid
}

find_screen(){
  local str=`ps -ho ppid,cmd $1`
  echo "$str"|grep -qiw "screen" && { echo screen; return; }
  echo "$str"|grep -qiw "tmux" && { echo tmux; return; }
  local cmd=`echo $str|awk '{print $2}'`
  local ppid=`echo $str|awk '{print $1}'`
  [[ $ppid -eq 0 ]] && return
  find_screen $ppid
}

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
  if [[ ! $PS1_TERMINAL_MGR_PANE ]]; then
    [[ -n $WINDOW && -n $TMUX_PANE && `find_screen $$` = screen ]] && PS1_TERMINAL_MGR_PANE="${T_WIN}${S_WIN}" || PS1_TERMINAL_MGR_PANE="${S_WIN}${T_WIN}"
  fi
  [[ $USER = root ]] && PS1_SCSI="${PS1_TERMINAL_MGR_PANE}${rfcolor}${MODE}\h ${rdircolor}\W #${rmcolor} " \
                 || PS1_SCSI="${PS1_TERMINAL_MGR_PANE}${fcolor}${MODE}\u@\h ${dircolor}\W \$${rmcolor} "
  unset PS1_TERMINAL_MGR_PANE
}
[[ $PS1_SCSI ]] || setps1
unset setps1
export PS1=$PS1_SCSI
