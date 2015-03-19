/*
 * Author : Chen Yung Chou
 * Date:  : 2008/03/10
 * Purpose: strip c language's comment
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define NORMAL 0
#define IN_QUOTE 1
#define IN_CHOTE 2
#define CHECK_COMMENT 3
#define IN_COMMENT1 4
#define IN_COMMENT2 5

int strip_comments(FILE * fp, FILE * outfp, FILE * errfp);

char *programname;
FILE *infile = NULL;
FILE *outfile = NULL;
FILE *errfile = NULL;

void usage()
{
	fprintf(stderr,
			"\nUsage: %s [-v] [-c] [-o output_file] [-i input_file] [-e error_file] [input_file [out_file]]\n\n",
			basename(programname));
	fprintf(stderr, "   -v\t\t:show current version\n");
	fprintf(stderr, "   -o outfile\t:set output file, default is stdout\n");
	fprintf(stderr, "   -i infile\t:set input file, default is stdin\n");
	fprintf(stderr,
			"   -e errfile\t:set error output file, default is stderr\n");
	fprintf(stderr, "\n");
}

void exit_f(int code)
{
	fflush(infile);
	fflush(errfile);
	if (infile != stdin && infile != NULL)
		fclose(infile);
	if (outfile != stdout && outfile != NULL)
		fclose(outfile);
	if (errfile != stderr && errfile != NULL)
		fclose(errfile);
	exit(code);
}

int main(int argc, char **argv)
{
	char *inname = NULL;
	char *outname = NULL;
	char *errname = NULL;
	char *exttabname = NULL;

	int c;
	extern char *optarg;
	extern int optind, opterr, optopt;

	programname = argv[0];

	while ((c = getopt(argc, argv, "vhi:o:e:")) != -1)
	{
		switch (c)
		{
			case 'h':			//help
				usage();
				exit(0);
				break;
			case 'v':			//version
				fprintf(stderr, "Version: 0.0.1\n");
				exit(0);
				break;
			case 'i':			//input file, default stdin
				if (inname == NULL)
				{
					inname = optarg;
				}
				else
				{
					usage();
					exit(3);
				}
				break;
			case 'o':			//output file, default stdout
				if (outname == NULL)
				{
					outname = optarg;
				}
				else
				{
					usage();
					exit(3);
				}
				break;
			case 'e':			// error file, default stderr
				if (errname == NULL)
				{
					errname = optarg;
				}
				else
				{
					usage();
					exit(3);
				}
				break;
			case ':':			/* -f or -o without arguments */
				fprintf(stderr, "Option -%c requires an argument\n", optopt);
				usage();
				exit(3);
				break;
			case '?':
				fprintf(stderr, "Unrecognized option: - %c\n", optopt);
				usage();
				exit(3);
				break;
			default:
				fprintf(stderr, "Undefine option: - %c\n", optopt);
				usage();
				exit(3);
				break;
		}
	}

	for (c = 1; optind < argc; optind++, c++)
	{
		switch (c)
		{
			case 1:
				if (inname == NULL)
				{
					inname = argv[optind];
				}
				else
				{
					usage();
					exit(3);
				}
				break;
			case 2:
				if (outname == NULL)
				{
					outname = argv[optind];
				}
				else
				{
					usage();
					exit(3);
				}
				break;
			default:
				usage();
				exit(3);
		}
	}

	if (inname != NULL && strcmp(inname, "-") != 0)
	{
		infile = fopen(inname, "r");
		if (infile == NULL)
		{
			fprintf(stderr,
					"open input file %s error: %s\n",
					inname, strerror(errno));
			exit(2);
		}
	}

	if (outname != NULL && strcmp(outname, "-") != 0)
	{
		outfile = fopen(outname, "w");
		if (outfile == NULL)
		{
			fprintf(stderr,
					"open output file %s error: %s\n",
					outname, strerror(errno));
			exit(2);
		}
	}

	if (errname != NULL && strcmp(errname, "-") != 0)
	{
		outfile = fopen(errname, "w");
		if (outfile == NULL)
		{
			fprintf(stderr,
					"open error file %s error: %s\n",
					errname, strerror(errno));
			exit(2);
		}
	}

	if (infile == NULL)
		infile = stdin;
	if (outfile == NULL)
		outfile = stdout;
	if (errfile == NULL)
		errfile = stderr;

	exit_f(abs(strip_comments(infile, outfile, errfile)));
}

int strip_comments(FILE * fp, FILE * outfp, FILE * errfp)
{
	int ch;
	int lastch;
	int backslashed = 0;
	int status = NORMAL;

	for (lastch = -1; (ch = getc(fp)) != EOF; lastch = ch)
	{
		switch (status)
		{
			case NORMAL:		//正常
				if (ch == '/')
					status = CHECK_COMMENT;
				else if (ch == '"')
					status = IN_QUOTE;
				else if (ch == '\'')
					status = IN_CHOTE;
				else
					putc(ch, outfp);
				break;
			case IN_CHOTE:		//在單引號裡
				putc(ch, outfp);
				if (lastch == '\\')
					backslashed ^= 1;
				else
					backslashed = 0;
				if (ch == '\'' && !backslashed)
					status = NORMAL;
				break;
			case IN_QUOTE:		//在雙引號裡
				putc(ch, outfp);
				if (lastch == '\\')
					backslashed ^= 1;
				else
					backslashed = 0;
				if (ch == '"' && !backslashed)
					status = NORMAL;
				break;
			case CHECK_COMMENT:	//檢查是否為註譯
				if (ch == '/')
					status = IN_COMMENT1;
				else if (ch == '*')
					status = IN_COMMENT2;
				else
				{
					putc(lastch, outfp);
					putc(ch, outfp);
					status = NORMAL;
				}
				break;
			case IN_COMMENT1:	//註譯型式1://comment
				if (ch == '\n')
				{
					putc('\n', outfp);
					status = NORMAL;
				}
				break;
			case IN_COMMENT2:	//註譯型式2:/*comment*/
				if (lastch == '*' && ch == '/')
					status = NORMAL;
				break;
			default:
				fprintf(errfp, "wrong status!!\n");
				return -1;
		}
	}
	fflush(fp);
	return 0;
}
