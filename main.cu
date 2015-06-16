#include "file.h"
#include "hough.h"
#include "laplace.h"

int main(int argc, char ** argv)
{
	char inputFile[] = { "mountain.pgm" };
	char resultFile[] = { "Houghed.pgm" };
	Image *image=readImageFromFile(inputFile);
	int *devImage;
	int *devTresholded;
	int blocks = image->getWidth();
	int threads = image->getHeight();
	int size=image->getHeight()*image->getWidth();
	//size_t imageSize = (size+3) * sizeof(int);
	cudaMalloc((void**)&devImage,size*sizeof(int) );
	cudaMemcpy(devImage,image->getArray(),size*sizeof(int),cudaMemcpyHostToDevice);
	cudaMalloc((void**)&devTresholded,size*sizeof(int) );
	cudaMemcpy(devTresholded,image->getArray(),size*sizeof(int),cudaMemcpyHostToDevice);
	thresholdImage<<<blocks,threads>>>(devTresholded,image->getScale()/2,size);
	makeLaplaceMask<<<blocks,threads>>>(devTresholded, 
		devImage, size, image->getWidth(),image->getHeight());
	int n = 1000;
	float *ro;
	float *theta;
	float roStepSize = sqrt(image->getWidth()+image->getHeight())/n;
	float thetaStepSize = 3.14/n;
	cudaMalloc((void**)&ro,sizeof(float)* n);
	cudaMalloc((void**)&theta,sizeof(float)* n);
	createRoAndThetaArrays<<<blocks,threads>>>(ro, theta, 
		roStepSize, thetaStepSize, n);
	int *imageTres = new int[size];
	cudaMemcpy(imageTres,devImage,size*sizeof(int), cudaMemcpyDeviceToHost);
	for(int i=0;i<size;i++)
	{
		//printf("%d ",imageTres[i]);
	}
	int *A;
	cudaMalloc((void**)&A,sizeof(int)*size );
	houghTransform<<<blocks,threads>>>(imageTres, ro, theta, 
		A, n, n, image->getWidth(),image->getHeight());
	int *index;
	cudaMalloc((void**)&index,sizeof(int)*size );
	findLocalMaximas<<<blocks,threads>>>(A, 3, index, size);
	int *result = new int[size];
	cudaMemcpy(result,index,size*sizeof(int), cudaMemcpyDeviceToHost);
	
	for(int i=0;i<size;i++)
	{
		//printf("%d ",result[i]);
	}
	image->setArray(result);
	saveImageToFile(image,resultFile);
	
	return 0;
}
