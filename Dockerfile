# 1. Alap kép (Ubuntu + CUDA)
FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# 2. Alap rendszer csomagok
RUN apt-get update && apt-get install -y \
    wget curl git build-essential cmake \
    python3.13 python3.13-dev python3.13-venv \
    && apt-get clean

# 3. Python 3.13 alias
RUN ln -s /usr/bin/python3.13 /usr/bin/python && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python

# 4. Munkakönyvtár
WORKDIR /app

# 5. Kód másolása
COPY . .

# 6. Python csomagok
RUN pip install --upgrade pip && pip install -r requirements.txt

# 7. C++ modul fordítása (ha setup.py van)
RUN if [ -f "setup.py" ]; then python setup.py build_ext --inplace; fi

# 8. Port kiexportálása
EXPOSE 8000

# 9. FastAPI indítása
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
