#!/bin/bash
#if [ -z "$COMMFUNC_LOAD" ]; then
[ -z "$BASH" ] && die "Plz use bash for shell execute."
COMMFUNC_LOAD=LOAD
#PROGRAM=`basename $(which $0)`
OIFS="$IFS"
LIFS="
"
FUNC_AFTER_DIE=_after_die
die() { echo "$*"; type $FUNC_AFTER_DIE >/dev/null 2>&1 && $FUNC_AFTER_DIE 1>/dev/null 2>&1; exit 1; }
#die() { echo "$@" >&2; exit 1; }
trap "_killchild;_clear_result" 0 1 2 9 15

case `uname` in
  AIX)
    export PATH=/SRIS/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/bin/X11:/sbin:/usr/java6_64/jre/bin:/usr/vac/bin:/usr/vacpp/bin:/usr/local/mysql/bin:/opt/freeware/bin
    #export LIBPATH=/opt/freeware/lib:$LIBPATH
    export LIBPATH=$LIBPATH:/usr/lib:/opt/freeware/lib
    _FIND=/opt/freeware/bin/find
    _SED=/opt/freeware/bin/sed
    _STAT=/opt/freeware/bin/stat
	_SLEEP=/opt/freeware/bin/sleep
  ;;
  *) _SED=sed
     _FIND=find
	 _STAT=stat
	 _SLEEP=sleep
esac

for aa in $_SED $_FIND $_STAT;do
	which $aa >/dev/null 2>/dev/null || die "cmd $aa not exist."
done

SED(){ $_SED "$@"; }
FIND(){ $_FIND "$@"; }
STAT(){ $_STAT "$@"; }
SLEEP(){ $_SLEEP "$@"; }
ask(){ [ -z "$noask" ] && return 0;local _x _y;printf "$* [y/N] "; read _x _y; echo "$_x"|grep -iq -e "y" -e "yes"; }
readprop(){ SED -n "0,/^[[:space:]]*$2[[:space:]]*=/{s/^[[:space:]]*$2[[:space:]]*=[[:space:]]*\([^[:space:]]*.*[^[:space:]*]\)[[:space:]]*$/\1/p}" $1; }
readcfg(){
  local cfile=$1; local qca=$2; local qparam=$3
  local IFS="$LIFS"
  local ca=""; local stat=0
  for aa in `grep -v '[[:space:]]*#' $cfile|SED "s/^[[:space:]]*\([^[:space:]].*[^[:space:]]\)[[:space:]]*$/\1/"`;  do
    #aa=`echo "$aa"|tr -d "\n"|tr -d "\r"`
    if [ $stat = 0 ]; then
      [[ "$aa" =~ ^\[(.*)\]$ ]] && { [ "${BASH_REMATCH[1]}" = "$qca" ] && stat=1 || continue; } || continue
    elif [[ "$aa" =~ ^\[(.*)\]$ ]]; then
      return 1
    elif [[ $aa =~ ^[[:space:]]*([^[:space:]](.*[^[:space:]]){0,1})[[:space:]]*=[[:space:]]*([^[:space:]](.*[^[:space:]]){0,1})[[:space:]]*$ ]]; then
      [ "${BASH_REMATCH[1]}" = "$qparam" ]&& echo ${BASH_REMATCH[3]} 
    else
      continue
    fi
  done
}
 
