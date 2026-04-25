# app/routers/chat.py
import asyncio
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import google.generativeai as genai
from app.config import settings

router = APIRouter()

genai.configure(api_key=settings.gemini_api_key)

model = genai.GenerativeModel(
    model_name="gemini-2.0-flash",
    generation_config={
        "temperature": 0.7,
        "max_output_tokens": 300,
    }
)

SYSTEM_PROMPT = """Tu es OARA, tuteur IA pour élèves burkinabè.
Règles :
- Réponds en 2-3 phrases maximum, texte brut uniquement
- Après chaque explication, pose UNE question de compréhension
- Programme BF : Maths, SVT, Histoire-Géo, Français, Physique
- Bienveillant, simple, niveau collège/lycée"""

# ── BASE DE CONNAISSANCES LOCALE (fallback si Gemini indispo) ──
KB = {
    "pythagore": "Dans un triangle rectangle, c² = a² + b². Le carré de l'hypoténuse vaut la somme des carrés des deux autres côtés. Peux-tu me donner un exemple de triangle avec les côtés 3, 4 et 5 ?",
    "photosynthese": "La plante capte la lumière du soleil, absorbe l'eau et le CO₂, et produit du glucose et de l'oxygène. Quel gaz la plante rejette-t-elle pendant la photosynthèse ?",
    "photosynthèse": "La plante capte la lumière du soleil, absorbe l'eau et le CO₂, et produit du glucose et de l'oxygène. Quel gaz la plante rejette-t-elle pendant la photosynthèse ?",
    "respiration": "La cellule utilise le glucose et l'oxygène pour produire de l'énergie, et rejette du CO₂ et de l'eau. Quel gaz est absorbé pendant la respiration cellulaire ?",
    "revolution": "La Révolution française commence en 1789 avec la prise de la Bastille le 14 juillet. Elle met fin à la monarchie absolue. En quelle année Napoléon prend-il le pouvoir ?",
    "révolution": "La Révolution française commence en 1789 avec la prise de la Bastille le 14 juillet. Elle met fin à la monarchie absolue. En quelle année Napoléon prend-il le pouvoir ?",
    "napoléon": "Napoléon Bonaparte prend le pouvoir en 1799 après la Révolution française. Il devient Empereur des Français en 1804. Quelle bataille célèbre Napoléon a-t-il perdue en 1815 ?",
    "napoleon": "Napoléon Bonaparte prend le pouvoir en 1799 après la Révolution française. Il devient Empereur des Français en 1804. Quelle bataille célèbre Napoléon a-t-il perdue en 1815 ?",
    "géographie": "La géographie étudie la surface de la Terre, ses reliefs, ses climats et ses populations. Le Burkina Faso est un pays enclavé d'Afrique de l'Ouest. Quelle est la capitale du Burkina Faso ?",
    "geographie": "La géographie étudie la surface de la Terre, ses reliefs, ses climats et ses populations. Le Burkina Faso est un pays enclavé d'Afrique de l'Ouest. Quelle est la capitale du Burkina Faso ?",
    "physique": "La physique étudie les lois de la nature : le mouvement, l'énergie, la lumière et l'électricité. La formule de la vitesse est v = d/t, où d est la distance et t le temps. Si tu parcours 100 km en 2 heures, quelle est ta vitesse ?",
    "chimie": "La chimie étudie la composition et les transformations de la matière. L'eau est une molécule composée de 2 atomes d'hydrogène et 1 atome d'oxygène : H₂O. Quelle est la formule chimique du dioxyde de carbone ?",
    "français": "En français, le sujet fait l'action exprimée par le verbe. Pour trouver le sujet, pose la question 'Qui est-ce qui ?' avant le verbe. Dans la phrase 'Les élèves apprennent', quel est le sujet ?",
    "anglais": "In English, the present simple is used for habits and general truths. We say 'I go to school every day'. Can you make a sentence with the verb 'to study' in the present simple ?",
    "default": "Je suis OARA, ton tuteur. Je peux t'aider avec : Pythagore, Photosynthèse, Respiration, Révolution française, Géographie, Physique, Chimie, Français ou Anglais. Quel sujet veux-tu réviser ?"
}


def get_local_response(message: str) -> str:
    msg = message.lower()
    for key in KB:
        if key in msg:
            return KB[key]
    return KB["default"]


# ── MODELS ──
class MessageInput(BaseModel):
    message: str
    session_id: str | None = None


class MessageOutput(BaseModel):
    response: str
    source: str  # "gemini" ou "local_kb"


# ── ENDPOINTS ──
@router.get("/models")
async def list_models():
    try:
        models = []
        for m in genai.list_models():
            if "generateContent" in m.supported_generation_methods:
                models.append(m.name)
        return {"models_compatibles": models}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/", response_model=MessageOutput)
async def send_message(payload: MessageInput):
    try:
        loop = asyncio.get_event_loop()
        prompt = f"{SYSTEM_PROMPT}\n\nÉlève : {payload.message}\nOARA :"

        response = await asyncio.wait_for(
            loop.run_in_executor(
                None,
                lambda: model.generate_content(prompt)
            ),
            timeout=5.0  # 5 secondes max — adapté réseau Burkina
        )

        return MessageOutput(
            response=response.text.strip(),
            source="gemini"
        )

    except Exception as e:
        # Gemini indispo (quota, timeout, réseau) → fallback local immédiat
        print(f"[OARA FALLBACK] Gemini indispo ({type(e).__name__}), réponse locale")
        return MessageOutput(
            response=get_local_response(payload.message),
            source="local_kb"
        )