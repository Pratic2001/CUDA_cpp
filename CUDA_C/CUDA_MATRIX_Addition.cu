#define N 512
#define BLOCK_DIM 32
#include<stdio.h>
int a[N][N], b[N][N], c[N][N];
__global__ void add(int *a, int *b, int *c){
    int row = threadIdx.x + blockDim.x * blockIdx.x;
    int col = threadIdx.y + blockDim.y * blockIdx.y;
    
    c[row][col] = a[row][col] + b[row][col];
}

int main(){
    int *dev_a, *dev_b, *dev_c;
    
    cudaMalloc((void **) &dev_a, N*N * sizeof(int));
    cudaMalloc((void **) &dev_b, N*N * sizeof(int));
    cudaMalloc((void **) &dev_c, N*N * sizeof(int));
    
    for(int j = 0; j < N; j++){
        for(int m = 0; m < N; m++){
            a[j][m] = 2;
            b[j][m] = 3;
        }
    }
    cudaMemcpy2D(dev_a, a, (N * N * sizeof(int)), cudaMemcpyHostToDevice);
    cudaMemcpy2D(dev_b, b, (N * N * sizeof(int)), cudaMemcpyHostToDevice);
    
    dim3 dimBlock(BLOCK_DIM, BLOCK_DIM);
    dim3 dimGrid((int)ceil(N / dimBlock.x), (int)ceil(N / dimBlock.y));
    add<<<dimGrid, dimBlock>>>(dev_a, dev_b, dev_c);
    cudaMemcpy(c, dev_c, (N * sizeof(int)), cudaMemcpyDeviceToHost);
    
    for(int j = 0; j <= 5; j++){
        for(int m = 0; m < N; m++){
            printf("\n %d",c[j][m]);
        }
    }
    
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    
    return 0;
}
