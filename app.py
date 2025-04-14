from fastapi import FastAPI, Request
import uvicorn
from husm_wrapper import husm_reduce

app = FastAPI()

@app.post("/husm-reduce")
async def reduce_endpoint(req: Request):
    data = await req.json()
    streams = data["streams"]
    result = husm_reduce(streams)
    total = sum(result)
    return {
        "results": result,
        "total": total
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
