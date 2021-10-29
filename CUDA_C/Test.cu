#define T 1024 //T is for MAX number of threads in a single block
#define N 500000000 //Amount of elements in the vector
#include<stdio.h>
#include<stdlib.h>

__global__ void add(int *a, int *b, int *c){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i < N){
        c[i] = a[i] + b[i];
    }
}

int main(){
    int *a, *b, *c;
    int *dev_a, *dev_b, *dev_c;
    
    a = (int *)malloc(N * sizeof(int));
    b = (int *)malloc(N * sizeof(int));
    c = (int *)malloc(N * sizeof(int));
    
    cudaMalloc((void **) &dev_a, N * sizeof(int));
    cudaMalloc((void **) &dev_b, N * sizeof(int));
    cudaMalloc((void **) &dev_c, N * sizeof(int));
    
    cudaMemcpy(dev_a, a, (N * sizeof(int)), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, (N * sizeof(int)), cudaMemcpyHostToDevice);
    
    add<<<((int)ceil(N / T)), 1024>>>(dev_a, dev_b, dev_c);
    cudaMemcpy(c, dev_c, (N * sizeof(int)), cudaMemcpyDeviceToHost);
    
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    
    return 0;
}
