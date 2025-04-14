import runpod
import time
import numpy as np
import husm_wrapper  # .pyd already included and imported

# ---- HUSM benchmark core logic ----
def run_husm(input_array):
    start = time.time()
    result = husm_wrapper.husm(input_array)
    duration = time.time() - start
    return float(result[0]), duration

# ---- RunPod handler ----
def handler(job):
    """
    job['input'] should look like:
    {
        "prompt": "1000000"   # This is the number of elements in the array
    }
    """
    try:
        count = int(job["input"]["prompt"])
        array = np.random.randn(count).astype(np.float32)

        husm_result, husm_time = run_husm(array)
        np_result = float(np.sum(array))
        diff = abs(husm_result - np_result)

        return {
            "✅ HUSM result": husm_result,
            "🧠 NumPy result": np_result,
            "📐 Difference": diff,
            "⚡ HUSM runtime (sec)": round(husm_time, 6),
            "🧪 Array size": count
        }

    except Exception as e:
        return {"error": str(e)}

# ---- Start the endpoint ----
runpod.serverless.start({"handler": handler})
