/***************************************************
  Program Name: Scsi system libary
  Purpose:
  Author: 陳勇洲 (Chen Yung Chou)
  Created Date: 2003/08/01
  Modified:
  Last Modify Date:   2004/08/31
  Version: 0.1.0
  Histtory:
***************************************************/
/**************** scsi增加以下程式碼(2004/03/10)*********************/
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <sys/msg.h>
/**************** scsi增加以上程式碼(2004/03/10)*********************/

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

int deamon_init(void)
{
	char currdir[1000];
	pid_t pid;
	getcwd(currdir,sizeof(currdir));
	if((pid=fork())<0)
	{
		return -1;
	}
	else if(pid !=0)
	{
		exit(0);	/*結束父處理程序*/
	}
	setsid();	/*成為階段作業領道者*/
	chdir(currdir);
	/*chdir("/");*/	/*改變工作路徑*/
	umask(0);	/*清除檔案模式建立遮罩*/
	return 0;
}

int main(int argc,char** argv)
{
	int i,j,c;
	char **arg;
	extern char *optarg;
	extern int optind, opterr, optopt;
	
	if(deamon_init()!=0)
	{
		fprintf(stderr,"ERROR: can not initial deamon.\n");
		exit(1);
	}
	
	while ((c = getopt(argc, argv, "hp:")) != -1)
	{
		switch (c) 
		{
			case 'h':
			{
				printf(" Usage: %s  [-p pidfile]\n",argv[0]);
				exit(0);
			}
			break;
			case 'p':
			{
				FILE *pidFile;
				if(strcmp(optarg,"-")==0)
				{
					pidFile=stdout;
				}
				else
				{
					pidFile=fopen(optarg,"w");
					if(pidFile==NULL)
					{
						fprintf(stderr, "can not open pid file %s for write.\n",optarg);
						exit(2);
					}
				}
				fprintf(pidFile,"%d",getpid());
				/*printf("pidfile=%s, %d\n",optarg,getpid());*/
				if( pidFile!=stdout) fclose(pidFile);
			}
			break;
			case ':':        /* -f or -o without arguments */
				fprintf(stderr, "Option -%c requires an argument\n",optopt);
				exit(3);
			break;
			case '?':
				fprintf(stderr, "Unrecognized option: - %c\n",optopt);
				exit(3);
			break;
			default:
				fprintf(stderr, "Undefine option: - %c\n",optopt);
				exit(3);
			break;
		}
	}
	arg=(char**)malloc(sizeof(char *)*(argc-optind));
	for(j=0;optind<argc;optind++,j++)
	{
		arg[j]=argv[optind];
		arg[j+1]=NULL;
		/*printf("%d %s %d\n",j,arg[j],strlen(arg[j]));*/
	}

	/*if (execlp(command,parameter,NULL) < 0)*/
	/*printf("%d %s %s\n",getpid(),arg[0],arg);*/
	j=execvp(arg[0],arg);
	if (j < 0)
	{
		fprintf(stderr,"ERROR: can not execute %s\n",arg[0]);
		exit(2);
	}
}
