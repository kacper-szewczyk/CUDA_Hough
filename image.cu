#include "image.h"

Image::Image()
{
}

Image::Image(int width, int height, int scale)
{
	this->width = width;
	this->height = height;
	this->scale = scale;
	this->array = new int[width*height];
	for(int i = 0; i < width*height;i++)
	{
		this->array[i]=0;
	}
}

