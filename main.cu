#include "file.h"
#include "hough.h"


int main(int argc, char ** argv)
{

	Image *image=readImageFromFile("image.pgm");
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
	thresholdImage<<<10,10>>>(devImage,devThresholdImage,10);
	createRoAndThetaArrays<<<10,10>>>(ro, theta, 3.14/steps, 3.14/steps, steps);
	houghTransform<<<10,10>>>(devThresholdImage,
	 ro, theta, A, 100, 100);
	findLocalMaximas<<<10,10>>>(A, 5, indexes);
	cudaMemcpy(result,devThresholdImage,sizeof(Image),cudaMemcpyDeviceToHost);
	cudaMemcpy(indexesHost,indexes,sizeof(int)
		*image->getHeight()*image->getWidth(),
		cudaMemcpyDeviceToHost);
	result->setArray(indexesHost);
	saveImageToFile(result,"Houghed.pgm");
	//houghTransform<<<10,10>>>(devThresholdImage, ro, theta, int *A, int R, int T)
/*
	int *deviceImage;
	int *deviceThresholdedImage;
        int *thresholdedImage;
	int threshold=10;
	int *deviceThreshold;
	int size=n*m;
	int *deviceSize;
	cudaMalloc((void**)&deviceImage,
		size*sizeof(int) );
	cudaMalloc((void**)&deviceThresholdedImage,
		size*sizeof(int) );
	cudaMalloc((void**)&deviceThreshold,sizeof(int) );
	cudaMalloc((void**)&deviceSize,sizeof(int) );
	cudaMemcpy(deviceImage,
		image,size*sizeof(int),
		cudaMemcpyHostToDevice);
	cudaMemcpy(deviceSize,
		(const void*)&size,sizeof(int),
		cudaMemcpyHostToDevice);
	cudaMemcpy(deviceThreshold,
                (const void*)&threshold,sizeof(int),
                cudaMemcpyHostToDevice);
	thresholdImage<<n,m>>(deviceImage,
		deviceThresholdedImage,
		deviceThreshold,deviceSize);
	cudaMemcpy(thresholdedImage,
		deviceThresholdedImage,
		size*sizeof(int),
		cudaMemcpyDeviceToHost);
	int i;
	for(i=0;i<size;i++)
	{
		printf("%d ",thresholdedImage[i]);
	}	*/
	return 0;
}
