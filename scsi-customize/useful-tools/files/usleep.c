/* vi: set sw=4 ts=4: */
/*
 * Mini sleep implementation for busybox
 *
 *
 * Copyright (C) 1995, 1996 by Bruce Perens <bruce@pixar.com>.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

const char sleep_usage[] = "usleep N\n"
	"\nPause for N microseconds.\n"
	;

void usage(const char * msg)
{
	printf("usage: %s",msg);
	exit(1);
}

int main(int argc, char **argv)
{
	if ((argc < 2) || (**(argv + 1) == '-')) {
		usage(sleep_usage);
	}

	if (usleep(atoi(*(++argv))*1000) != 0) {
		perror("usleep");
		exit(1);
	}
 	return(0);
}
