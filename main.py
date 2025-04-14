from fastapi import FastAPI
import uvicorn
import numpy as np
from husm_wrapper import husm_reduce

app = FastAPI()

@app.post("/husm-reduce")
async def husm_api(data: dict):
    arrays = data.get("streams", [])
    result = husm_reduce(arrays)
    return {"results": result, "total": sum(result)}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000)
