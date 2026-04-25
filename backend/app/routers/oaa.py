from fastapi import APIRouter, HTTPException
from app.database import supabase
from app.services.rapport_parental import generer_rapport

router = APIRouter()

def calculer_assiduite(sessions: list) -> float:
    """Max 20 pts — basé sur régularité hebdomadaire"""
    if not sessions:
        return 0
    nb = len(sessions)
    return min(nb * 2.5, 20)

def calculer_academique(sessions: list) -> float:
    """Max 40 pts — basé sur scores de compréhension"""
    if not sessions:
        return 0
    moy = sum(s["score_comprehension"] for s in sessions) / len(sessions)
    return round(moy * 40, 2)

def calculer_resilience(sessions: list) -> float:
    """Max 20 pts — persévérance après échec + sessions offline"""
    score = 0
    for s in sessions:
        if s["nb_tentatives"] > 2:
            score += 2          # persévérance
        if s["mode_offline"]:
            score += 1          # a travaillé sans réseau
    return min(score, 20)

def calculer_extrascolaire(user_id: str) -> float:
    """Max 20 pts — pour l'instant fixe, enrichi plus tard"""
    return 10.0

@router.get("/score/{user_id}")
def get_oaa_score(user_id: str):
    res = (supabase.table("sessions")
           .select("*")
           .eq("user_id", user_id)
           .execute())
    sessions = res.data

    if not sessions:
        raise HTTPException(status_code=404, detail="Aucune session trouvée")

    academique    = calculer_academique(sessions)
    assiduite     = calculer_assiduite(sessions)
    resilience    = calculer_resilience(sessions)
    extrascolaire = calculer_extrascolaire(user_id)
    total         = academique + assiduite + resilience + extrascolaire

    score_data = {
        "user_id": user_id,
        "score_academique": academique,
        "score_extrascolaire": extrascolaire,
        "score_resilience": resilience,
        "score_assiduite": assiduite,
        "score_total": round(total, 2),
    }

    # Sauvegarde en base
    supabase.table("scores_oaa").insert(score_data).execute()

    return {
        **score_data,
        "details": {
            "nb_sessions": len(sessions),
            "sessions_offline": sum(1 for s in sessions if s["mode_offline"]),
        }
    }

@router.get("/orientation/{user_id}")
def get_orientation(user_id: str):
    """Suggère des bourses selon le score OAA"""
    score_res = (supabase.table("scores_oaa")
                 .select("score_total")
                 .eq("user_id", user_id)
                 .order("calcule_le", desc=True)
                 .limit(1)
                 .execute())

    if not score_res.data:
        raise HTTPException(status_code=404, detail="Score OAA non calculé")

    score = score_res.data[0]["score_total"]

    bourses = (supabase.table("bourses")
               .select("*")
               .lte("score_oaa_min", score)
               .execute())

    return {
        "score_oaa": score,
        "bourses_suggérées": bourses.data,
        "nb_bourses": len(bourses.data)
    }

@router.get("/rapport/{user_id}")
def get_rapport_parental(user_id: str, langue: str = "fr"):
    """
    Génère le rapport parental vocal.
    langue = fr | moore | dioula | fulfulde
    """
    rapport = generer_rapport(user_id, langue)
    if "erreur" in rapport:
        raise HTTPException(status_code=404, detail=rapport["erreur"])
    return rapport