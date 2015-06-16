#include "file.h"
#include "hough.h"
#include "laplace.h"

int main(int argc, char ** argv)
{
<<<<<<< HEAD
	char inputFile[] = { "mountain.pgm" };
	char resultFile[] = { "Houghed.pgm" };
	Image *image=readImageFromFile(inputFile);
	int *devImage;
	int *devTresholded;
	int blocks = image->getWidth();
	int threads = image->getHeight();
	int size=image->getHeight()*image->getWidth();
	size_t imageSize = (size+3) * sizeof(int);
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
	//saveImageToFile(result,resultFile);
	/*
	int n=1000;
=======

	Image *image=readImageFromFile("mountain.pgm");
	for(int i=0;i<10;i++)
	{
		for(int j=0;j<10;j++)
		{
			image->getArray()[i];
		}
	}
	/*int n=1000;
>>>>>>> ec5918de9505894795af882336c67e797ff38e0d
	char inputFile[] = { "mountain.pgm" };
	char outputFile[] = { "treshold.pgm" };
	char resultFile[] = { "Houghed.pgm" };
	Image *image=readImageFromFile(inputFile);
<<<<<<< HEAD
	/*char testFile[] = { "test.pgm" };
=======
	char testFile[] = { "test.pgm" };
>>>>>>> ec5918de9505894795af882336c67e797ff38e0d
	saveImageToFileTest(testFile);
	Image *devImage;
	Image *devThresholdImage;
	int blocks = image->getWidth();
	int threads = image->getHeight(); // height of the image is max 480
	Image *result = new Image(image->getWidth(),image->getHeight(),image->getScale());
	/*
	double *ro;
	double *theta;
	size_t steps = n*sizeof(int);
	int *A;
	int size=image->getHeight()*image->getWidth();
	size_t size2 = size*sizeof(int);
	int *indexes;
	int *indexesHost = new int[size];
	int *deviceImage;
	cudaMalloc((void**)&devImage,sizeof(Image) );
	cudaMalloc((void**)&deviceImage,size2 );
	cudaMalloc((void**)&indexes,size2);
	cudaMalloc((void**)&devThresholdImage,sizeof(Image) );
	cudaMalloc((void**)&A,size2 );
	cudaMalloc((void**)&ro,sizeof(double)* steps);
	cudaMalloc((void**)&theta,sizeof(double)* steps);
	cudaMemcpy(devImage,image,sizeof(Image),cudaMemcpyHostToDevice);
	cudaMemcpy(devThresholdImage,result,sizeof(Image),cudaMemcpyHostToDevice);
	printf("End of allocation\n");
<<<<<<< HEAD
	//makeLaplaceMask<<<blocks,threads>>>(devImage,
	// devThresholdImage, size);
	thresholdImage<<<blocks,threads>>>(deviceImage,devThresholdImage->getScale()/2,size);
	int *imageTres = new int[size];
	cudaMemcpy(imageTres,devThresholdImage,sizeof(Image), cudaMemcpyDeviceToHost);
=======
	makeLaplaceMask<<<blocks,threads>>>(devImage,devThresholdImage, size);
	thresholdImage<<<blocks,threads>>>(devThresholdImage,devThresholdImage->getScale()/2,size);
	cudaMemcpy(result,devThresholdImage,sizeof(Image), cudaMemcpyDeviceToHost);
	cudaMemcpy(B,deviceImage,size2, cudaMemcpyDeviceToHost);
>>>>>>> ec5918de9505894795af882336c67e797ff38e0d
	for(int i=0;i<size;i++)
	{
		printf("%d ",imageTres[i]);
	}
	/*cudaMemcpy(B,deviceImage,size2, cudaMemcpyDeviceToHost);
	for(int i=0;i<size;i++)
	{
		printf("%i ",B[i]);
	}houghTransform<<<blocks,threads>>>(devThresholdImage,
	 ro, theta, A, steps, steps);
	printf("After treshold\n");
    saveImageToFile(result,outputFile);
	double roMax = sqrt(image->getHeight()*image->getHeight() + 
	image->getWidth()*image->getWidth());
	createRoAndThetaArrays<<<blocks,threads>>>(ro, theta, roMax/steps, 3.14/steps, steps);
	printf("After Ro theta arrays\n");
	houghTransform<<<blocks,threads>>>(devThresholdImage,
	 ro, theta, A, steps, steps);
	printf("Hough\n");
	findLocalMaximas<<<blocks,threads>>>(A, 5, indexes, size);
	printf("Local Maximas\n");
	//cudaMemcpy(result,devImage,sizeof(Image), cudaMemcpyDeviceToHost);
	cudaMemcpy(indexesHost,indexes,sizeof(int)
		*image->getHeight()*image->getWidth(),
		cudaMemcpyDeviceToHost);
	result->setArray(indexesHost);
	printf("After set array\n");
	saveImageToFile(result,resultFile);
	cudaFree(theta);
	cudaFree(ro);
	cudaFree(A);
	cudaFree(devImage);
	cudaFree(deviceImage);
	cudaFree(indexes);
	cudaFree(devThresholdImage);
	free(image);
	free(result);
<<<<<<< HEAD
	//free(B);*/
=======
	free(B);*/
>>>>>>> ec5918de9505894795af882336c67e797ff38e0d
	return 0;
}
