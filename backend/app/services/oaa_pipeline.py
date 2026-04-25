from app.database import supabase
import google.generativeai as genai
from app.config import settings
import json

genai.configure(api_key=settings.gemini_api_key)

def calculer_et_sauvegarder_oaa(user_id: str):
    """Pipeline complet : récupère sessions → analyse → score → sauvegarde"""
    try:
        # 1. Récupère toutes les sessions de l'élève
        res = supabase.table("sessions").select("*").eq("user_id", user_id).execute()
        sessions = res.data

        if not sessions:
            return

        # 2. Calcule les scores de base
        academique    = _calculer_academique(sessions)
        assiduite     = _calculer_assiduite(sessions)
        resilience    = _calculer_resilience(sessions)
        extrascolaire = _calculer_extrascolaire(sessions)

        # 3. Enrichit la résilience avec Gemini si dispo
        resilience = _enrichir_resilience_gemini(sessions, resilience)

        total = round(academique + assiduite + resilience + extrascolaire, 2)

        # 4. Sauvegarde le score
        supabase.table("scores_oaa").insert({
            "user_id": user_id,
            "score_academique": academique,
            "score_extrascolaire": extrascolaire,
            "score_resilience": resilience,
            "score_assiduite": assiduite,
            "score_total": total,
        }).execute()

        print(f"[OAA] Score mis à jour pour {user_id} : {total}/100")

    except Exception as e:
        print(f"[OAA ERROR] {user_id} : {str(e)}")


def _calculer_academique(sessions: list) -> float:
    """Max 40 pts"""
    if not sessions:
        return 0
    moy = sum(s["score_comprehension"] for s in sessions) / len(sessions)
    return round(moy * 40, 2)


def _calculer_assiduite(sessions: list) -> float:
    """Max 20 pts — régularité"""
    return min(len(sessions) * 2.5, 20)


def _calculer_resilience(sessions: list) -> float:
    """Max 20 pts — persévérance + offline"""
    score = 0
    for s in sessions:
        if s["nb_tentatives"] > 2:
            score += 2
        if s["mode_offline"]:
            score += 1
    return min(score, 20)


def _calculer_extrascolaire(sessions: list) -> float:
    """Max 20 pts — enrichi en S3 avec vraies données"""
    return 10.0


def _enrichir_resilience_gemini(sessions: list, score_base: float) -> float:
    """Gemini analyse les patterns de persévérance — enrichit le score"""
    try:
        model = genai.GenerativeModel("gemini-1.5-flash")

        # Résumé des sessions pour Gemini
        resume = [{
            "matiere": s["matiere"],
            "score": s["score_comprehension"],
            "tentatives": s["nb_tentatives"],
            "offline": s["mode_offline"],
            "duree": s["duree_minutes"]
        } for s in sessions[-10:]]  # 10 dernières sessions max

        prompt = f"""Analyse ces sessions d'apprentissage d'un élève burkinabè :
{json.dumps(resume, ensure_ascii=False)}

Score de résilience actuel : {score_base}/20

Réponds UNIQUEMENT avec un JSON valide, sans texte avant ou après :
{{
  "score_resilience_ajuste": <nombre entre 0 et 20>,
  "raison": "<explication courte>"
}}"""

        response = model.generate_content(prompt)
        text = response.text.strip()

        # Nettoie si Gemini ajoute des backticks
        if "```" in text:
            text = text.split("```")[1]
            if text.startswith("json"):
                text = text[4:]

        data = json.loads(text.strip())
        score_ajuste = float(data.get("score_resilience_ajuste", score_base))
        raison = data.get("raison", "")
        print(f"[OAA Gemini] Résilience ajustée : {score_ajuste}/20 — {raison}")
        return min(max(score_ajuste, 0), 20)

    except Exception as e:
        print(f"[OAA Gemini] Fallback score de base : {str(e)}")
        return score_base  # Retourne le score calculé sans Gemini