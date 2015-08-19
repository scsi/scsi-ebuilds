#!/bin/bash
if [ -z "$COMMFUNC_LOAD" ]; then
COMMFUNC_LOAD=LOAD
trap "_killchild" 1 2 9 15

case `uname` in
  AIX)
    export PATH=/SRIS/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/bin/X11:/sbin:/usr/java6_64/jre/bin:/usr/vac/bin:/usr/vacpp/bin:/usr/local/mysql/bin:/opt/freeware/bin
    #export LIBPATH=/opt/freeware/lib:$LIBPATH
    export LIBPATH=$LIBPATH:/opt/freeware/lib
  ;;
esac

PROG=$0
 
die() { echo "$@" >&2; exit 1; }
[ -z "$BASH" ] && die "Plz use bash for shell execute."
check_env_show(){
  for var in $@; do
    eval value=\$$var
    echo $var=$value
    [ -z "$value" ] && die "$var is not set. Pls check environment."
  done
}
check_env(){
  for var in $@; do
    eval value=\$$var
    [ -z "$value" ] && die "$var is not set. Pls check environment."
  done
}
replace_env() {
   local var=$2
   local sfile=$1
   local value
   eval value=\$$var
   eval export $var
   #[ -n "$value" ] && printf "%-11s = %s\n" $var  $value || die "$var not set"
   #printf "%-12s = %s\n" $var  "$value"
   value=`echo "$value"|sed -e "s/\//\\\\\\\\\\\\//g"`
   /opt/freeware/bin/sed -i "s/\${$var}/$value/g" $sfile
}
testclient(){ testclient $@; }
printtitle() {
  local line="+---------------------------------------------------------------------+"
  local msg="$@"; local tnu=$((${#line} - 6));tnu=$((${tnu} - ${#msg}))
  local lnu=`expr $tnu / 2`; local rnu=`expr $tnu - $lnu`
  echo "$line"; printf "|>" ; local nu=0
  while [ $nu -le $lnu ]; do
    printf " "; nu=`expr $nu + 1`
  done
  printf "$msg"; nu=0
  while [ $nu -le $rnu ]; do
     printf " "; nu=`expr $nu + 1`
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
_tab(){ 
  [ -z "$1" ] && return 0
  echo "$1"|sed "s/^/  |/"
  echo
}
_buexec(){
  [ $# -lt 2 ] && { echo wrong param. ;return 1; }
  local _stime=`_nowtime`; local desc="$1"; local cmd="$2"; local ext="$3"; local mode="$4"
  local tmpfile=/tmp/insris.$$.log
  local busdate="`usedtime $_sris_stime`"
  local rtn msg rst
  local titlestr=`printf "(%s)%-45s: " "$busdate" "$desc"`
  [ -n "$mode" ] || printf "$titlestr"
  msg=`eval $cmd 2>&1`
  #eval $cmd >$tmpfile 2>&1
  rtn=$?
  [ $rtn = 0 ] &&  rst="success. [`usedtime $_stime`]" || rst="fail.  [`usedtime $_stime`]"
  #msg=`cat $tmpfile`;rm -f $tmpfile
  case "$ext" in
  1|always) : ;;
  0|never) msg="";;
  *) [ $rtn = 0 ] && msg=""
  esac
  msg=`_tab "$msg"`
  if [ -n "$mode" ]; then
    [ -n "$msg" ] && printf "%s%s\n%s\n" "$titlestr" "$rst" "$msg" || printf "%s%s\n" "$titlestr" "$rst"
  else
    [ -n "$msg" ] && printf "%s\n%s\n" "$rst" "$msg" || printf "%s\n" "$rst"
  fi
  return $rtn
}
singlexec(){ _buexec "$1" "$2" "$3" "single"; }
multiexec(){ _buexec "$1" "$2" "$3" "multi" & }
waitchild() {
  while [ 1 = 1 ]; do
    [ $(ps -aef|awk "{if (\$3 == $$) print \$2}"|wc -l) -gt 1 ] || break
    usleep 500
  done
}
maxchild() {
  while [ 1 = 1 ]; do
    [ $(ps -aef|awk "{if (\$3 == $$) print \$2}"|wc -l) -gt $1 ] || break
    usleep 100
  done
}
_killchild() {
  echo stoping `basename $0`
  (ps -aef|awk "{if (\$3 == $$) print \$2}"|xargs kill) 1>/dev/null 2>&1
  exit 1
}

filesize(){ ls -l $1 |awk '{print $5}'; }

_rollingfile(){
  local fname=$1; local _FILE_NUM=$2; local num=$3
  local next_num=`expr $num + 1`
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
  if [ "`filesize $logfile`" -gt $_LIMIT_SIZE ]; then
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

_ERROR=0
_WARN=1
_INFO=2
_DEBUG=3
LOGLEVEL=$_INFO

_rawlog() { sed -e "1 s/^/`date '+%Y\/%m\/%d_%H:%M:%S.%3N'`|`printf '%5s' $$`|$1|/" -e "2,$ s/^/  /" >>$2; _check_rolling $2; }
_log() {
  local loglevel=$1; shift
  local logfile=$1; shift
  [[ $loglevel > $LOGLEVEL ]] && return 0
  local logldesc
  case "$loglevel" in
    $_ERROR) logldesc=E;;
    $_WARN ) logldesc=W;;
    $_INFO ) logldesc=I;;
    $_DEBUG) logldesc=D;;
    *)       logldesc=N
  esac
  [[ -n $1 ]] && echo "$@"| _rawlog $logldesc $logfile || _rawlog $logldesc $logfile;
}
log()       { _log $LOGLEVEL $LOGFILE "$@"; }
log_debug() { _log $_DEBUG   $LOGFILE "$@"; }
log_info()  { _log $_INFO    $LOGFILE "$@"; }
log_warn()  { _log $_WARN    $LOGFILE "$@"; }
log_error() { _log $_ERROR   $LOGFILE "$@"; }

fi
