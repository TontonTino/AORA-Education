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
    """Suggère des bourses selon le profil complet de l'élève"""

    # 1. Récupère le profil de l'élève
    user_res = supabase.table("users").select("*").eq("id", user_id).execute()
    if not user_res.data:
        raise HTTPException(status_code=404, detail="Élève non trouvé")
    user = user_res.data[0]

    # 2. Récupère le dernier score OAA
    score_res = (supabase.table("scores_oaa")
                 .select("*")
                 .eq("user_id", user_id)
                 .order("calcule_le", desc=True)
                 .limit(1)
                 .execute())

    if not score_res.data:
        raise HTTPException(status_code=404, detail="Score OAA non calculé")

    score = score_res.data[0]["score_total"]
    est_handicape = user["profil"] in ["non_voyant", "sourd", "muet"]
    est_rural = user["region"] in [
        "Dori", "Ouahigouya", "Tenkodogo",
        "Kaya", "Fada N'Gourma", "Banfora"
    ]

    # 3. Récupère toutes les bourses
    bourses_res = supabase.table("bourses").select("*").execute()
    toutes_bourses = bourses_res.data

    # 4. Matching intelligent
    bourses_match = []
    for b in toutes_bourses:
        score_min = b.get("score_oaa_minimum", 50)

        # Filtre score OAA
        if score < score_min:
            continue

        # Calcule un score de pertinence
        pertinence = 0

        # Bonus handicap
        if est_handicape and b.get("handicap_accepte"):
            pertinence += 30

        # Bonus zone rurale
        if est_rural and b.get("zone_rurale_acceptee"):
            pertinence += 20

        # Bonus score OAA élevé
        if score >= 75:
            pertinence += 15
        elif score >= 60:
            pertinence += 10
        elif score >= 45:
            pertinence += 5

        bourses_match.append({
            "nom": b["nom"],
            "organisme": b["organisme"],
            "montant": b["montant"],
            "duree": b["duree"],
            "score_oaa_minimum": score_min,
            "handicap_accepte": b["handicap_accepte"],
            "zone_rurale_acceptee": b["zone_rurale_acceptee"],
            "note_realiste": b["note_realiste"],
            "source": b["source"],
            "pertinence": pertinence,
        })

    # 5. Trie par pertinence et retourne les 5 meilleures
    bourses_match.sort(key=lambda x: x["pertinence"], reverse=True)
    top_bourses = bourses_match[:5]

    return {
        "user_id": user_id,
        "prenom": user["prenom"],
        "profil": user["profil"],
        "region": user["region"],
        "score_oaa": score,
        "est_handicape": est_handicape,
        "est_rural": est_rural,
        "nb_bourses_eligibles": len(bourses_match),
        "top_5_bourses": top_bourses,
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