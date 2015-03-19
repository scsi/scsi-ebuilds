/*
 * $Header: /var/cvsroot/ws/tools/src/echohex/echohex.c,v 1.1 2006/01/10 10:50:00 scsi Exp $
 * $Project: echohex$
 * $Purpose: echo data to hex and revser$ 
 * $RCSfile: echohex.c,v $
 * $Source: /var/cvsroot/ws/tools/src/echohex/echohex.c,v $
 * $Initial: 2005/12/22$
 * $Creater: 陳勇洲 (Chen Yung Chou)$
 * $Author: scsi $
 * $Date: 2006/01/10 10:50:00 $
 * $Revision: 1.2 $
 * $Log: echohex.c,v $
 * Revision 1.1  2006/01/10 10:50:00  scsi
 * 首次簽入
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <string.h>
#ifdef Linux
#include <getopt.h>
#endif
#define RVERSION "$Revision: 1.1 $"

FILE *infile = NULL, *outfile = NULL, *errfile = NULL;

void exit_f(int code)
{
	if (infile != stdin && infile != NULL)
		fclose(infile);
	if (outfile != stdout && outfile != NULL)
		fclose(outfile);
	if (errfile != stderr && errfile != NULL)
		fclose(errfile);
	exit(code);
}

void showversion()
{
	char temp1[100];
	char rversion[100];
	char temp2[100];

	sscanf(RVERSION, "%s %s %s", temp1, rversion, temp2);
	printf("Version: %s\n", rversion);
}

void showhelp(char *mainpgm)
{
	fprintf(stderr,
			"Usage: %s [-v] [-r] [-u] [-e error_log] [-o outfile] [infile]\n",
			basename(mainpgm));
}

int main(int argc, char *argv[])
{
	extern char *optarg;
	extern int optind, opterr, optopt;
	int c;
	int rev = 0;
	int upcase = 0;
	char formatstr[10];

	infile = NULL;
	outfile = NULL;
	errfile = NULL;

	while ((c = getopt(argc, argv, "hvrue:o:")) != -1)
	{
		switch (c)
		{
			case 'h':
				{
					showversion();
					showhelp(argv[0]);
					exit_f(0);
				}
				break;
			case 'v':
				{
					showversion();
					exit_f(0);
				}
				break;
			case 'r':
				{
					rev = 1;
				}
				break;
			case 'u':
				{
					upcase = 1;
				}
				break;
			case 'e':
				{
					if (errfile != NULL)
					{
						showhelp(argv[0]);
						exit_f(3);
					}
					else if (strcmp(optarg, "-") == 0)
					{
						errfile = stderr;
					}
					else
					{
						errfile = fopen(optarg, "w");
						if (errfile == NULL)
						{
							fprintf(stderr,
									"ERROR : opening error file %s failed.\n",
									optarg);
							exit_f(2);
						}
					}
				}
				break;
			case 'o':
				{
					if (outfile != NULL)
					{
						showhelp(argv[0]);
						exit_f(3);
					}
					else if (strcmp(optarg, "-") == 0)
					{
						outfile = stderr;
					}
					else
					{
						outfile = fopen(optarg, "w");
						if (outfile == NULL)
						{
							fprintf(stderr,
									"ERROR : opening output file %s failed.\n",
									optarg);
							exit_f(2);
						}
					}
				}
				break;
			case ':':			/* -f or -o without arguments */
				fprintf(stderr, "Option -%c requires an argument\n", optopt);
				showhelp(argv[0]);
				exit_f(3);
				break;
			case '?':
				fprintf(stderr, "Unrecognized option: - %c\n", optopt);
				showhelp(argv[0]);
				exit_f(3);
				break;
			default:
				fprintf(stderr, "Undefine option: - %c\n", optopt);
				showhelp(argv[0]);
				exit_f(3);
				break;
		}
	}
	for (; optind < argc; optind++)
	{
		if (infile == NULL)
		{
			//fprintf(stderr,"in file %s\n",argv[optind]);
			if (strcmp(argv[optind], "-") == 0)
			{
				infile = stdin;
			}
			else if ((infile = fopen(argv[optind], "r+b")) == (FILE *) NULL)
			{
				fprintf(stderr, "ERROR : opening input file %s failed.\n",
						argv[optind]);
				exit_f(2);
			}
		}
		else
		{
			showhelp(argv[0]);
			exit_f(1);
		}
	}
	if (infile == NULL)
		infile = stdin;
	if (outfile == NULL)
		outfile = stdout;
	if (errfile == NULL)
		errfile = stderr;

	if (upcase == 1)
	{
		strcpy(formatstr, "%02X");
	}
	else
	{
		strcpy(formatstr, "%02x");
	}

	if (rev == 1)
	{
		char str[3];
		int aa;

		str[2] = 0;
		while (1)
		{
			str[0] = getc(infile);
			if (feof(infile) != 0)
				break;
			str[1] = getc(infile);
			if (feof(infile) != 0)
			{
				fprintf(errfile, "lost last byte for '%c'\n", str[0]);
				break;
			}
			sscanf(str, "%x", &aa);
			fprintf(outfile, "%c", aa);
		}
	}
	else
	{
		unsigned char ch;

		for (ch = getc(infile); feof(infile) == 0; ch = getc(infile))
		{
			fprintf(outfile, formatstr, ch);
		}
	}

	exit_f(0);
}
