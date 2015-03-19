/* Mapping tables for EUC-TW handling.
   Copyright (C) 1998, 1999, 2000-2002, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1998.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#include <dlfcn.h>
#include <stdint.h>
#include <cns11643l1.h>
#include <cns11643.h>
#include <euc2ucs.h>
#include <ucs2euc.h>

/* Definitions used in the body of the `gconv' function.  */
#define CHARSET_NAME		"EUC-TW//"
#define FROM_LOOP		from_euc_tw
#define TO_LOOP			to_euc_tw
#define DEFINE_INIT		1
#define DEFINE_FINI		1
#define MIN_NEEDED_FROM		1
#define MAX_NEEDED_FROM		4
#define MIN_NEEDED_TO		4


/* First define the conversion function from EUC-TW to UCS4.  */
#define MIN_NEEDED_INPUT	MIN_NEEDED_FROM
#define MAX_NEEDED_INPUT	MAX_NEEDED_FROM
#define MIN_NEEDED_OUTPUT	MIN_NEEDED_TO
#define LOOPFCT			FROM_LOOP
#define BODY																\
  {																			\
	if ((inend - inptr) < 1)												\
	{																		\
		result =  __GCONV_INCOMPLETE_INPUT;							\
		break;																\
	}																		\
																			\
	if ((outend - outptr) < 4)											\
	{																		\
		/* We ran out of space.*/										\
		result = __GCONV_FULL_OUTPUT;									\
		break;																\
	}																		\
																			\
	unsigned int ch = *inptr;											\
																			\
	if (ch <= 0x7f)														\
	{																		\
		/*Plain ASCII.*/													\
		++inptr;															\
	}																		\
	else if (ch != 0x8e)													\
	{																		\
		/* Ths is illegal.*/												\
		STANDARD_FROM_LOOP_ERR_HANDLER(1);								\
	}																		\
	else																	\
	{																		\
		unsigned int ech, ch2, ch3, ch4;								\
		unsigned char *echptr;											\
																			\
		if ((inend - inptr) < 4)											\
		{																	\
			result = __GCONV_INCOMPLETE_INPUT;							\
			break;															\
		}																	\
		ch2 = *(inptr + 1);												\
		ch3 = *(inptr + 2);												\
		ch4 = *(inptr + 3);												\
		if(ch2 < 0xa1|| ch3 < 0xa0 || ch4 < 0xa0)		\
		{																	\
			/* Ths is illegal.*/											\
			STANDARD_FROM_LOOP_ERR_HANDLER(1);							\
		}																	\
		echptr = (unsigned char *)&ech;									\
		echptr[0]=inptr[3];												\
		echptr[1]=inptr[2];												\
		echptr[2]=inptr[1];												\
		echptr[3]=inptr[0];												\
		ch = euc2ucs(ech);												\
		if (ch == 0)														\
		{																	\
			STANDARD_FROM_LOOP_ERR_HANDLER(4);							\
		}																	\
		inptr += 4;														\
	}																		\
	put32(outptr, ch);													\
	outptr += 4;															\
  }
#define LOOP_NEED_FLAGS
#define ONEBYTE_BODY														\
  {																			\
    if (c < 0x80)															\
      return c;															\
    else																	\
      return WEOF;														\
  }
#include <iconv/loop.c>

/* Next, define the other direction.  */
#define MIN_NEEDED_INPUT	MIN_NEEDED_TO
#define MIN_NEEDED_OUTPUT	MIN_NEEDED_FROM
#define MAX_NEEDED_OUTPUT	MAX_NEEDED_FROM
#define LOOPFCT			TO_LOOP
#define BODY																\
  {																			\
	if ((inend - inptr) < 4)												\
	{																		\
		result =  __GCONV_INCOMPLETE_INPUT;							\
		break;																\
	}																		\
																			\
	unsigned int ech;														\
	unsigned char *echptr;												\
																			\
	unsigned int ch = get32(inptr);										\
	if (ch <= 0x7f)														\
		*outptr++ = ch;													\
	else																	\
	{																		\
		if ((outend - outptr) < 4)										\
		{																	\
			/* We ran out of space.*/									\
			result = __GCONV_FULL_OUTPUT;								\
			break;															\
		}																	\
		ech = ucs2euc(ch);												\
		if (ech == 0)														\
		{																	\
			UNICODE_TAG_HANDLER(ch, 4);									\
			/*Illegal character.*/										\
			STANDARD_TO_LOOP_ERR_HANDLER(4);							\
		}																	\
		/*put32(outptr, ech);*/											\
		/*outptr += 4;*/													\
		echptr=(unsigned char *) &ech;									\
		*outptr++=echptr[3];												\
		*outptr++=echptr[2];												\
		*outptr++=echptr[1];												\
		*outptr++=echptr[0];												\
	}																		\
	inptr += 4;															\
  }
#define LOOP_NEED_FLAGS
#include <iconv/loop.c>

/* Now define the toplevel functions.  */
#include <iconv/skeleton.c>
