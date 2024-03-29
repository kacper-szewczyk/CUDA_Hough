CC=nvcc
CFLAGS=
LFLAGS=
OBJS=main.o file.o hough.o image.o laplace.o

cudaHough: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o cudaHough

main.o: main.cu
	$(CC) $(CFLAGS) -c main.cu -o main.o

laplace.o: laplace.cu
	$(CC) $(CFLAGS) -c laplace.cu -o laplace.o

file.o: file.cu
	$(CC) $(CFLAGS) -c file.cu -o file.o

hough.o: hough.cu
	$(CC) $(CFLAGS) -c hough.cu -o hough.o

image.o: image.cu
	$(CC) $(CFLAGS) -c image.cu -o image.o

clean:
	rm -f *.o 
	rm -f cudaHough
	rm -f *~
