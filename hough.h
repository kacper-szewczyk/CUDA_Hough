/*
 * hough.h
 *
 *  Created on: 5 maj 2015
 *      Author: kszewcz2
 */

#ifndef HOUGH_H_
#define HOUGH_H_
#include <iostream>
#include "image.h"

__global__ void thresholdImage(int *deviceThresholdedImage, int threshold, int n);

__global__ void createRoAndThetaArrays(float *ro, float *theta,  float roStepSize, float thetaStepSize, int steps);

__device__ int findMaxWidth(int i, int width);

__global__ void houghTransform(int *deviceThresholdedImage,
	float *ro, float *theta, int *A, int R, int T, int width, int height); 

__global__ void findLocalMaximas(int *A, int threshold, int *indexes, int size);
//R = sqrt(n^2+m^2); n-height, m-width of the image
#endif /* HOUGH_H_ */
