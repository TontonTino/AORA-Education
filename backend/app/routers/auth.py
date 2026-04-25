from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.database import supabase

router = APIRouter()

class UserCreate(BaseModel):
    nom: str
    prenom: str
    niveau: str
    region: str
    profil: str  # voyant | non_voyant | sourd | muet
    langue_parent: str = "fr"

class UserResponse(BaseModel):
    id: str
    nom: str
    prenom: str
    profil: str

@router.post("/register", response_model=UserResponse)
def register(user: UserCreate):
    try:
        res = supabase.table("users").insert(user.model_dump()).execute()
        data = res.data[0]
        return UserResponse(
            id=data["id"],
            nom=data["nom"],
            prenom=data["prenom"],
            profil=data["profil"]
        )
    except Exception as e:
        print("ERREUR SUPABASE:", str(e))  # ← ajoute cette ligne
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/user/{user_id}")
def get_user(user_id: str):
    res = supabase.table("users").select("*").eq("id", user_id).execute()
    if not res.data:
        raise HTTPException(status_code=404, detail="Utilisateur non trouvé")
    return res.data[0]