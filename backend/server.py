from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
import sys, os

# Add src to Python path
ROOT = os.path.join(os.path.dirname(__file__), "..", "src")
if ROOT not in sys.path:
    sys.path.append(ROOT)

app = FastAPI()

# Allow frontend access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class Query(BaseModel):
    text: str

def get_brain():
    # lazy load heavy agent code only when a request arrives
    from orchestrator.usaa_brain import USAABrain
    return USAABrain()

@app.post("/ask")
def ask_agent(q: Query):
    brain = get_brain()
    reply = brain.router.handle(q.text)
    return {"reply": reply}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
