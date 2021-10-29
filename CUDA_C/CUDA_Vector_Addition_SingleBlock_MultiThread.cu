#define N 1024
#include<stdio.h>

__global__ void add(int *a, int *b, int *c){
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

int main(){
    int a[N], b[N], c[N];
    int *dev_a, *dev_b, *dev_c;
    
    cudaMalloc((void **) &dev_a, N * sizeof(int));
    cudaMalloc((void **) &dev_b, N * sizeof(int));
    cudaMalloc((void **) &dev_c, N * sizeof(int));
    
    for(int j = 0; j < N; j++){
        a[j] = 2;
        b[j] = 3;
    }
    cudaMemcpy(dev_a, a, (N * sizeof(int)), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, (N * sizeof(int)), cudaMemcpyHostToDevice);
    
    add<<<1, 1024>>>(dev_a, dev_b, dev_c);
    cudaMemcpy(c, dev_c, (N * sizeof(int)), cudaMemcpyDeviceToHost);
    
    for(int j = 0; j <= 5; j++)
        printf("\n%d",c[j]);
    
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    
    return 0;
}
