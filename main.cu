#include "file.h"
#include "hough.h"
#include "laplace.h"

int main(int argc, char ** argv)
{
	int n=1000;
	char inputFile[] = { "image.pgm" };
	char outputFile[] = { "treshold.pgm" };
	char resultFile[] = { "Houghed.pgm" };
	Image *image=readImageFromFile(inputFile);
	/*char testFile[] = { "test.pgm" };
	saveImageToFileTest(testFile);*/
	Image *devImage;
	Image *devThresholdImage;
	Image *result = new Image(image->getWidth(),image->getHeight(),image->getScale());
	double *ro;
	double *theta;
	size_t steps = n*sizeof(int);
	int *A;
	int size=image->getHeight()*image->getWidth();
	size_t size2 = size*sizeof(int);
	int *indexes;
	int *indexesHost;
	int *deviceImage;
	int *B = new int[size];
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
	makeLaplaceMask<<<24,7>>>(devImage,
	 devThresholdImage, size);
	//thresholdImage<<<24,7>>>(devThresholdImage,devThresholdImage->getScale()/2,size);
	cudaMemcpy(result,devThresholdImage,sizeof(Image), cudaMemcpyDeviceToHost);
	cudaMemcpy(B,deviceImage,size2, cudaMemcpyDeviceToHost);
	for(int i=0;i<size;i++)
	{
		printf("%i ",B[i]);
	}
	printf("After treshold\n");
    saveImageToFile(result,outputFile);
	double roMax = sqrt(image->getHeight()*image->getHeight() + 
	image->getWidth()*image->getWidth());
	createRoAndThetaArrays<<<24,7>>>(ro, theta, roMax/steps, 3.14/steps, steps);
	printf("After Ro theta arrays\n");
	houghTransform<<<24,7>>>(devThresholdImage,
	 ro, theta, A, steps, steps);
	printf("Hough\n");
	findLocalMaximas<<<24,7>>>(A, 5, indexes);
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
	free(B);
	return 0;
}
