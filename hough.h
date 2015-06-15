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

__global__ void thresholdImage(Image *deviceThresholdedImage, int threshold, int width, int height, int *image);

__global__ void createRoAndThetaArrays(double *ro, double *theta,  double roStepSize, double thetaStepSize, double steps);

__device__ int findMaxWidth(int i, int width);

__global__ void houghTransform(Image *deviceThresholdedImage,
	double *ro, double *theta, int *A, int R, int T); 

__global__ void findLocalMaximas(int *A, int threshold, int *indexes);
//pMax = sqrt(n^2+m^2); n-height, m-width of the image
#endif /* HOUGH_H_ */
