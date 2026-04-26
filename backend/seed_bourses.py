import json
from app.database import supabase

with open(r"C:\Users\Lenovo\OneDrive\Desktop\AORA\OARA_Bourses_Final_26.json", "r", encoding="utf-8") as f:
    bourses_raw = json.load(f)

# Adapte le format pour Supabase (retire l'id numérique)
bourses = []
for b in bourses_raw:
    bourses.append({
        "nom": b["nom"],
        "organisme": b.get("organisme"),
        "type": b.get("type"),
        "niveau_requis": b.get("niveau_requis"),
        "age_min": b.get("age_min"),
        "age_max": b.get("age_max"),
        "genre": b.get("genre"),
        "handicap_accepte": b.get("handicap_accepte", False),
        "zone_rurale_acceptee": b.get("zone_rurale_acceptee", False),
        "score_oaa_minimum": b.get("score_oaa_minimum", 50),
        "domaines": b.get("domaines", []),
        "pays_eligibles": b.get("pays_eligibles", []),
        "montant": b.get("montant"),
        "duree": b.get("duree"),
        "langue_requise": b.get("langue_requise"),
        "palier_scolaire": b.get("palier_scolaire"),
        "note_realiste": b.get("note_realiste"),
        "source": b.get("source"),
    })

print(f"⏳ Chargement de {len(bourses)} bourses...")
res = supabase.table("bourses").insert(bourses).execute()
print(f"✅ {len(res.data)} bourses insérées !")

# Résumé
scores = [b["score_oaa_minimum"] for b in bourses]
handicap = sum(1 for b in bourses if b["handicap_accepte"])
rurales = sum(1 for b in bourses if b["zone_rurale_acceptee"])
print(f"\nRépartition :")
print(f"  Score OAA min le plus bas  : {min(scores)}/100")
print(f"  Score OAA min le plus haut : {max(scores)}/100")
print(f"  Accessibles aux handicapés : {handicap}/{len(bourses)}")
print(f"  Accessibles zones rurales  : {rurales}/{len(bourses)}")