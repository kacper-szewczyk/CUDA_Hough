/*
 * file.h
 *
 *  Created on: 28 kwi 2015
 *      Author: kszewcz2
 */

#ifndef FILE_H_
#define FILE_H_
#include <stdio.h>
#include "image.h"

Image *readImageFromFile( char* filename);
//int* read_from_file(int* image, char* filename, int *n, int *m);

void saveImageToFile(Image *result,char* filename);


#endif /* FILE_H_ */
