/*
 * hough.c
 *
 *  Created on: 5 maj 2015
 *      Author: kszewcz2
 */
#include "hough.h"

__global__ void thresholdImage(Image *deviceImage,Image *deviceThresholdedImage, int threshold)
{
	int x = threadIdx.x + blockIdx.x * blockDim.x;
	int y = threadIdx.y + blockIdx.y * blockDim.y;
	int offset = x + y * blockDim.x * gridDim.x;
	int * array=deviceImage->getArray();
	for(int i=offset;i<deviceImage->getWidth()*deviceImage->getHeight();i+= blockDim.x * gridDim.x){
		
		if(array[i]>=threshold)
			array[i] = 1;
		else
			array[i] = 0;
		offset += blockDim.x * gridDim.x;

	}
	
}
