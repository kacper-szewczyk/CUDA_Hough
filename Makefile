CC=nvcc
CFLAGS=
LFLAGS=
OBJS=main.o file.o hough.o

cudaHough: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o cudaHough

main.o: main.cu
	$(CC) $(CFLAGS) -c main.cu -o main.o

file.o: file.cu
	$(CC) $(CFLAGS) -c file.cu -o file.o

hough.o: hough.cu
	$(CC) $(CFLAGS) -c hough.cu -o hough.o
