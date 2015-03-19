#! /bin/sh
#http://www.gentoo.org/doc/en/gentoo-security.xml
echo "$3" | mail -s "Warning (program : $2)" root
