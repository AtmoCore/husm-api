#include <cuda_runtime.h>
#include <vector>
#include <iostream>

__global__ void husm_kernel(float* input, int* indices, float* output, int num_streams) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx >= num_streams) return;

    int start = indices[idx];
    int end = indices[idx + 1];

    float sum = 0.0f;
    for (int i = start; i < end; ++i) {
        sum += input[i];
    }

    output[idx] = sum;
}

extern "C" void launch_husm(const std::vector<std::vector<float>>& streams, std::vector<float>& result) {
    int total_elements = 0;
    int num_streams = streams.size();

    std::vector<float> flat_input;
    std::vector<int> indices;

    indices.push_back(0);
    for (const auto& stream : streams) {
        total_elements += stream.size();
        flat_input.insert(flat_input.end(), stream.begin(), stream.end());
        indices.push_back(total_elements);
    }

    float *d_input, *d_output;
    int *d_indices;

    cudaMalloc(&d_input, flat_input.size() * sizeof(float));
    cudaMalloc(&d_indices, indices.size() * sizeof(int));
    cudaMalloc(&d_output, num_streams * sizeof(float));

    cudaMemcpy(d_input, flat_input.data(), flat_input.size() * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_indices, indices.data(), indices.size() * sizeof(int), cudaMemcpyHostToDevice);

    int threads_per_block = 256;
    int blocks = (num_streams + threads_per_block - 1) / threads_per_block;

    husm_kernel<<<blocks, threads_per_block>>>(d_input, d_indices, d_output, num_streams);

    result.resize(num_streams);
    cudaMemcpy(result.data(), d_output, num_streams * sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(d_input);
    cudaFree(d_indices);
    cudaFree(d_output);
}
