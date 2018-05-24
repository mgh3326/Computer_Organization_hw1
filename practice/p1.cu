
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#define N 1000	//  number of threads per block

#define T 1// number of block


__global__ void add(int a, int b, int *c) {
	*c = a + b;
}
int main(int argc, char **argv) {

	int a, b, c;
	int *dev_c;
	a = 3;
	b = 4;
	cudaMalloc((void**)&dev_c, sizeof(int));
	add << <1, 1 >> > (a, b, dev_c);
	cudaMemcpy(&c, dev_c, sizeof(int),
		cudaMemcpyDeviceToHost);
	printf("%d + %d is %d\n", a, b, c);
	cudaFree(dev_c);
	return 0;
}


// Helper function for using CUDA to add vectors in parallel.

