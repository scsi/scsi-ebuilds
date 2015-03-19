Name: socks5
Version: 1.0r11
Release: 3
Group: Networking/Daemons
Summary: SOCKS 5.0 Server Daemon
Copyright: Copyright (c) 1995,1998 NEC Corporation.  Freely Distributable
Source0: http://wwww.socks.nec.com/12462347/%{name}-v%{version}.tar.gz
Source1: socks5.init
Source2: unsocks
Patch:   socks5-v1.0r11.patch1.txt
Buildroot: /var/tmp/socks5-root
Packager: Henri Gomez <gomez@slib.fr>, Aron Griffis <agriffis@css.tayloru.edu>, Avi Alkalay <avi@br.ibm.com>

%package clients
Summary: Network applications written to use NWSL SOCKS 5.0.
Group: Networking

%package -n runsocks
Summary: DLL and utility to socksify existing applications.
Group: Networking

%package devel
Summary: SOCKS 5.0 header file and library
Group: Development/Libraries

%description
This is NWSL (previously CSTC) version 5.0 of SOCKS, a package that
allows Unix hosts behind a firewall to gain full access to the
internet without requiring direct IP reachability.  It does require a
SOCKS server program being run on a host that can communicate directly
to hosts behind the firewall as well as hosts on the Internet at
large.  It is based on the original SOCKS written by David Koblas
<koblas@netcom.com> and the work of the AFT working group of the IETF.

Built under Redhat 6.2 and rpm 3.0.5

%description clients
Client programs such as ping, traceroute, ftp, finger, whois, archie, and 
telnet that use SOCKS 5.0.  Also includes a dynamic link library and script 
that allows you to "socksify" programs that don't normally use SOCKS.

Built under Redhat 6.2 and rpm 3.0.5

%description devel
This is the header file and library required to develop for NWSL 
(previously CSTC) version 5.0 of SOCKS.

Built under Redhat 6.2 and rpm 3.0.5

%description -n runsocks
Dynamic link library and utility that allows you to "socksify"
programs that don't normally use SOCKS.

Built under RedHat 6.2 and rpm 3.0.5


%prep 
%setup -n %{name}-v%{version} 
%patch

%build
# Ideally, we'd just build the threaded version on all platforms, but
# then it wants to use the signal SIGUNUSED, and this isn't available
# on sparc.

%ifarch sparc
    ./configure --prefix=/usr \
    --with-srvpidfile=/var/run/socks5.pid \
    --with-libconffile=/etc/libsocks5.conf \
    --with-srvconffile=/etc/socks5.conf \
    --with-syslog-facility
    make
%else
    ./configure --prefix=/usr \
	--with-srvpidfile=/var/run/socks5.pid \
	--with-libconffile=/etc/libsocks5.conf \
	--with-srvconffile=/etc/socks5.conf \
	--with-syslog-facility \
	--with-threads
    make
%endif

%install
rm -rf $RPM_BUILD_ROOT
sourcedir=`pwd`

# "make install" creates all the necessary directories
make install prefix=$RPM_BUILD_ROOT/usr
cd $RPM_BUILD_ROOT/usr/bin
# We prefer the s5 prefix; it conflicts less
mv rarchie s5archie
mv rfinger s5finger
mv rftp s5ftp
mv rping s5ping
mv rtelnet s5telnet
mv rtraceroute s5traceroute
mv rwhois s5whois
# We restore the permissions on the clients in the %files section; 
# if they're 111 here then cpio won't be able to read them to build 
# the rpm.
chmod 511 s5*
strip s5*
# Move the daemon to the sbin directory
mkdir ../sbin
strip socks5
mv socks5 stopsocks ../sbin
# Install the init script
mkdir -p $RPM_BUILD_ROOT/etc/rc.d/init.d
install -m 755 $RPM_SOURCE_DIR/socks5.init \
    $RPM_BUILD_ROOT/etc/rc.d/init.d/socks5
# Default config file for the clients; no default for the daemon
echo "socks5 - - - - -" > $RPM_BUILD_ROOT/etc/libsocks5.conf

