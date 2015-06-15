#include "file.h"
#include "hough.h"
#include "laplace.h"

int main(int argc, char ** argv)
{
	int n=1000;
	char inputFile[] = { "image.pgm" };
	char outputFile[] = { "treshold.pgm" };
	Image *image=readImageFromFile(inputFile);
	char testFile[] = { "test.pgm" };
	saveImageToFileTest(testFile);
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
	cudaMemcpy(devThresholdImage,image,sizeof(Image),cudaMemcpyHostToDevice);
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
	/*createRoAndThetaArrays<<<10,10>>>(ro, theta, 3.14/steps, 3.14/steps, steps);
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
	saveImageToFile(result,"Houghed.pgm");*/
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
