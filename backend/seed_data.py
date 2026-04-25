from app.database import supabase
import random

eleves = [
    # ── NON-VOYANTS (15) ──
    {"nom":"Sawadogo","prenom":"Aminata","niveau":"CM1","region":"Ouagadougou","profil":"non_voyant","langue_parent":"moore"},
    {"nom":"Ouédraogo","prenom":"Rasmané","niveau":"6e","region":"Koudougou","profil":"non_voyant","langue_parent":"moore"},
    {"nom":"Compaoré","prenom":"Fatoumata","niveau":"CE2","region":"Ouagadougou","profil":"non_voyant","langue_parent":"fr"},
    {"nom":"Kaboré","prenom":"Adama","niveau":"5e","region":"Ouahigouya","profil":"non_voyant","langue_parent":"moore"},
    {"nom":"Traoré","prenom":"Salimata","niveau":"3e","region":"Bobo-Dioulasso","profil":"non_voyant","langue_parent":"dioula"},
    {"nom":"Zongo","prenom":"Ibrahima","niveau":"CM2","region":"Kaya","profil":"non_voyant","langue_parent":"moore"},
    {"nom":"Ouoba","prenom":"Mariam","niveau":"4e","region":"Ouagadougou","profil":"non_voyant","langue_parent":"fr"},
    {"nom":"Tiendrébeogo","prenom":"Boureima","niveau":"CE1","region":"Tenkodogo","profil":"non_voyant","langue_parent":"moore"},
    {"nom":"Nikiéma","prenom":"Aïssata","niveau":"2nde","region":"Ouagadougou","profil":"non_voyant","langue_parent":"fr"},
    {"nom":"Belem","prenom":"Seydou","niveau":"CM1","region":"Fada N'Gourma","profil":"non_voyant","langue_parent":"fulfulde"},
    {"nom":"Ouédraogo","prenom":"Roukiatou","niveau":"6e","region":"Dori","profil":"non_voyant","langue_parent":"fulfulde"},
    {"nom":"Sawadogo","prenom":"Hamidou","niveau":"CE2","region":"Koudougou","profil":"non_voyant","langue_parent":"moore"},
    {"nom":"Kaboré","prenom":"Zénabou","niveau":"1ère","region":"Ouagadougou","profil":"non_voyant","langue_parent":"fr"},
    {"nom":"Compaoré","prenom":"Inoussa","niveau":"CM2","region":"Banfora","profil":"non_voyant","langue_parent":"dioula"},
    {"nom":"Traoré","prenom":"Kadiatou","niveau":"3e","region":"Bobo-Dioulasso","profil":"non_voyant","langue_parent":"dioula"},

    # ── SOURDS (15) ──
    {"nom":"Ouédraogo","prenom":"Daouda","niveau":"6e","region":"Bobo-Dioulasso","profil":"sourd","langue_parent":"dioula"},
    {"nom":"Sawadogo","prenom":"Assétou","niveau":"CM1","region":"Ouagadougou","profil":"sourd","langue_parent":"moore"},
    {"nom":"Kaboré","prenom":"Moussa","niveau":"5e","region":"Koudougou","profil":"sourd","langue_parent":"moore"},
    {"nom":"Zongo","prenom":"Safiatou","niveau":"4e","region":"Ouagadougou","profil":"sourd","langue_parent":"fr"},
    {"nom":"Compaoré","prenom":"Issouf","niveau":"CE2","region":"Banfora","profil":"sourd","langue_parent":"dioula"},
    {"nom":"Nikiéma","prenom":"Ramata","niveau":"3e","region":"Ouagadougou","profil":"sourd","langue_parent":"fr"},
    {"nom":"Ouoba","prenom":"Yacouba","niveau":"CM2","region":"Tenkodogo","profil":"sourd","langue_parent":"moore"},
    {"nom":"Belem","prenom":"Oumou","niveau":"2nde","region":"Fada N'Gourma","profil":"sourd","langue_parent":"fulfulde"},
    {"nom":"Tiendrébeogo","prenom":"Salif","niveau":"CE1","region":"Kaya","profil":"sourd","langue_parent":"moore"},
    {"nom":"Traoré","prenom":"Maimouna","niveau":"6e","region":"Bobo-Dioulasso","profil":"sourd","langue_parent":"dioula"},
    {"nom":"Ouédraogo","prenom":"Dramane","niveau":"CM1","region":"Ouahigouya","profil":"sourd","langue_parent":"moore"},
    {"nom":"Sawadogo","prenom":"Hawa","niveau":"1ère","region":"Ouagadougou","profil":"sourd","langue_parent":"fr"},
    {"nom":"Kaboré","prenom":"Abdoul","niveau":"5e","region":"Dori","profil":"sourd","langue_parent":"fulfulde"},
    {"nom":"Compaoré","prenom":"Souleymane","niveau":"4e","region":"Koudougou","profil":"sourd","langue_parent":"moore"},
    {"nom":"Zongo","prenom":"Aminata","niveau":"Terminale","region":"Ouagadougou","profil":"sourd","langue_parent":"fr"},

    # ── MUETS (10) ──
    {"nom":"Nikiéma","prenom":"Wendkouni","niveau":"CM1","region":"Ouagadougou","profil":"muet","langue_parent":"moore"},
    {"nom":"Ouoba","prenom":"Bintou","niveau":"6e","region":"Kaya","profil":"muet","langue_parent":"moore"},
    {"nom":"Belem","prenom":"Adama","niveau":"CE2","region":"Fada N'Gourma","profil":"muet","langue_parent":"fulfulde"},
    {"nom":"Tiendrébeogo","prenom":"Mariam","niveau":"5e","region":"Ouagadougou","profil":"muet","langue_parent":"fr"},
    {"nom":"Traoré","prenom":"Idrissa","niveau":"3e","region":"Bobo-Dioulasso","profil":"muet","langue_parent":"dioula"},
    {"nom":"Ouédraogo","prenom":"Fanta","niveau":"CM2","region":"Ouahigouya","profil":"muet","langue_parent":"moore"},
    {"nom":"Sawadogo","prenom":"Lassané","niveau":"4e","region":"Koudougou","profil":"muet","langue_parent":"moore"},
    {"nom":"Kaboré","prenom":"Aminata","niveau":"2nde","region":"Ouagadougou","profil":"muet","langue_parent":"fr"},
    {"nom":"Compaoré","prenom":"Tidiane","niveau":"CE1","region":"Banfora","profil":"muet","langue_parent":"dioula"},
    {"nom":"Zongo","prenom":"Rokia","niveau":"6e","region":"Tenkodogo","profil":"muet","langue_parent":"moore"},

    # ── ZONE RURALE OFFLINE (10) ──
    {"nom":"Ouédraogo","prenom":"Bakary","niveau":"CM1","region":"Dori","profil":"voyant","langue_parent":"fulfulde"},
    {"nom":"Sawadogo","prenom":"Safiatou","niveau":"CE2","region":"Dori","profil":"voyant","langue_parent":"fulfulde"},
    {"nom":"Compaoré","prenom":"Aboubacar","niveau":"6e","region":"Ouahigouya","profil":"voyant","langue_parent":"moore"},
    {"nom":"Kaboré","prenom":"Néné","niveau":"CM2","region":"Ouahigouya","profil":"voyant","langue_parent":"moore"},
    {"nom":"Traoré","prenom":"Fousseni","niveau":"5e","region":"Tenkodogo","profil":"voyant","langue_parent":"moore"},
    {"nom":"Nikiéma","prenom":"Aminata","niveau":"CE1","region":"Tenkodogo","profil":"voyant","langue_parent":"moore"},
    {"nom":"Ouoba","prenom":"Hamza","niveau":"4e","region":"Fada N'Gourma","profil":"voyant","langue_parent":"fulfulde"},
    {"nom":"Belem","prenom":"Ramatou","niveau":"CM1","region":"Fada N'Gourma","profil":"voyant","langue_parent":"fulfulde"},
    {"nom":"Tiendrébeogo","prenom":"Issiaka","niveau":"3e","region":"Kaya","profil":"voyant","langue_parent":"moore"},
    {"nom":"Zongo","prenom":"Mariam","niveau":"CE2","region":"Kaya","profil":"voyant","langue_parent":"moore"},

    # ── TOP PERFORMERS (5) ──
    {"nom":"Ouédraogo","prenom":"Fatimata","niveau":"Terminale","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Sawadogo","prenom":"Arouna","niveau":"1ère","region":"Bobo-Dioulasso","profil":"voyant","langue_parent":"fr"},
    {"nom":"Compaoré","prenom":"Aïcha","niveau":"Terminale","region":"Ouagadougou","profil":"non_voyant","langue_parent":"fr"},
    {"nom":"Kaboré","prenom":"Mahamadi","niveau":"2nde","region":"Koudougou","profil":"voyant","langue_parent":"moore"},
    {"nom":"Traoré","prenom":"Awa","niveau":"Terminale","region":"Ouagadougou","profil":"sourd","langue_parent":"fr"},

    # ── STANDARD VARIÉS (25) ──
    {"nom":"Zongo","prenom":"Seydou","niveau":"CE1","region":"Ouagadougou","profil":"voyant","langue_parent":"moore"},
    {"nom":"Nikiéma","prenom":"Bintou","niveau":"CP","region":"Bobo-Dioulasso","profil":"voyant","langue_parent":"dioula"},
    {"nom":"Ouoba","prenom":"Mamadou","niveau":"CM1","region":"Koudougou","profil":"voyant","langue_parent":"moore"},
    {"nom":"Belem","prenom":"Aminata","niveau":"6e","region":"Banfora","profil":"voyant","langue_parent":"dioula"},
    {"nom":"Tiendrébeogo","prenom":"Salif","niveau":"5e","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Sawadogo","prenom":"Kadiatou","niveau":"4e","region":"Bobo-Dioulasso","profil":"voyant","langue_parent":"dioula"},
    {"nom":"Ouédraogo","prenom":"Moussa","niveau":"3e","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Compaoré","prenom":"Mariam","niveau":"2nde","region":"Koudougou","profil":"voyant","langue_parent":"moore"},
    {"nom":"Kaboré","prenom":"Ibrahim","niveau":"1ère","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Traoré","prenom":"Assata","niveau":"CE2","region":"Bobo-Dioulasso","profil":"voyant","langue_parent":"dioula"},
    {"nom":"Zongo","prenom":"Hamidou","niveau":"CM2","region":"Ouagadougou","profil":"voyant","langue_parent":"moore"},
    {"nom":"Nikiéma","prenom":"Fatoumata","niveau":"6e","region":"Banfora","profil":"voyant","langue_parent":"dioula"},
    {"nom":"Ouoba","prenom":"Drissa","niveau":"5e","region":"Kaya","profil":"voyant","langue_parent":"moore"},
    {"nom":"Belem","prenom":"Rokiatou","niveau":"CM1","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Tiendrébeogo","prenom":"Abdoulaye","niveau":"4e","region":"Fada N'Gourma","profil":"voyant","langue_parent":"fulfulde"},
    {"nom":"Sawadogo","prenom":"Aïssata","niveau":"CE1","region":"Dori","profil":"voyant","langue_parent":"fulfulde"},
    {"nom":"Ouédraogo","prenom":"Korotimi","niveau":"3e","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Compaoré","prenom":"Yacouba","niveau":"CP","region":"Bobo-Dioulasso","profil":"voyant","langue_parent":"dioula"},
    {"nom":"Kaboré","prenom":"Sylvie","niveau":"CM2","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Traoré","prenom":"Inoussa","niveau":"6e","region":"Koudougou","profil":"voyant","langue_parent":"moore"},
    {"nom":"Zongo","prenom":"Maimouna","niveau":"5e","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Nikiéma","prenom":"Souleymane","niveau":"4e","region":"Banfora","profil":"voyant","langue_parent":"dioula"},
    {"nom":"Ouoba","prenom":"Rasmata","niveau":"CE2","region":"Tenkodogo","profil":"voyant","langue_parent":"moore"},
    {"nom":"Belem","prenom":"Oumar","niveau":"CM1","region":"Ouagadougou","profil":"voyant","langue_parent":"fr"},
    {"nom":"Tiendrébeogo","prenom":"Aminata","niveau":"3e","region":"Kaya","profil":"voyant","langue_parent":"moore"},
]

def seed():
    print(f"⏳ Insertion de {len(eleves)} élèves...")
    # Insère par batch de 20 pour éviter les timeouts
    for i in range(0, len(eleves), 20):
        batch = eleves[i:i+20]
        res = supabase.table("users").insert(batch).execute()
        print(f"  ✅ Batch {i//20 + 1} : {len(res.data)} élèves insérés")

    print(f"\n🎉 {len(eleves)} élèves chargés avec succès !")
    print("\nRépartition :")
    print(f"  Non-voyants : 15")
    print(f"  Sourds      : 15")
    print(f"  Muets       : 10")
    print(f"  Ruraux offline : 10")
    print(f"  Top performers : 5")
    print(f"  Standard    : 25")

if __name__ == "__main__":
    seed()