show_env(){
  for var in $@; do
    eval value=\"\$$var\"; echo $var="$value"
  done
}
check_env_show(){
  for var in $@; do
    eval value=\"\$$var\"; echo $var="$value"
    [ -z "$value" ] && die "$var is not set. Pls check environment."
  done
}
is_define_env(){
  for var in $@; do
    eval value=\"\$$var\"
    [ -z "$value" ] && return 1
  done
  return 0
}
check_env(){ is_define_env "$@" || die "$var is not set. Pls check environment."; }
replace_env() {
   local var=$2; local sfile=$1
   local value; eval value=\$$var
   eval export $var
   #[ -n "$value" ] && printf "%-11s = %s\n" $var  $value || die "$var not set"
   #printf "%-12s = %s\n" $var  "$value"
   value=`echo "$value"|SED -e "s/\//\\\\\\\\\\\\//g"`
   SED -i "s/\${$var}/$value/g" $sfile
}
testclient(){ testclient $@; }
printtitle() {
  local line="+---------------------------------------------------------------------+"
  local msg="$@"; local tnu=$((${#line}-6));tnu=$((${tnu}-${#msg}))
  local lnu=$(($tnu/2)); local rnu=$(($tnu-$lnu))
  echo "$line"; printf "|>" ; local nu=0
  while [ $nu -le $lnu ]; do
    printf " "; ((nu++))
  done
  printf "$msg"; nu=0
  while [ $nu -le $rnu ]; do
     printf " "; ((nu++))
  done
  echo "<|"; echo "$line"
}
nowtime() { date +%s; }
usedtime() {
  [ -n "$1" ] && local stime=$1 || local stime=$_sris_stime
  [ -n "$2" ] && local now=$2 || local now=$(date +%s)
  local usesec=$(($now - $stime))
  local day=$(($usesec / 86400))
  local hur=$(($usesec  % 86400 / 3600))
  local min=$(($usesec % 3600 / 60))
  local sec=$(($usesec % 60))
  [ "$day" -ne 0 ] && printf "%dday," $day
  [ "$hur" -ne 0 ] && printf "%02d:" $hur
  printf "%02d:%02d" "$min" "$sec"
}
_sris_stime=`nowtime`
isalive() { ping -c 1 -w 3 $1>/dev/null 2>&1||ping -c 1 -w 3 $1>/dev/null 2>&1; }
_tab(){ [ -z "$1" ] && return 0; echo "$1"|SED "s/^/  |/"; echo; }
_result_file=`mktemp -u`
_exec_result_list=
list_result(){
	case "$1" in
	success)grep ":[[:blank:]]*success\." $_result_file 2>/dev/null;;
	fail)grep ":[[:blank:]]*fail\." $_result_file 2>/dev/null;;
	*)cat $_result_file 2>/dev/null
	esac
}
_clear_result(){ rm -f $_result_file 2>/dev/null; }
_buexec(){
  [ $# -lt 2 ] && { echo wrong param. ;return 1; }
  local _stime=`nowtime`; 
  local desc="$1";shift
  local cmd="$1";shift
  local _bu_mode _bu_output
  for opt in "$@";do
    [[ $opt =~ ^(^[A-Za-z][A-Za-z0-9_]*)=(.*)$ ]] || { echo "buexec extendion parameter error: '$opt'"; return 1; }
	eval local _bu_${BASH_REMATCH[1]}=\"${BASH_REMATCH[2]}\"
  done
  case "$_bu_mode" in
  multi) : ;;
  #single (default)
  *) _bu_mode=single
  esac
  local tmpfile=/tmp/insris.$$.log
  local busdate="`usedtime $_sris_stime`"
  local rtn msg rst
  local titlestr=`printf "(%s)%-45s: " "$busdate" "$desc"`
  [ "$_bu_mode" = single ] && printf "$titlestr"
  msg=`eval $cmd 2>&1`
  #eval $cmd >$tmpfile 2>&1
  rtn=$?
  [ $rtn = 0 ] &&  rst="success. [`usedtime $_stime`]" || rst="fail.    [`usedtime $_stime`]"
  #[ -n "$_result_file" ] && echo "$rtn:$desc" >>$_result_file

  #msg=`cat $tmpfile`;rm -f $tmpfile
  #echo "output=$_bu_output"
  case "$_bu_output" in
  always) : ;;
  never) msg="";;
  onsuccess) [ $rtn = 0 ] || msg="";;
  #onfail(default)
  *) [ $rtn = 0 ] && msg=""
  esac
  msg=`_tab "$msg"`
  [ -n "$_result_file" ] && printf "%s%s\n" "$titlestr" "$rst">>$_result_file
  if [ "$_bu_mode" = single ]; then
    [ -n "$msg" ] && printf "%s\n%s\n" "$rst" "$msg" || printf "%s\n" "$rst"
  else
    [ -n "$msg" ] && printf "%s%s\n%s\n" "$titlestr" "$rst" "$msg" || printf "%s%s\n" "$titlestr" "$rst"
  fi
  return $rtn
}
buexec(){ singlexec "$@"; } 
singlexec(){ _buexec "$@" "mode=single"; }
multiexec(){ 
  local cpid
  buexec "$@" "mode=multi" & cpid=$!
  if [[ "$*" =~ [[:blank:]]group=([^[:blank:]]+) ]]; then
    local grp="${BASH_REMATCH[1]}"
    eval _pids_$grp=\"\$_pids_$grp $cpid\"
    _pids_all="$_pids_all $cpid"
  fi
}
waitchild(){ 
  local ret=0
  local jl job
  if [ -n "$1" ]; then
    eval jl=\"\$_pids_$1\"
	unset _pids_$1
  else 
    #jl="$_pids_all"
    jl=`jobs -p`
	unset _pids_all
  fi
  for job in $jl; do 
    wait $job||ret=1 
  done
  return $ret
}

