from fastapi import FastAPI
from datetime import datetime
import httpx
import os

app = FastAPI(title="F1 Telemetry Tracker")

# In-memory store for demo purposes
race_data = []

@app.get("/")
def root():
    return {"status": "F1 Telemetry Tracker running", "timestamp": datetime.now().isoformat()}

@app.get("/health")
def health():
    return {"status": "healthy"}

@app.get("/races")
def get_races():
    return {"races": race_data, "count": len(race_data)}

@app.get("/fetch")
async def fetch_races():
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://api.jolpi.ca/ergast/f1/2025/races.json"
        )
        data = response.json()
        races = data["MRData"]["RaceTable"]["Races"]
        race_data.clear()
        for race in races:
            race_data.append({
                "round": race["round"],
                "name": race["raceName"],
                "circuit": race["Circuit"]["circuitName"],
                "date": race["date"],
                "country": race["Circuit"]["Location"]["country"]
            })
    return {"message": f"Fetched {len(race_data)} races", "races": race_data}

@app.get("/metrics")
def metrics():
    return {
        "race_count": len(race_data),
        "last_updated": datetime.now().isoformat(),
        "db_password_loaded": bool(os.getenv("DB_PASSWORD"))
    }
