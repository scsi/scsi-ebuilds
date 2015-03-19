#include <stdio.h>

int main(int argc, char**argv)
{
	FILE *fp;
	char oneLine[1000];
	char token[1000];
	char exe[100];
	char p1[1000];
	char p2[1000];
	int argc_ptr=1;
	p1[0]='\0';
	p2[0]='\0';
	if(argc<=1)
	{
		printf("Usage: %s command [parameter]\n",argv[0]);
		exit(1);
	}
	strcpy(exe,argv[argc_ptr]);
	argc_ptr++;
	while (argc_ptr<argc)
	{
		if(strcmp(argv[argc_ptr],"$")==0)
		{
			argc_ptr++;
			break;
		}
		strcat(p1," ");
		strcat(p1,argv[argc_ptr]);
		argc_ptr++;
	}

	while (argc_ptr<argc)
	{
		strcat(p2," ");
		strcat(p2,argv[argc_ptr]);
		argc_ptr++;
	}
	fp = stdin;

	while(fgets(oneLine, sizeof(oneLine), fp) != NULL)
	{
		while (strtoken(oneLine, " ", token)==0)
		{
			char command[2000];
			if(token[strlen(token)-1]=='\n') token[strlen(token)-1]='\0';
			sprintf(command,"%s %s %s %s\n",exe,p1,token,p2);
			printf("%s",command);
			system(command);
		}
	}
	exit(0);
}