maxchild(){ 
  # jops -p 可能會列出已結束的process
  local n=$1
  [ "$n" -gt 0 ]||n=1
  while true; do
    local cpid
	local exist_n=0
    for cpid in `jobs -p` ;do
	  # 檢查process是否還存在
      kill -0 $cpid >/dev/null 2>&1 && ((exist_n++))
	done
	[ $exist_n -ge $n ] && SLEEP 0.5s || break
  done
}
_killchild(){ local plst=`jobs -p`;[ -n "$plst" ]&&kill $plst 2>/dev/null; }

#waitchild() {
#  while [ 1 = 1 ]; do
#    [ $(ps -aef|awk "{if (\$3 == $$) print \$2}"|wc -l) -gt 1 ] || break
#    usleep 500
#  done
#}
#maxchild() {
#  while [ 1 = 1 ]; do
#    [ $(ps -aef|awk "{if (\$3 == $$) print \$2}"|wc -l) -gt $1 ] || break
#    usleep 100
#  done
#}
#_killchild() {
#  echo stoping `basename $0`
#  (ps -aef|awk "{if (\$3 == $$) print \$2}"|xargs kill) 1>/dev/null 2>&1
#  exit 1
#}

_progress() {
  local sleep_param=0.05s; local pchars=(- \\\\ '|' / ); local n=0
  while true;do SLEEP 0.2s;((n++));((n%=4));echo -e "\b${pchars[$n]}\c"; done
}

_startprogress() { _progress& _progress_pid=$!;  }
_stopprogress() { kill -15 $_progress_pid; wait $_progress_pid; echo -e '\b\c'; }

#There is also direct support for white space removal in Bash variable substitution:
#testvar=$(wc -l < log.txt)
#trailing_space_removed=${testvar%%[[:space:]]}
#leading_space_removed=${testvar##[[:space:]]}


ismount(){ mountpoint -q $1; }
#ext=${file##*.}
#basename=${filepath##*/}
#dirname=${filepath%/*}

#_filesize(){ ls -l $1 |awk '{print $5}'; }
_filesize(){ stat -c "%s" $1; }

_rollingfile(){
  local fname=$1; local _FILE_NUM=$2; local num=$3
  local next_num=$(($num + 1))
  [ -n "_$FILE_NUM" ] || _FILE_NUM=5
  [ "$num" -ge $_FILE_NUM ] && return
  [ -e ${fname}.${num} ] && _rollingfile $fname $_FILE_NUM $next_num
  #echo mv ${fname}.${num} ${fname}.${next_num}
  mv ${fname}.${num} ${fname}.${next_num}
}

