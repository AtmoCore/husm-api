cmake_minimum_required(VERSION 3.8)
project(husm_wrapper LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Python3 COMPONENTS Interpreter Development REQUIRED)
find_package(pybind11 REQUIRED)

include_directories(${Python3_INCLUDE_DIRS})
include_directories(${pybind11_INCLUDE_DIRS})

set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

pybind11_add_module(husm_wrapper
    "${SOURCE_DIR}/husm_wrapper.cpp"
    "${SOURCE_DIR}/husm.cu"
)

target_compile_options(husm_wrapper PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:--expt-relaxed-constexpr>)
