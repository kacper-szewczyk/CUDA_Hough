#include "file.h"
#include "hough.h"


int main(int argc, char ** argv)
{

	Image *image=readImageFromFile("image.pgm");
	saveImageToFileTest("test.pgm");
	printf("%i %i", image->getWidth(),image->getHeight());
	Image *devImage;
	Image *devThresholdImage;
	Image *result = new Image();
	double *ro;
	double *theta;
	double steps = 1000;
	int *A;
	int *indexes;
	int *indexesHost;
	int size=image->getHeight()*image->getWidth();
	cudaMalloc((void**)&devImage,sizeof(Image) );
	cudaMalloc((void**)&indexes,sizeof(int)*size);
	cudaMalloc((void**)&devThresholdImage,sizeof(Image) );
	cudaMalloc((void**)&A,sizeof(int) );
	cudaMalloc((void**)&ro,sizeof(double)* steps);
	cudaMalloc((void**)&theta,sizeof(double)* steps);
	cudaMemcpy(devImage,image,sizeof(Image),cudaMemcpyHostToDevice);
	cudaMemcpy(devThresholdImage,image,sizeof(Image),cudaMemcpyHostToDevice);
	printf("End of allocation\n");
	thresholdImage<<<10,10>>>(devImage,devThresholdImage,10);
	printf("After treshold\n");
	createRoAndThetaArrays<<<10,10>>>(ro, theta, 3.14/steps, 3.14/steps, steps);
	printf("After Ro theta arrays\n");
	houghTransform<<<10,10>>>(devThresholdImage,
	 ro, theta, A, 100, 100);
	printf("Hough\n");
	findLocalMaximas<<<10,10>>>(A, 5, indexes);
	printf("Local Maximas\n");
	cudaMemcpy(result,devImage,sizeof(Image), cudaMemcpyDeviceToHost);
	cudaMemcpy(indexesHost,indexes,sizeof(int)
		*image->getHeight()*image->getWidth(),
		cudaMemcpyDeviceToHost);
	result->setArray(indexesHost);
	printf("After set array\n");
	saveImageToFile(result,"Houghed.pgm");
	return 0;
}
