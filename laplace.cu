/*
 * laplace.cu
 *
 *  Created on: 28 maj 2015
 *      Author: kszewcz2
 */

#include "laplace.h"

__device__ int laplaceMaskOnSector(int *originalImage, int index, int width, int height)
{
	int sum = 0;
	if(index>0)
	{
		sum += (double)4*originalImage[index-1];
	}
	if(index<width*height)
	{
		sum += (double)4*originalImage[index+1];
	}
	if(index>=width)
	{
		sum += (double)4*originalImage[index-width];
		sum += (double)1*originalImage[index-width+1];
	}
	if(index>=width+1)
	{
		sum += (double)1*originalImage[index-width-1];
	}
	if(index<=width*(height-1))
	{
		sum += (double)4*originalImage[index+width];
		sum += (double)1*originalImage[index+width-1];
	}
	if(index<=width*(height-1)-1)
	{
		sum += (double)1*originalImage[index+width+1];
	}
	return sum/6;
}

__global__ void makeLaplaceMask(int *originalImage,
	 int *image, int n, int width, int height)
{
	int offset = threadIdx.x + blockIdx.x * blockDim.x;

	if( offset <n )
	{
		image[offset] = laplaceMaskOnSector(originalImage, offset, width, height);
		offset = threadIdx.x + blockIdx.x * blockDim.x;
	}
	//__syncthreads();
}
