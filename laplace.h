/*
 * laplace.h
 *
 *  Created on: 28 maj 2015
 *      Author: kszewcz2
 */

#ifndef LAPLACE_H_
#define LAPLACE_H_
#include "image.h"

__device__ double laplaceMaskOnSector(Image *originalImage, int index, int width, int height);

__global__ void makeLaplaceMask(Image *originalImage, Image *image, int n);

#endif
