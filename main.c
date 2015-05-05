#include "file.h"
#include "hough.h"


int main()
{
	int *image;
	int n;
	int m;
	image=read_from_file(image,"image.pgm",&n,&m);
	int *deviceImage;
	int *deviceThresholdedImage;
	int *deviceThreshold;
	int size=n*m;
	int *deviceSize;
	HANDLE_ERROR(cudaMalloc((void**)&deviceImage,size*sizeof(int) ) );
	HANDLE_ERROR(cudaMalloc((void**)&deviceThresholdedImage,size*sizeof(int) ) );
	HANDLE_ERROR(cudaMalloc((void**)&deviceThreshold,sizeof(int) ) );
	HANDLE_ERROR(cudaMalloc((void**)&deviceSize,sizeof(int) ) );
	HANDLE_ERROR(cudaMemcpy(deviceImage,
			image,n*m*sizeof(int),cudaMemcpyHostToDevice) );
	HANDLE_ERROR(cudaMemcpy(deviceSize,
			size,sizeof(int),cudaMemcpyHostToDevice) );

	return 0;
}
