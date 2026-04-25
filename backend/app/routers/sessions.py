from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
from app.database import supabase

router = APIRouter()

class SessionCreate(BaseModel):
    user_id: str
    matiere: str
    duree_minutes: int
    score_comprehension: float      # 0.0 à 1.0
    nb_questions: int
    nb_bonnes_reponses: int
    nb_tentatives: int = 1
    mode_offline: bool = False

@router.post("/")
def create_session(session: SessionCreate):
    try:
        res = supabase.table("sessions").insert(session.model_dump()).execute()
        return {"status": "ok", "session_id": res.data[0]["id"]}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/user/{user_id}")
def get_user_sessions(user_id: str):
    res = (supabase.table("sessions")
           .select("*")
           .eq("user_id", user_id)
           .order("heure_debut", desc=True)
           .execute())
    return res.data

@router.post("/sync-batch")
def sync_batch(sessions: list[SessionCreate]):
    """Endpoint pour sync offline — reçoit plusieurs sessions d'un coup"""
    try:
        data = [s.model_dump() for s in sessions]
        res = supabase.table("sessions").insert(data).execute()
        return {"status": "ok", "synced": len(res.data)}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))