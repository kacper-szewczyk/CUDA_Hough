/*
 * hough.cu
 *
 *  Created on: 5 maj 2015
 *      Author: kszewcz2
 */
#include "hough.h"

__global__ void thresholdImage(Image *deviceThresholdedImage, int threshold, int width, int height, int *image)
{
	int x = threadIdx.x + blockIdx.x * blockDim.x;
	int y = threadIdx.y + blockIdx.y * blockDim.y;
	int offset = x + y * blockDim.x * gridDim.x;
	image[offset] = 10;
	for(int i=offset;i<(width*height); i+= blockDim.x * gridDim.x)
	{
		image[i] = 5;
		if(deviceThresholdedImage->array[i]>=threshold)
			deviceThresholdedImage->array[i] = 1;
		else
			deviceThresholdedImage->array[i] = 0;
		//offset += blockDim.x * gridDim.x;
	}
	deviceThresholdedImage->array[offset] = 5;
}

__global__ void createRoAndThetaArrays(double *ro, double *theta, double roStepSize, double thetaStepSize, double steps)
{
	int x = threadIdx.x + blockIdx.x * blockDim.x;
	int y = threadIdx.y + blockIdx.y * blockDim.y;
	int offset = x + y * blockDim.x * gridDim.x;
	for(int i=offset; i<=steps; i+= blockDim.x * gridDim.x)
	{
		ro[i] = roStepSize * offset;
		theta[i] = thetaStepSize * offset;
		//offset += blockDim.x * gridDim.x;
	}
}

__device__ int findMaxWidth(int i, int width)
{
	int result = 0;
	int summed = 0;
	while(summed <= i)
	{
		summed += width;
		result++;
	}
	if(summed > i)
	{
		result--;
	}
	return result;
}

__global__ void houghTransform(Image *deviceThresholdedImage,
	 double *ro, double *theta, int *A, int R, int T)
{
	int x = threadIdx.x + blockIdx.x * blockDim.x;
	int y = threadIdx.y + blockIdx.y * blockDim.y;
	int offset = x + y * blockDim.x * gridDim.x;
	int * array=deviceThresholdedImage->array;
	double roIdeal;
	double roCandidate;
	double roClosest;	
	double difference=9999;
	int indexI,indexJ;
	int width = deviceThresholdedImage->width;
	for(int i=offset;i<width
		*deviceThresholdedImage->height;
		i+= blockDim.x * gridDim.x)
	{
		indexI = findMaxWidth(i,width);
		indexJ = i-indexI*width;
		if(array[i] == 1)
		{
			for(int h=0;h<T;h++)
			{
				roIdeal = indexI*sin(theta[h])+indexJ*cos(theta[h]);
				for(int k=0;k<R;k++)
				{
					roCandidate = abs(roIdeal - ro[k]); 
					if(roCandidate<difference)
					{
						difference = roCandidate;
						roClosest = ro[k];
						A[k*R+h]++;
					}
				}
				difference=9999;
			}
		}
 
		offset += blockDim.x * gridDim.x;

	}
}

__global__ void findLocalMaximas(int *A, int threshold, int *indexes)
{
	int x = threadIdx.x + blockIdx.x * blockDim.x;
	int y = threadIdx.y + blockIdx.y * blockDim.y;
	int offset = x + y * blockDim.x * gridDim.x;
	for(int i=offset;i<sizeof(A);i+= blockDim.x * gridDim.x)
	{
		if(A[i]>threshold)
		{
			indexes[i]=1;
		}
	}
}
