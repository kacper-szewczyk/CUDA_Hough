/*
 * hough.h
 *
 *  Created on: 5 maj 2015
 *      Author: kszewcz2
 */

#ifndef HOUGH_H_
#define HOUGH_H_

__global__ void threshold(int *deviceImage,
		int *deviceThresholdedImage, int *threshold, int *size);

#endif /* HOUGH_H_ */
