FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    git \
    cmake \
    python3-dev

RUN pip3 install fastapi uvicorn pybind11 numpy

WORKDIR /app
COPY . /app

RUN cmake . && make

CMD ["python3", "main.py"]
