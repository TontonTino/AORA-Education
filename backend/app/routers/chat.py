from fastapi import APIRouter
from pydantic import BaseModel
import httpx
import re
from app.config import settings

router = APIRouter()

LECONS = {
    "maths_fractions": "Les Fractions Simples CE2",
    "francais_temps": "L Imparfait et le Passe Compose CM1",
    "histoire_burkina": "Le Burkina Faso Regions et Royaumes 6eme",
}

PROMPTS = {
    "maths_fractions": "Tu es OARA tuteur IA pour eleves burkinabe. Lecon sur les fractions simples CE2. Max 3 phrases. Exemples avec mangue to galette. Encourage toujours. Termine par une question.",
    "francais_temps": "Tu es OARA tuteur IA pour eleves burkinabe. Lecon sur imparfait et passe compose CM1. Passe compose action terminee. Imparfait habitude repetee. Max 3 phrases. Encourage toujours.",
    "histoire_burkina": "Tu es OARA tuteur IA pour eleves burkinabe. Lecon sur le Burkina Faso 6eme. 13 regions. Capitale Ouagadougou. Royaume Mossi Mogho Naba. Sankara 1984 Pays des Hommes Integres. Max 3 phrases. Encourage toujours.",
    "general": "Tu es OARA tuteur IA bienveillant pour eleves burkinabe. Max 3 phrases. Exemples du quotidien burkinabe. Encourage toujours. Termine par une question.",
}

OFFLINE = {
    "maths_fractions": "Bonjour ! Aujourd hui on apprend les fractions. Une fraction c est une part d un tout. Tu es pret a commencer ?",
    "francais_temps": "Bonjour ! Aujourd hui on apprend l imparfait et le passe compose. Tu es pret ?",
    "histoire_burkina": "Bonjour ! Aujourd hui on parle du Burkina Faso et son histoire. Tu es pret ?",
    "general": "Bonjour ! Je suis OARA ton tuteur. Quelle matiere veux-tu travailler ?",
}


class ChatMessage(BaseModel):
    user_id: str
    message: str
    matiere: str = "general"
    historique: list[dict] = []


def extraire_reponse(msg: dict, matiere: str) -> str:
    """Extrait le texte de la réponse même pour les modèles reasoning"""
    # Cas normal : content direct
    content = msg.get("content")
    if content:
        return content

    # Cas modèle reasoning : extrait depuis reasoning_details
    details = msg.get("reasoning_details") or []
    for d in details:
        texte = d.get("text", "")
        if not texte:
            continue
        if "craft:" in texte:
            return texte.split("craft:")[-1].strip().strip('"')
        matches = re.findall(r'"([^"]{20,})"', texte)
        if matches:
            return matches[-1]

    # Fallback final
    return OFFLINE.get(matiere, OFFLINE["general"])


@router.post("/")
def chat(body: ChatMessage):
    prompt = PROMPTS.get(body.matiere, PROMPTS["general"])
    titre = LECONS.get(body.matiere, "Conversation libre")
    message_complet = prompt + "\n\nEleve dit : " + body.message

    try:
        headers = {
            "Authorization": f"Bearer {settings.openrouter_key}",
            "Content-Type": "application/json",
            "HTTP-Referer": "https://oara-backend.onrender.com",
            "X-Title": "OARA Tuteur IA",
        }

        # Liste de modèles standard (pas reasoning) à essayer dans l'ordre
        modeles = [
            "liquid/lfm-2.5-1.2b-instruct:free",
            "google/gemma-4-26b-a4b-it:free",
            "poolside/laguna-xs.2:free",
        ]

        reponse_text = None

        for modele in modeles:
            try:
                payload = {
                    "model": modele,
                    "messages": [{"role": "user", "content": message_complet}],
                    "max_tokens": 150,
                }
                with httpx.Client(timeout=10) as client:
                    response = client.post(
                        "https://openrouter.ai/api/v1/chat/completions",
                        headers=headers,
                        json=payload,
                    )
                data = response.json()

                if "choices" not in data:
                    print(f"[{modele}] Pas de choices — on essaie le suivant")
                    continue

                content = data["choices"][0]["message"].get("content")
                if not content:
                    print(f"[{modele}] Content vide — on essaie le suivant")
                    continue

                reponse_text = content
                print(f"[OPENROUTER OK] Modèle utilisé : {modele}")
                print(f"[OPENROUTER OK] Réponse : {reponse_text[:80]}")
                break

            except Exception as em:
                print(f"[{modele}] Erreur : {type(em).__name__} — on essaie le suivant")
                continue

        if not reponse_text:
            reponse_text = OFFLINE.get(body.matiere, OFFLINE["general"])
            return {
                "reponse": reponse_text,
                "user_id": body.user_id,
                "matiere": body.matiere,
                "lecon_titre": titre,
                "source": "offline_fallback",
            }

        return {
            "reponse": reponse_text,
            "user_id": body.user_id,
            "matiere": body.matiere,
            "lecon_titre": titre,
            "source": "openrouter",
        }

    except Exception as e:
        print(f"[FALLBACK] {type(e).__name__}: {str(e)[:150]}")
        return {
            "reponse": OFFLINE.get(body.matiere, OFFLINE["general"]),
            "user_id": body.user_id,
            "matiere": body.matiere,
            "lecon_titre": titre,
            "source": "offline_fallback",
        }


@router.get("/lecons")
def get_lecons():
    return {"lecons": [{"id": k, "titre": v} for k, v in LECONS.items()]}