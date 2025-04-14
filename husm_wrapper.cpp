// Dummy wrapper for demonstration
#include <vector>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

std::vector<float> husm_reduce(const std::vector<std::vector<float>>& input) {
    std::vector<float> result;
    for (const auto& vec : input) {
        float sum = 0;
        for (float v : vec) sum += v;
        result.push_back(sum);
    }
    return result;
}

PYBIND11_MODULE(husm_wrapper, m) {
    m.def("husm_reduce", &husm_reduce, "Reduce multiple arrays");
}
