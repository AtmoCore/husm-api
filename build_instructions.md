## Build Instructions (Windows, Visual Studio, CUDA)

1. Install:
   - Python 3.11 (64-bit)
   - CUDA Toolkit (11.8 or newer)
   - Visual Studio with "Desktop Development with C++"

2. Create build directory:
   `bash
   mkdir build
   cd build
   cmake .. -DCMAKE_BUILD_TYPE=Release
   cmake --build . --config Release
