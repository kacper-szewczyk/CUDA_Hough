/*
 * file.cu
 *
 *  Created on: 28 kwi 2015
 *      Author: kszewcz2 mblach
 */
#include "file.h"
Image *readImageFromFile( char* filename){


	int width=0;
	int height=0;
	int scale=0;
	char line[80];
	char buffer;
	FILE *file;
	file = fopen (filename, "rt");  /* open the file for reading */
	fgets(line, 80, file);	// "P2" line
	fgets(line, 80, file);	// "#" comment line
	while(buffer=fgetc(file))
	{
		if( buffer >=48 && buffer <=57)
			width=width*10+buffer-48;
		else
			if(width!=0) break;
	}
	buffer = 0;
	while(buffer=fgetc(file))
	{
		if( buffer >=48 && buffer <=57)
			height=height*10+buffer-48;
		else
			if(height!=0) break;
	}
	buffer = 0;
	while(buffer=fgetc(file))
	{
		if( buffer >=48 && buffer <=57)
			scale=scale*10+buffer-48;
		else
			if(scale!=0) break;
	}
	int *array = new int[height*width];
	int i=0;
	int number=0;
	while((buffer=fgetc(file)) != EOF)
	{
		if( buffer >=48 && buffer <=57)
		{
			array[i]=array[i]*10+buffer-48;
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
	Image * image = new Image();
	image->setWidth(width);
	image->setHeight(height);
	image->setArray(array);
	image->setScale(scale);
	return image;
}

void saveImageToFile(Image *result,char* filename)
{
	FILE *file;
	file = fopen (filename, "w");  /* open the file for reading */
	fprintf(file,"P2\n");
	fprintf(file,"# %s\n",filename);
	fprintf(file,"%i",result->getWidth());
	fprintf(file," %i\n",result->getHeight());
	fprintf(file,"%i\n",result->getScale());
	int* array = result->getArray();
	int width = result->getWidth();
	for(int i=0;i<result->getHeight();i++)
	{
		for(int j=0;j<width;j++)
		{
			fprintf(file,"%i ",array[i*width+j]);
		}
		fprintf(file,"\n");
	}
	fclose(file);
}

void saveImageToFileTest(char* filename)
{
	FILE *file;
	file = fopen (filename, "w");  /* open the file for reading */
	fprintf(file,"P2\n");
	fprintf(file,"# result of Hough transform\n");
	fprintf(file,"Test\n");
	
	fclose(file);
}
