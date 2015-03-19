/* Copyright (c) 1995-1999 NEC USA, Inc.  All rights reserved.               */
/*                                                                           */
/* The redistribution, use and modification in source or binary forms of     */
/* this software is subject to the conditions set forth in the copyright     */
/* document ("Copyright") included with this distribution.                   */

/*
 * $Id: socks.h,v 1.14.4.8 1999/08/02 14:58:40 wlu Exp $
 */

#ifndef SOCKS_H
#define SOCKS_H

#ifdef SOCKS

#ifdef INCLUDE_PROTOTYPES
#include "socks5/socks5p.h"

extern int LIBPREFIX(init)        P((char *));
extern int LIBPREFIX(getpeername) P((int, struct sockaddr *, int *));
extern int LIBPREFIX(getsockname) P((int, struct sockaddr *, int *));
extern int LIBPREFIX(accept)      P((int, struct sockaddr *, int *));
extern int LIBPREFIX(connect)     P((int, const struct sockaddr *, int));
extern int LIBPREFIX(bind)        P((int, const struct sockaddr *, int));

extern IORETTYPE LIBPREFIX(recvfrom)    P((int,       IOPTRTYPE, IOLENTYPE, int,       struct sockaddr *, int *));
extern IORETTYPE LIBPREFIX(sendto)      P((int, const IOPTRTYPE, IOLENTYPE, int, const struct sockaddr *, int));
#ifdef HAVE_SENDMSG
extern IORETTYPE LIBPREFIX(recvmsg)     P((int, const struct msghdr *, int));
extern IORETTYPE LIBPREFIX(sendmsg)     P((int, const struct msghdr *, int));
#endif
extern IORETTYPE LIBPREFIX(recv)        P((int,       IOPTRTYPE, int, int));
extern IORETTYPE LIBPREFIX(send)        P((int, const IOPTRTYPE, int, int));
extern IORETTYPE LIBPREFIX(read)        P((int,       IOPTRTYPE, IOLENTYPE));
extern IORETTYPE LIBPREFIX(write)       P((int, const IOPTRTYPE, IOLENTYPE));

extern int LIBPREFIX(fprintf)     P((FILE *, const char *, ...));
extern int LIBPREFIX(vfprintf)    P((FILE *, const char *, ...));
extern int LIBPREFIX(getc)        P((FILE *));

extern int LIBPREFIX(rresvport)   P((int *));
extern int LIBPREFIX(shutdown)    P((int, int));
extern int LIBPREFIX(listen)      P((int, int));
extern int LIBPREFIX(close)       P((int));
extern int LIBPREFIX(dup)         P((int));
extern int LIBPREFIX(dup2)        P((int, int));
extern struct tm * LIBPREFIX(localtime) P((const time_t *));
extern void        LIBPREFIX(longjmp)   P((jmp_buf, int));
extern int LIBPREFIX(select)      P((int, fd_set *, fd_set *, fd_set *, struct timeval *));

extern struct hostent *LIBPREFIX(gethostbyname) P((char *));
#ifdef HAVE_GETHOSTBYNAME2
extern struct hostent *LIBPREFIX(gethostbyname2) P((char *, int));
#endif
#endif /* include prototypes */

#ifndef LIBPREFIX
#ifdef USE_SOCKS4_PREFIX
#define LIBPREFIX(x)  R ## x
#else
#define LIBPREFIX(x)  SOCKS ## x
#endif
#endif

#if defined(getpeername) && defined(_AIX)
#undef  getpeername
#define getpeername   LIBPREFIX(ngetpeername)
#else
#define getpeername   LIBPREFIX(getpeername)
#endif

#if defined(getsockname) && defined(_AIX)
#undef  getsockname
#define getsockname   LIBPREFIX(ngetsockname)
#else
#define getsockname   LIBPREFIX(getsockname)
#endif

#if defined(accept) && defined(_AIX)
#undef  accept
#define accept        LIBPREFIX(naccept)
#else
#define accept        LIBPREFIX(accept)
#endif

#if defined(recvfrom) && defined(_AIX)
#undef  recvfrom
#define recvfrom      LIBPREFIX(nrecvfrom)
#else
#define recvfrom      LIBPREFIX(recvfrom)
#endif

#ifdef HAVE_GETHOSTBYNAME2
#define gethostbyname2 LIBPREFIX(gethostbyname2)
#endif
#define gethostbyname LIBPREFIX(gethostbyname)
#define rresvport     LIBPREFIX(rresvport)
#define connect       LIBPREFIX(connect)
#define listen        LIBPREFIX(listen)
#define select        LIBPREFIX(select)
#define bind          LIBPREFIX(bind)

#define shutdown      LIBPREFIX(shutdown)
#define localtime     LIBPREFIX(localtime)
#define longjmp       LIBPREFIX(longjmp)
#define close         LIBPREFIX(close)
#define dup2          LIBPREFIX(dup2)
#define dup           LIBPREFIX(dup)

#define recv          LIBPREFIX(recv)
#define sendto        LIBPREFIX(sendto)
#define send          LIBPREFIX(send)

#define read          LIBPREFIX(read)
#define write         LIBPREFIX(write)

#define fprintf       LIBPREFIX(fprintf)
#define vfprintf      LIBPREFIX(vfprintf)

#ifdef getc
#undef getc
#define getc          LIBPREFIX(getc)
#else
#define getc          LIBPREFIX(getc)
#endif

#if defined(SOCKS4TO5) && !defined(USE_SOCKS4_PREFIX)

#define Rconnect      LIBPREFIX(connect)
#define Rbind         LIBPREFIX(bind)
#define Raccept       LIBPREFIX(accept)
#define Rlisten       LIBPREFIX(listen)
#define Rselect       LIBPREFIX(select)
#define Rgetsockname  LIBPREFIX(getsockname)
#define Rgetpeername  LIBPREFIX(getpeername)

#endif
#endif /* SOCKS */
#endif /* included socks.h */


