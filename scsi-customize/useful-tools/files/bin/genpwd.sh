#!/bin/bash
# https://thornelabs.net/2014/02/03/hash-roots-password-in-rhel-and-centos-kickstart-profiles.html
SALT_CHAR=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789./
gen_salt(){
  for aa in `seq 1 $1`;do
  printf ${SALT_CHAR:$((RANDOM%64)):1}
  done
}
#gen_salt 16
usage(){
  echo
  echo "Usage: `which $0` [option] [password]"
  echo "  -m,--method= : hash method. vaild value is MD5(default), SHA256, SHA512."
  echo "  -r,--random : random password"
  exit 1
}
method=md5
opt=`getopt -o m:r --long method:,random -n '$PROGRAM' -- "$@"`
eval set -- "$opt"
while true ; do
  case "$1" in
  -r|--random) pwstr=`ranpwd -a`;echo $pwstr;shift;;
  -m|--method) method=${2};shift 2;;
  --)shift;break;;
  *) usage
  esac
done
[ -n "${pwstr=$1}" ] && py_pwstr="'$pwstr'" || py_pwstr="getpass.getpass()"
case "$method" in
md5)
  [ -z "$pwstr" ] && { printf "Password: "; read -s pwstr; }
  openssl passwd -1 $pwstr;;
sha256) #echo 'import crypt,getpass; print crypt.crypt(getpass.getpass(), "$1$8_CHARACTER_SALT_HERE")' | python -;;
  python -c "import crypt,getpass; print(crypt.crypt(${py_pwstr}, crypt.mksalt(crypt.METHOD_SHA256)))"
  ;;
sha512) #echo 'import crypt,getpass; print crypt.crypt(getpass.getpass(), "$6$16_CHARACTER_SALT_HERE")' | python -;;
  python -c "import crypt,getpass; print(crypt.crypt(${py_pwstr}, crypt.mksalt(crypt.METHOD_SHA512)))"
  ;;
*) echo "Hash method '$method' is not supported.";usage
esac
