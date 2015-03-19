/***************************************************
  Program Name: dumphux
  Purpose: dump hex code
  Author: ³¯«i¬w (Chen Yung Chou)
  Created Date: 2005/01/23
  Modified: ³¯«i¬w (Chen Yung Chou)
  Last Modify Date:   2005/01/23
  Histtory:
***************************************************/
#include <stdio.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef Linux
#include <getopt.h>
#endif

/* Flag set by --verbose. */

void eabort(int i)
{
	//if(infile!=stdin&&stdin!=NULL) fclose(infile);
	//if(outfile!=stdout&&stdout!=NULL) fclose(outfile);
	exit(i);
}
void showhelp(char* mainpgm)
{
	fprintf(stderr,"Usage: %s [-o outfile] [-c count*10 of line] [ -s start pos] [-e end pos] [infile]\n",mainpgm);
}
int main (int argc,char ** argv)
{
	extern char *optarg;
	extern int optind, opterr, optopt;
	int c;
	char * endptr;
	
	FILE *infile;
	FILE *outfile;
	int upcase_flag=0;
	int line=-1;
	long start=-1;
	long end=-1;

	infile=NULL;
	outfile=NULL;
	while ((c = getopt(argc, argv, "o:c:s:e:hu")) != -1)
	{
		switch (c)
		{
			case 'o': //out put file
				/*printf ("option -o with value `%s'\n", optarg);*/
				if(outfile!=NULL)
				{
					showhelp(argv[0]);
					exit(3);
				}
				else if(strcmp(optarg,"-")==0)
				{
					outfile=stdout;
				}
				else
				{
					outfile=fopen(optarg,"w");
					if(outfile==NULL)
					{
						fprintf(stderr,"ouput file %s open error.\n",optarg);
						eabort(2);
					}
				}
				break;
			case 'c':
				line=strtol(optarg,&endptr,10);
				if(*endptr!='\0')
				{
					fprintf(stderr,"line parameter %s is invalid.\n",optarg);
					eabort(1);
				}
				break;
			case 's':
				start=strtol(optarg,&endptr,10);
				if(*endptr!=0)
				{
					fprintf(stderr,"start parameter %s is invalid.\n",optarg);
					eabort(1);
				}
			  break;
			case 'e':
				end=strtol(optarg,&endptr,10);
				if(*endptr!=0)
				{
					fprintf(stderr,"end parameter %s is invalid.\n",optarg);
					eabort(1);
				}
				break;
			case 'u':
				if(upcase_flag ==0) upcase_flag=1;
				else
				{
					showhelp(argv[0]);
					exit(0);
				}
			break;
		  	case 'h':
				showhelp(argv[0]);
				exit(0);
			break;
		
			case ':':        /* -f or -o without arguments */
				fprintf(stderr, "Option -%c requires an argument\n",optopt);
				showhelp(argv[0]);
				exit(3);
			break;
			case '?':
				fprintf(stderr, "Unrecognized option: - %c\n",optopt);
				showhelp(argv[0]);
				exit(3);
			break;
			default:
				fprintf(stderr, "Undefine option: - %c\n",optopt);
				showhelp(argv[0]);
				exit(3);
			break;
		}
	}
	for ( ; optind < argc; optind++)
	{
		if(infile==NULL)
		{
						//fprintf(stderr,"in file %s\n",argv[optind]);
			if ( (infile = fopen(argv[optind], "r+b")) == NULL)
			{
				fprintf(stderr,"ERROR : opening input file %s failed.\n", argv[optind]) ;
				exit(2) ;
			}
		}
		else
		{
			showhelp(argv[0]);
			exit(1);
		}
	}
	
	if(infile==NULL) infile=stdin;
	if(outfile==NULL) outfile=stdout;
	if(line==-1) line=1;
/*	
	if(end==-1)
	{
		fseek(infile,0L,SEEK_END);
		end=ftell(infile);
		fseek(infile,0L,SEEK_SET);
	}
*/
	if(start==-1) start=0;
	else fseek(infile,start/(line*10)*(line*10),SEEK_SET);

	{
		int ch;
		int pos=-1;
		int current_range;
		for(ch=fgetc(infile),pos++;feof(infile)==0&&(pos<=end||end==-1);ch=fgetc(infile),pos++)
		{
			if(pos%(line*10)==0) 
			{
				current_range=pos+(line*10);
				if(current_range>start)fprintf(outfile,"\n%6d: ",pos);
			}
			else if((pos%10==0)&&current_range>start) fprintf(outfile,"|");
			else fprintf(outfile," ");
			if(pos<start) fprintf(outfile,"__");
			else
			{
				if (upcase_flag) fprintf(outfile,"%02X",ch);
				else fprintf(outfile,"%02x",ch);
			}
		}
		fprintf(outfile,"\n");
	}
	eabort(0);	
}
void byte_draw(char *param)
{
	int startpos, endpos;
	int ch,cn;
		
}
