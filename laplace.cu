/*
 * laplace.cu
 *
 *  Created on: 28 maj 2015
 *      Author: kszewcz2
 */

#include "laplace.h"

__device__ double laplaceMaskOnSector(Image *originalImage, int index, int width, int height)
{
	double sum = 0;
	if(index>0)
	{
		sum += (double)4*originalImage->array[index-1];
	}
	if(index<width*height)
	{
		sum += (double)4*originalImage->array[index+1];
	}
	if(index>=width)
	{
		sum += (double)4*originalImage->array[index-width];
		sum += (double)1*originalImage->array[index-width+1];
	}
	if(index>=width+1)
	{
		sum += (double)1*originalImage->array[index-width-1];
	}
	if(index<=width*(height-1))
	{
		sum += (double)4*originalImage->array[index+width];
		sum += (double)1*originalImage->array[index+width-1];
	}
	if(index<=width*(height-1)-1)
	{
		sum += (double)1*originalImage->array[index+width+1];
	}
	return sum/6;
}

__global__ void makeLaplaceMask(Image *originalImage,
	 Image *image, int n)
{
	int offset = threadIdx.x + blockIdx.x * blockDim.x;
	int width = originalImage->width;
	int height = originalImage->height;
	for(int i=offset;i<n;i+=blockIdx.x * blockDim.x)
	{
		
		image->array[i] = (int)laplaceMaskOnSector(originalImage, i, width, height);
	}
	//__syncthreads();
}
