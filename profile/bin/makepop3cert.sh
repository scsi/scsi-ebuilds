#/usr/portage/net-mail/uw-imap/
#http://www.study-area.org/tips/pop3s.htm

for i in imapd ipop3d
do
	umask 077
	PEM1=`/bin/mktemp openssl.XXXXXX`
	PEM2=`/bin/mktemp openssl.XXXXXX`
	/usr/bin/openssl req -newkey rsa:1024 -keyout $PEM1 -nodes -x509 -days 365 -out  $PEM2 << EOF
--
SomeState
SomeCity
SomeOrganization
SomeOrganizationalUnit
localhost
root@localhost
EOF

	cat $PEM1 >  ${i}.pem
	echo ""    >> ${i}.pem
	cat $PEM2 >> ${i}.pem
	rm $PEM1 $PEM2
	umask 022
done
echo please copy imapd.pem and ipop3d.pem to /etc/ssl/certs.
