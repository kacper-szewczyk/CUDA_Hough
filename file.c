/*
 * file.c
 *
 *  Created on: 28 kwi 2015
 *      Author: kszewcz2
 */
#include "file.h"

int* read_from_file(int* image, char* filename, int *n, int *m)
{
	*n=0;
	*m=0;
	int scale=0;
	char line[80];
	char buffer;
	FILE *file;
	file = fopen (filename, "rt");  /* open the file for reading */
	   /* elapsed.dta is the name of the file */
	   /* "rt" means open the file for reading text */
	fgets(line, 80, file);	// "P2" line
	fgets(line, 80, file);	// "#" comment line
	//fgets(line, 80, file);
	while(buffer=fgetc(file))
	{
		if( buffer >=48 && buffer <=57)
			*n=*n*10+buffer-48;
		else
			if(*n!=0) break;
	}
	buffer = 0;
	while(buffer=fgetc(file))
	{
		if( buffer >=48 && buffer <=57)
			*m=*m*10+buffer-48;
		else
			if(*m!=0) break;
	}
	buffer = 0;
	while(buffer=fgetc(file))
	{
		if( buffer >=48 && buffer <=57)
			scale=scale*10+buffer-48;
		else
			if(scale!=0) break;
	}
	image=malloc((*m)*(*n)*sizeof(int));
	int i=0;
	int number=0;
	while((buffer=fgetc(file)) != EOF)
	{
		if( buffer >=48 && buffer <=57)
		{
			image[i]=image[i]*10+buffer-48;
			number=1;
		}
		else
			if(number==1)
			{
				i++;
				number=0;
			}
	}
	fclose(file);
	return image;
}