# Install the 'unsocks' utility
install -m 755 $RPM_SOURCE_DIR/unsocks $RPM_BUILD_ROOT/usr/bin/unsocks

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc ChangeLog Copyright README doc examples patches
%doc /usr/man/man1/stopsocks.*
%doc /usr/man/man1/socks5.*
%doc /usr/man/man5/socks5.conf.*
%doc /usr/man/man5/socks5.passwd.*
/usr/sbin/stopsocks
/usr/sbin/socks5
# This is marked %config so it'll be preserved if customizations are
# made and an upgrade is done.
%config /etc/rc.d/init.d/socks5

%files clients
%defattr(-,root,root)
%config /etc/libsocks5.conf
%doc /usr/man/man1/socks5_clients.*
%attr(111,root,root) /usr/bin/s5*

%files -n runsocks
%defattr(-,root,root)
%config /etc/libsocks5.conf
%doc /usr/man/man1/runsocks.*
%doc /usr/man/man5/libsocks5.conf.*
/usr/lib/libsocks5_sh.so
/usr/bin/runsocks
/usr/bin/unsocks

%files devel
%defattr(-,root,root)
%doc test
/usr/lib/libsocks5.a
/usr/include/socks.h

%post
chkconfig --add socks5

%preun
if [ $1 = 0 ]; then
    chkconfig --del socks5
fi

%changelog
* Mon Sep 25 2000 Henri Gomez <hgomez@slib.fr>
    * 1.0-11 RPM Release 3
    * Added patch (Linux sigfix)

* Thu Aug 31 2000 Henri Gomez <hgomez@slib.fr>
    * Updated spec to handle .gz man file for Redhat 6.2
 
* Fri Aug 25 2000 Henri Gomez <hgomez@slib.fr>
    * Updated to 1.0r11
    * removed patches

* Fri Nov 26 1999 Henri Gomez <gomez@slib.fr>
    * Added dup patch
    * moved changelog at end of spec file

* Tue Nov 2  1999 Henri Gomez <gomez@slib.fr>
    * Added ftp client patch

* Wed Sep 8  1999 Gomez Henri <gomez@slib.fr>
    * Added s5fakehost patch

* Wed Aug 18 1999 Gomez Henri <gomez@slib.fr>
    * release 2 to avoid conflict with Matthew Vanecek RPM
    * Build under RH5.2 and RPM 3.0.2

* Mon Aug 16 1999 Gomez Henri <gomez@slib.fr>

    * Updated to 1.0r10
    * removed patches
    * remove unused INACTIVITY_TIMEOUT <luns@aloha.EECS.Berkeley.EDU>
    * rftp getpass()/getpassphrase() <handy@nid.co.jp>
    * added gethostbyname2() wrapper <andre.albsmeier@mchp.siemens.de>
    * pident patch fails if socks5.ident file not found <monte@home.com>
    * split ifdef for IRIX cc <china@thewrittenword.com>
    * patch for lsGetCachedHostname() <ishisone@sra.co.jp>
    * changed protocol return code for connection refused <alla@sovlink.ru>
    * autoconf threads and ident <tv@maussu.ndh.net>
    * SHLIB_LFLAGS for OSF cc <china@thewrittenword.com>
    * removed fclose() wrapper redhat 6.0 seg faults on fclose() when wrapped
    * rld.c fix for FreeBSD 3.x <andre.albsmeier@mchp.siemens.de>
    * fix child process signal.
    * fix runaway process.
    * rld.c macros are bad in v1.0r9 <oleg@elbim.ru>
    * server/udp.c close all sockets.

* Mon Jun 21 1999 Gomez Henri <gomez@slib.fr>

 * Removed watchAG which is no more available as a public beta.

* Tue Jun 17 1999 Avi Alkalay <avi@br.ibm.com>

  * Release 5
  * Separatio of socks5-clients in 2 packages: socks5-clients and runsocks
  * Added 'unsocks' to runsocks package. This new utility permits run programs
    unsocksified, when all session is socksified
  * Stripped install. Now binaries are smaller

