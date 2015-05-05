/*
 * hough.c
 *
 *  Created on: 5 maj 2015
 *      Author: kszewcz2
 */
#include "hough.h"

__global__ void thresholdImage(int *deviceImage,
		int *deviceThresholdedImage, int *threshold, int *size)
{
	int x = threadIdx.x + blockIdx.x * blockDim.x;
	int y = threadIdx.y + blockIdx.y * blockDim.y;
	int offset = x + y * blockDim.x * gridDim.x;
	while(offset < (*size))
	{
		if(deviceImage[offset]>=(*threshold))
			deviceThresholdedImage[offset] = 1;
		else
			deviceThresholdedImage[offset] = 0;
		offset += blockDim.x * gridDim.x;
	}
}
