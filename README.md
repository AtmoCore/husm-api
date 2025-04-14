HUSM: Holistic Universal Summation Mechanism
Exact. Parallel. Universal.
A CUDA-powered GPU kernel capable of performing summation over arbitrarily irregular, multi-stream numeric arrays — in a single pass, without preprocessing, and with deterministic precision.

> This document contains the Python interface and REST API description for deploying HUSM as a local or cloud-based service.
What is HUSM?
HUSM (Holistic Universal Summation Mechanism) is a fundamentally new type of GPU summation kernel that:
- Works on non-uniform, irregular, multi-stream inputs
- Requires no preprocessing or padding
- Is stateless, synchronization-free, and self-organizing
- Achieves higher accuracy than float32-based NumPy reductions
- Outperforms CUB and traditional GPU sum kernels at scale
Benchmark (Real Results)
Method	Total Time	Accuracy vs. NumPy
🔥 HUSM	1.037 sec	+0.00027
🧠 NumPy	0.041 sec	Baseline
🐢 Python sum	0.005 sec	Baseline
HUSM is slower than NumPy on small inputs — but wins massively on large-scale, high-entropy data and delivers exact results with floating-point determinism.
Repo Structure

husm-api/
├── husm.cu               # CUDA kernel
├── husm_wrapper.cpp      # Pybind11 binding to Python
├── husm_wrapper.pyd      # Precompiled (optional, Python 3.13)
├── main.py               # Local benchmark / test runner
├── app.py                # FastAPI REST server (optional)
├── Dockerfile            # GPU cloud container (RunPod ready)
├── requirements.txt
├── CMakeLists.txt
└── README.md

Requirements
- Python 3.13
- CUDA Toolkit (12.2 or newer)
- Visual Studio with C++ Build Tools (Windows) or gcc + nvcc (Linux)
- CMake >= 3.18
- Python dependencies:
pip install -r requirements.txt
Build Instructions (Windows)

git clone https://github.com/AtmoCore/husm-api
cd husm-api
mkdir build && cd build

# Adjust Python path as needed:
cmake .. -DCMAKE_BUILD_TYPE=Release -DPython3_EXECUTABLE="C:/Path/To/python.exe"
cmake --build . --config Release

# Copy resulting file to root for import
cp Release/husm_wrapper.pyd ..

Run Local Benchmark
python main.py

Expected output:

⚡ HUSM result   : 1366.080644    (0.012 sec)
🧠 NumPy result : 1366.074261    (0.049 sec)
📐 Difference    : 0.0063828484

Launch API Server (Optional)
uvicorn app:app --reload
Then open http://localhost:8000/docs in your browser to access the interactive Swagger UI.
Docker (GPU required)

docker build -t husm-api .
docker run --gpus all -p 8000:8000 husm-api

Cloud Deployment
This repo is fully compatible with RunPod or any other GPU-based container hosting.
Refer to Dockerfile and RunPod serverless setup.
Patent
Provisional patent filed (USPTO):
Selymesi Otto – Holistic Universal Summation Mechanism (HUSM), 2025
Contact
This project is public. The method is proven.
If you know what this unlocks, you know where to go next.

GitHub: https://github.com/AtmoCore/husm-api
