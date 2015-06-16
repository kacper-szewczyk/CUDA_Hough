/*
 * laplace.h
 *
 *  Created on: 28 maj 2015
 *      Author: kszewcz2
 */

#ifndef LAPLACE_H_
#define LAPLACE_H_
#include "image.h"

__device__ int laplaceMaskOnSector(int *originalImage, int index, int width, int height);

__global__ void makeLaplaceMask(int *originalImage,
	 int *image, int n, int width, int height);

#endif