_check_rolling(){
  local logfile=$1; local _LIMIT_SIZE=$2; local _FILE_NUM=$3
  [ -n "$_LIMIT_SIZE" ] || _LIMIT_SIZE=$LIMIT_SIZE; [ -n "$_LIMIT_SIZE" ] || _LIMIT_SIZE=5000000
  [ -n "$_FILE_NUM" ] || _FILE_NUM=$FILE_NUM; [ -n "$_FILE_NUM" ] || _FILE_NUM=5
  [ -f $logfile ] || return
  if [ "`_filesize $logfile`" -gt $_LIMIT_SIZE ]; then
    echo cp $logfile ${logfile}.0
    cp $logfile ${logfile}.0
    >$logfile
    _rollingfile $logfile $_FILE_NUM 0
  else
    touch $logfile
  fi
}
#_log() { sed -e "1 s/^/`date '+%Y-%m-%d_%H:%M:%S'`|$$|/" -e "2,$ s/^/  |/" >>$1; check_rolling $1; }
#log() { local logfile=$1; shift; [ -n "$1" ] && echo "$@"| _log $logfile || _log $logfile; }

_NONE=0
_ERROR=1
_WARN=2
_INFO=3
_DEBUG=4
_MAX_USED_LOGLEVEL=0
MAX_USED_LOGLEVEL=NONE
LOGLEVEL=$_INFO
DEFAULT_LOGLEVEL=$_INFO

reset_max_used_loglevel(){ _MAX_USED_LEVEL=$_NONE; }
_rawlog() { SED -e "1 s/^/`date '+%Y\/%m\/%d_%H:%M:%S.%3N'`|`printf '%5s' $$`|$1|/" -e "2,$ s/^/  /" ; }
_writelog() { cat >>$1; _check_rolling $1; }
_log() {
  local logfile=$1; shift
  local loglevel=$1; shift
  if [[ $loglevel > $_MAX_USED_LOGLEVEL ]];then
    _MAX_USED_LOGLEVEL=$loglevel
    case "$loglevel" in
      $_ERROR) MAX_USED_LOGLEVEL=ERROR;;
      $_WARN ) MAX_USED_LOGLEVEL=WARN;;
      $_INFO ) MAX_USED_LOGLEVEL=INFO;;
      $_DEBUG) MAX_USED_LOGLEVEL=DEBUG;;
      *)       MAX_USED_LOGLEVEL=NONE
    esac
  fi
  [[ $loglevel > $LOGLEVEL ]] && return 0
  local logldesc syslogdesc
  case "$loglevel" in
    $_ERROR) logldesc=E;syslogdesc=daemon.err;;
    $_WARN ) logldesc=W;syslogdesc=daemon.warning;;
    $_INFO ) logldesc=I;syslogdesc=daemon.info;;
    $_DEBUG) logldesc=D;syslogdesc=daemon.debug;;
    *)       logldesc=N;syslogdesc=
  esac

  if [ "$logfile" = "[SYSLOG]" ]; then
    [ -n "$*" ] && logger -t "$PROGRAM" -p $syslogdesc "$*" || logger -t "$PROGRAM" -p $syslogdesc
  elif [ -n "$logfile" ];then
    [ -n "$*" ] && { echo "$*"| _rawlog $logldesc|_writelog $logfile; } || { _rawlog $logldesc|_writelog $logfile; }
  else
    [ -n "$*" ] && { echo "$*"| _rawlog $logldesc; } ||  _rawlog $logldesc
  fi
}
log()       { _log "$LOGFILE" $DEFAULT_LOGLEVEL "$@"; }
log_debug() { _log "$LOGFILE" $_DEBUG "$@"; }
log_info()  { _log "$LOGFILE" $_INFO  "$@"; }
log_warn()  { _log "$LOGFILE" $_WARN  "$@"; }
log_error() { _log "$LOGFILE" $_ERROR "$@"; }
log2file()      { local LOGFILE="$1";shift;log "$@"; }
log_debug2file(){ local LOGFILE="$1";shift;log_debug "$@"; }
log_info2file() { local LOGFILE="$1";shift;log_info  "$@"; }
log_warn2file() { local LOGFILE="$1";shift;log_warn  "$@"; }
log_error2file(){ local LOGFILE="$1";shift;log_error "$@"; }

#fi
