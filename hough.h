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
__global__ void thresholdImage(Image *deviceImage,Image *deviceThresholdedImage, int threshold);

#endif /* HOUGH_H_ */
