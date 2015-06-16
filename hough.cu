/*
 * hough.cu
 *
 *  Created on: 5 maj 2015
 *      Author: kszewcz2
 */
#include "hough.h"

__global__ void thresholdImage(Image *deviceThresholdedImage, int threshold, int n)
{
	int offset = threadIdx.x + blockIdx.x * blockDim.x;	
	/*	
	for(int i=offset;i<n; i+= blockDim.x * gridDim.x)
	{
		if(deviceThresholdedImage->array[i]>=threshold)
			deviceThresholdedImage->array[i] = 1;
		else
			deviceThresholdedImage->array[i] = 0;
		offset += blockDim.x * gridDim.x;
	}*/
	while(offset < n)	
	//for(int i=offset;i<n; i+= blockDim.x * gridDim.x)
	{
		if(deviceThresholdedImage->array[offset]>=threshold)
			deviceThresholdedImage->array[offset] = 1;
		else
			deviceThresholdedImage->array[offset] = 0;
		offset += blockDim.x * gridDim.x;
	}
	//deviceThresholdedImage->array[offset] = 5;
}

__global__ void createRoAndThetaArrays(double *ro, double *theta, double roStepSize, double thetaStepSize, double steps)
{
	int offset = threadIdx.x + blockIdx.x * blockDim.x;
	/*
	for(int i=offset; i<=steps; i+= blockDim.x * gridDim.x)
	{
		ro[i] = roStepSize * i;
		theta[i] = thetaStepSize * i;
		offset += blockDim.x * gridDim.x;
	}*/
	while(offset < steps)	
	{
		ro[offset] = roStepSize * offset;
		theta[offset] = thetaStepSize * offset;
		offset += blockDim.x * gridDim.x;
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
	int offset = threadIdx.x + blockIdx.x * blockDim.x;
	int * array=deviceThresholdedImage->array;
	double roIdeal;
	double roCandidate;
	int kRoClosest;	
	double difference=9999;
	int indexI,indexJ;
	int width = deviceThresholdedImage->width;
	while(offset < width*deviceThresholdedImage->height)
	{
		indexI = findMaxWidth(offset,width);
		indexJ = offset-indexI*width;
		if(array[offset] == 1)
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
						kRoClosest = k;
					}
				}
				A[kRoClosest*R+h]++;
				difference=9999;
			}
		}
 
		offset += blockDim.x * gridDim.x;

	}
}

__global__ void findLocalMaximas(int *A, int threshold, int *indexes, int size)
{
	int offset = threadIdx.x + blockIdx.x * blockDim.x;
	while(offset < size)
	{
		if(A[offset]>threshold)
		{
			indexes[offset]=1;
		}
		offset += blockDim.x * gridDim.x;
	}
}
