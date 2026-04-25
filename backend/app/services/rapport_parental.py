import google.generativeai as genai
from app.config import settings
from app.database import supabase

genai.configure(api_key=settings.gemini_api_key)

# Traductions de base hardcodées (validées par locuteurs natifs en S1)
TEMPLATES = {
    "moore": {
        "intro": "Yãmb f'a biig {prenom} koɛɛga:",
        "progression": "A zãmsd ne {score}/100.",
        "encouragement_bon": "A maan neere! A tũud tõnd.",
        "encouragement_moyen": "A tũud n tõog. Bɩ y sõng-a.",
        "matieres": "A zãmsd: {matieres}.",
    },
    "dioula": {
        "intro": "I den {prenom} ka kalan kunbaba:",
        "progression": "A ye {score}/100 sɔrɔ.",
        "encouragement_bon": "A kalan ka di! A bɛ tɛmɛ.",
        "encouragement_moyen": "A bɛ jija. I ka a dɛmɛ.",
        "matieres": "A ye kalan kɛ: {matieres}.",
    },
    "fulfulde": {
        "intro": "Gaa makkol maa {prenom} laawol mawnol:",
        "progression": "O heɓii {score}/100.",
        "encouragement_bon": "O waɗii ko moƴƴi! O yahata dow.",
        "encouragement_moyen": "O rokkata. Ndukku mo.",
        "matieres": "O janngii: {matieres}.",
    },
    "fr": {
        "intro": "Rapport hebdomadaire de {prenom} :",
        "progression": "Score OARA cette semaine : {score}/100.",
        "encouragement_bon": "Excellent travail ! Continuez à l'encourager.",
        "encouragement_moyen": "Des progrès sont visibles. Encouragez-le à continuer.",
        "matieres": "Matières travaillées : {matieres}.",
    }
}

def generer_rapport(user_id: str, langue: str = "fr") -> dict:
    """Génère le rapport parental textuel dans la langue demandée"""
    try:
        # 1. Récupère les infos de l'élève
        user_res = supabase.table("users").select("*").eq("id", user_id).execute()
        if not user_res.data:
            return {"erreur": "Élève non trouvé"}
        user = user_res.data[0]

        # 2. Récupère le dernier score OAA
        score_res = (supabase.table("scores_oaa")
                     .select("*")
                     .eq("user_id", user_id)
                     .order("calcule_le", desc=True)
                     .limit(1)
                     .execute())
        score_total = score_res.data[0]["score_total"] if score_res.data else 0

        # 3. Récupère les matières de la semaine
        sessions_res = (supabase.table("sessions")
                        .select("matiere")
                        .eq("user_id", user_id)
                        .execute())
        matieres = list(set(s["matiere"] for s in sessions_res.data))
        matieres_str = ", ".join(matieres) if matieres else "aucune"

        # 4. Choisit le template selon la langue
        langue = langue if langue in TEMPLATES else "fr"
        t = TEMPLATES[langue]

        # 5. Construit le message
        encouragement = (t["encouragement_bon"]
                        if score_total >= 60
                        else t["encouragement_moyen"])

        rapport_texte = " ".join([
            t["intro"].format(prenom=user["prenom"]),
            t["progression"].format(score=round(score_total, 1)),
            t["matieres"].format(matieres=matieres_str),
            encouragement,
        ])

        return {
            "user_id": user_id,
            "prenom": user["prenom"],
            "langue": langue,
            "score_total": score_total,
            "rapport_texte": rapport_texte,
            "matieres": matieres,
        }

    except Exception as e:
        return {"erreur": str(e)}