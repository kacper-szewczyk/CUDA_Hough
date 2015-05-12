#include "file.h"
#include "hough.h"


int main(int argc, char ** argv)
{

	Image *image=readImageFromFile("image.pgm");
	Image *devImage;
	Image *devThresholdImage;
	cudaMalloc((void**)&devImage,sizeof(Image) );
	cudaMalloc((void**)&devThresholdImage,sizeof(Image) );
	cudaMemcpy(devImage,image,sizeof(Image),cudaMemcpyHostToDevice);
	cudaMemcpy(devThresholdImage,image,sizeof(Image),cudaMemcpyHostToDevice);
	thresholdImage<<<10,10>>>(devImage,devThresholdImage,10);
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