* Mon Jun 14 1999 Gomez Henri <gomez@slib.fr>

  * added _fclose patch from Martin Mevald <martinmv@hornet.cz) which
    fix PRELOAD and runsocks problems.

* Tue Apr 27 1999 Gomez Henri <gomez@slib.fr>

  * added child process and runaway process patches

* Wed Mar 31 1999 Gomez Henri <gomez@slib.fr>

   * added runsocks and udp close socket patches

* Thu Mar 11 1999 Gomez Henri <gomez@slib.fr>

   * Updated to 1.0r9
   * username/passwd eof fix
   * changed threading model
   * added SOCKS5_V4SUPPORT
   * runsocks.in fix <nobbi@cheerful.com>
   * Makefile.in install-sh bugs <eychenne@info.enserb.u-bordeaux.fr>
   * removed old MONITOR code
   * fixed 'make clean' target
   * sendmsg/recvmsg in headers generate warnings <michael@bizsystems.com>
   * modified ftp client so commands are not split into
     two packets.  some packet filtering firewalls will
     block connection when sent as two packets.
   * added doc to socks5.conf.5 about SOCKS5_REVERSEMAP
   * moved s5fakehost file from ~/.s5fakehost to /tmp/.s5fakehost.uid
   * dlopen relative paths do not work on FreeBSD <andre.albsmeier@mchp.siemens.de>
   * moved dlopen relative path to configure

* Thu Nov 19 1998 Henri Gomez  <nri@mail.dotcom.fr>

    Updated to 1.0r8
    used the excellent spec file for 1.0r7 file from Aron Griffis <agriffis@css.tayloru.edu>

Fri Nov 13 10:18:06 CST 1998
        * updated setpgrp configure test
        * added SOCKS5_NOREVERSEMAP to config file parsing
          - config files with many IP addrs will load faster
        * pass dlopen() relative paths

Thu Nov 12 10:46:04 CST 1998
        * changed rresvport() wrapper -- like bind() wrapper
        * moved faked host table from memory to file
          - fixes Netscape Communicator 4.5 problem.
        * moved 'getpwuid()' in lsEffUser to fix FreeBSD bug.

Tue Nov  3 17:58:02 CST 1998
        * added test/handling for sendmsg/(recvmsg)

Tue Oct 27 12:44:44 CST 1998
        * added configure test for setpgrp

Tue Oct 20 11:58:41 CDT 1998
        * added blurb in socks5.conf.5 about proper configurations.

Wed Oct 14 09:16:16 CDT 1998
        * removed files with only internal code, related cleanup.

Fri Oct  9 09:09:42 CDT 1998 eychenne@col.bsf.alcatel.fr
        * changed bad #ifdef label in lib/log.c

Mon Oct  5 16:45:59 CDT 1998
        * added "round robin DNS" support (ftp-data).
        * changed SOCKS5_TIMEOUT & SOCKS5_UDPPORTRANGE
          - now can be set from /etc/socks5.conf
        * changed UDP recvfrom

Thu Oct  1 13:16:35 CDT 1998
        * changed Makefile.in clients.install target so
          libsocks5.a is not installed

* Mon Nov 16 1998 Aron Griffis <agriffis@css.tayloru.edu>
- built non-threaded version on sparc; the threaded version wants
  SIGUNUSED which isn't available
- s5watch stuff is now only built on i386

* Thu Nov 12 1998 Aron Griffis <agriffis@css.tayloru.edu>
- built both s5watch and normal packages from single source rpm

* Wed Nov 11 1998 Aron Griffis <agriffis@css.tayloru.edu>
- spec cleanup and buildrooted
- base package now contains socks daemon, modeled after bind rpms
- fixed init scripts to use chkconfig
- removed notes that were echoing on install; they were unnecessary
  and had the potential to cause problems with automated installations

* Wed Oct 21 1998 Henri Gomez  <nri@mail.dotcom.fr>

    Updated to 1.0r7

* Wed Jul 22 1998 Daniel Deimert <d1dd@dtek.chalmers.se>

    Updated to 1.0r6

* Mon Jul 13 1998 Daniel Deimert <d1dd@dtek.chalmers.se>

    Added Patches for RedHat 5.1


