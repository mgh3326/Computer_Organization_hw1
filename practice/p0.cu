
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#define N 1000	//  number of threads per block

#define T 10000// number of block


__global__ void vecAdd(int *A, int *B, int *C) {
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	C[i] = A[i] * 10 + B[i];
}
int main(int argc, char **argv) {

	int size = N * T * sizeof(int);
	int *devA, *devB, *devC;
	int  *a, *b, *c;

	a = (int*)malloc(size);
	b = (int*)malloc(size);
	c = (int*)malloc(size);
	cudaMalloc((void**)&devA, size);
	cudaMalloc((void**)&devB, size);
	cudaMalloc((void**)&devC, size);
	for (int i = 0; i < N*T; i++) {
		a[i] = i;
		b[i] = 1;
	}
	cudaMemcpy(devA, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(devB, b, size, cudaMemcpyHostToDevice);
	vecAdd << <T, N >> > (devA, devB, devC);
	cudaMemcpy(c, devC, size, cudaMemcpyDeviceToHost);
	cudaFree(devA);
	cudaFree(devB);
	cudaFree(devC);
	for (int i = 0; i < N*T; i++) {
		printf("%d = %d * 10 * %d\n", c[i], a[i], b[i]);
	}
	
	return(0);
}
// Helper function for using CUDA to add vectors in parallel.

