#include <stdio.h>

#define N 1024

__global__
void array_sum(float *x, float *y, float *z){
	int tid = blockIdx.x;
	if (tid < N)
		z[tid] = x[tid] * y[tid];
}
	

int main(void){
	float *x, *xx;
	float *y, *yy;
	float *z, *zz;

	// Allocate memory in the main memory
	xx = (float *) malloc(N*sizeof(float));
	yy = (float *) malloc(N*sizeof(float));
	zz = (float *) malloc(N*sizeof(float));

	// Add some data to this array
	for (int i=0 ; i < N; i++){
		xx[i] = 0.1*i;
		yy[i] = 1;
	}

	// Allocate memory in the GPU
	cudaMalloc(&x, N*sizeof(float));
	cudaMalloc(&y, N*sizeof(float));
	cudaMalloc(&z, N*sizeof(float));

	// Copy memory from main memory to GPU
	cudaMemcpy(x, xx, N*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(y, yy, N*sizeof(float), cudaMemcpyHostToDevice);

	array_sum<<<1, N>>>(x, y, z);

	cudaMemcpy(zz, z, N*sizeof(float), cudaMemcpyDeviceToHost);
	
	for (int i=0 ; i < N; i++){
		printf("%d %20f\n", i, z[i]);
	}

	return 0;		
}
