// ============================================================
// OARA — Leçons offline complètes
// Niveau : Primaire (CP, CE, CM)
// Matières : Français, Maths, SVT, Histoire-Géo, Anglais
// ============================================================

class OfflineLesson {
  final String id;
  final String matiere;
  final String niveau;
  final String titre;
  final List<String> objectifs;
  final String introduction;
  final String cours;
  final List<String> exemples;
  final List<String> exercices;
  final List<String> corrections;
  final String conclusion;

  const OfflineLesson({
    required this.id,
    required this.matiere,
    required this.niveau,
    required this.titre,
    required this.objectifs,
    required this.introduction,
    required this.cours,
    required this.exemples,
    required this.exercices,
    required this.corrections,
    required this.conclusion,
  });
}

class OfflineLessons {
  static List<OfflineLesson> getAll() => [
        ..._primaireFrancais,
        ..._primaireMaths,
        ..._primaireSVT,
        ..._primaireHistoireGeo,
        ..._primaireAnglais,
        ..._collegeFrancais,
        ..._collegeMaths,
        ..._collegeSVT,
        ..._collegeHistoireGeo,
        ..._collegeAnglais,
        ..._collegePhyChimie,
        ..._lyceeFrancais,
        ..._lyceeMaths,
        ..._lyceeSVT,
        ..._lyceeHistoireGeo,
        ..._lyceeAnglais,
        ..._lyceePhyChimie,
      ];

  static List<OfflineLesson> getByMatiere(String matiere) =>
      getAll().where((l) => l.matiere == matiere).toList();

  static List<OfflineLesson> getByNiveau(String niveau) =>
      getAll().where((l) => l.niveau == niveau).toList();

  static List<OfflineLesson> getByMatiereEtNiveau(
          String matiere, String niveau) =>
      getAll()
          .where((l) => l.matiere == matiere && l.niveau == niveau)
          .toList();

  // ================================================================
  // PRIMAIRE — FRANÇAIS
  // ================================================================
  static const _primaireFrancais = [
    OfflineLesson(
      id: 'fr_cp_01',
      matiere: 'Français',
      niveau: 'CP',
      titre: 'Les lettres de l\'alphabet et les sons',
      objectifs: [
        'Reconnaître et nommer les 26 lettres de l\'alphabet',
        'Associer chaque lettre à son son',
        'Écrire les lettres en majuscule et minuscule',
      ],
      introduction:
          'Bonjour ! Aujourd\'hui, nous allons découvrir les lettres de l\'alphabet. '
          'L\'alphabet est comme une famille de 26 lettres. Chaque lettre a un nom et fait un son. '
          'Avec ces lettres, on peut écrire tous les mots du monde !',
      cours: 'L\'ALPHABET FRANÇAIS\n\n'
          'Il y a 26 lettres dans l\'alphabet français.\n\n'
          'Les voyelles (elles font entendre leur son seules) :\n'
          'A - E - I - O - U - Y\n\n'
          'Les consonnes (elles ont besoin d\'une voyelle pour faire un son) :\n'
          'B - C - D - F - G - H - J - K - L - M - N - P - Q - R - S - T - V - W - X - Z\n\n'
          'Chaque lettre s\'écrit en deux façons :\n'
          '• En MAJUSCULE (grande lettre) : A, B, C...\n'
          '• En minuscule (petite lettre) : a, b, c...\n\n'
          'On utilise la majuscule :\n'
          '• Au début d\'une phrase\n'
          '• Pour les prénoms et les noms de villes\n'
          'Exemple : Aminata habite à Ouagadougou.',
      exemples: [
        'A comme Arbre, Ami, Avion',
        'B comme Balle, Bonjour, Bébé',
        'C comme Chat, Cerise, Couleur',
        'M comme Maman, Maison, Mouton',
        'S comme Soleil, Savane, Sable',
      ],
      exercices: [
        'Exercice 1 : Écris les 26 lettres de l\'alphabet dans l\'ordre.',
        'Exercice 2 : Entoure les voyelles dans ces mots : BAOBAB - ÉCOLE - SOLEIL',
        'Exercice 3 : Écris 3 mots qui commencent par la lettre M.',
        'Exercice 4 : Remets ces lettres dans l\'ordre pour trouver un mot : L - A - B - A',
      ],
      corrections: [
        'Exercice 2 : BAOBAB (A, O, A) - ÉCOLE (É, O, E) - SOLEIL (O, E, I)',
        'Exercice 3 : Exemples : Maman, Maison, Mouton, Mangue...',
        'Exercice 4 : BALA (prénom) ou ALBA',
      ],
      conclusion:
          'Bravo ! Tu connais maintenant les 26 lettres de l\'alphabet. '
          'Il y a 6 voyelles et 20 consonnes. Continue à t\'entraîner à les écrire chaque jour !',
    ),
    OfflineLesson(
      id: 'fr_ce_01',
      matiere: 'Français',
      niveau: 'CE',
      titre: 'La phrase et la ponctuation',
      objectifs: [
        'Identifier ce qu\'est une phrase',
        'Reconnaître les principaux signes de ponctuation',
        'Écrire des phrases correctes',
      ],
      introduction: 'Une phrase est un groupe de mots qui a un sens complet. '
          'Elle commence toujours par une majuscule et se termine par un signe de ponctuation. '
          'La ponctuation nous aide à lire et à comprendre les textes.',
      cours: 'LA PHRASE\n\n'
          'Une phrase :\n'
          '• Commence par une MAJUSCULE\n'
          '• Se termine par un signe de ponctuation\n'
          '• A un sens complet\n\n'
          'Exemple ✓ : Le chien mange son repas.\n'
          'Pas une phrase ✗ : chien mange son\n\n'
          'LES SIGNES DE PONCTUATION\n\n'
          '1. Le point (.) → termine une phrase normale\n'
          '   Exemple : La savane est belle.\n\n'
          '2. Le point d\'interrogation (?) → pose une question\n'
          '   Exemple : Comment tu t\'appelles ?\n\n'
          '3. Le point d\'exclamation (!) → exprime une émotion forte\n'
          '   Exemple : Quel beau baobab !\n\n'
          '4. La virgule (,) → marque une pause dans la phrase\n'
          '   Exemple : J\'aime les mangues, les papayes et les oranges.\n\n'
          '5. Les deux points (:) → annoncent une liste ou une explication\n'
          '   Exemple : J\'ai acheté des fruits : des mangues et des bananes.',
      exemples: [
        'Phrase déclarative : Ibrahima va à l\'école chaque matin.',
        'Phrase interrogative : Est-ce que tu as fait tes devoirs ?',
        'Phrase exclamative : Bravo, tu as réussi !',
        'Phrase avec virgule : Fatoumata, viens manger !',
      ],
      exercices: [
        'Exercice 1 : Mets le bon signe de ponctuation (. ? !) à la fin de chaque phrase :\n'
            'a) Le soleil se couche à l\'ouest\n'
            'b) Quelle belle journée\n'
            'c) À quelle heure commence l\'école',
        'Exercice 2 : Ces groupes de mots sont-ils des phrases ? Écris OUI ou NON :\n'
            'a) Les enfants jouent dans la cour.\n'
            'b) marché au aller\n'
            'c) Adama lit un livre.',
        'Exercice 3 : Réécris cette phrase correctement :\n'
            '"le berger conduit ses moutons au pâturage"',
      ],
      corrections: [
        'Exercice 1 : a) point (.) b) point d\'exclamation (!) c) point d\'interrogation (?)',
        'Exercice 2 : a) OUI b) NON c) OUI',
        'Exercice 3 : Le berger conduit ses moutons au pâturage.',
      ],
      conclusion:
          'Pour écrire une bonne phrase, pense toujours à la majuscule au début '
          'et au bon signe de ponctuation à la fin. La ponctuation rend ta lecture plus belle !',
    ),
    OfflineLesson(
      id: 'fr_cm_01',
      matiere: 'Français',
      niveau: 'CM',
      titre: 'Le nom et le groupe nominal',
      objectifs: [
        'Identifier les noms communs et les noms propres',
        'Reconnaître et construire un groupe nominal',
        'Utiliser les déterminants correctement',
      ],
      introduction:
          'Les noms sont des mots très importants dans la phrase. Ils désignent des personnes, '
          'des animaux, des choses ou des idées. Un groupe nominal est un ensemble de mots '
          'organisés autour d\'un nom.',
      cours: 'LE NOM\n\n'
          '1. Le nom commun : il désigne une personne, un animal ou une chose en général.\n'
          '   Exemples : enfant, lion, maison, école, amitié\n'
          '   Il s\'écrit avec une minuscule.\n\n'
          '2. Le nom propre : il désigne une personne, une ville ou un pays particulier.\n'
          '   Exemples : Aminata, Ouagadougou, Burkina Faso, Niger\n'
          '   Il s\'écrit TOUJOURS avec une majuscule.\n\n'
          'LE GROUPE NOMINAL (GN)\n\n'
          'Un groupe nominal est formé de :\n'
          '• Un déterminant (article) + un nom\n'
          '• Un déterminant + un nom + un adjectif\n\n'
          'LES DÉTERMINANTS\n\n'
          'Articles définis : le, la, l\', les\n'
          '→ désignent quelque chose de précis\n'
          '→ Exemple : le baobab (on sait de quel baobab on parle)\n\n'
          'Articles indéfinis : un, une, des\n'
          '→ désignent quelque chose de non précis\n'
          '→ Exemple : un baobab (n\'importe quel baobab)\n\n'
          'ACCORD DU GROUPE NOMINAL\n\n'
          'Le déterminant et l\'adjectif s\'accordent avec le nom :\n'
          '• En genre (masculin/féminin)\n'
          '• En nombre (singulier/pluriel)\n'
          'Exemple : un petit garçon → une petite fille → des petits garçons',
      exemples: [
        'le grand baobab → GN masculin singulier',
        'une belle mangue → GN féminin singulier',
        'les enfants sages → GN masculin pluriel',
        'des maisons colorées → GN féminin pluriel',
      ],
      exercices: [
        'Exercice 1 : Classe ces noms en deux colonnes (noms communs / noms propres) :\n'
            'cheval - Daouda - rivière - Bobo-Dioulasso - école - Afrique - professeur - Salimata',
        'Exercice 2 : Entoure les groupes nominaux dans ces phrases :\n'
            'a) Le vieux chasseur attrape un gros gibier.\n'
            'b) Une belle fille chante une jolie chanson.',
        'Exercice 3 : Mets ces GN au pluriel :\n'
            'a) un enfant curieux\n'
            'b) la petite fille\n'
            'c) un beau livre',
        'Exercice 4 : Complète avec le bon article (le/la/les/un/une/des) :\n'
            'a) ___ soleil brille fort.\n'
            'b) ___ enfants jouent sous ___ arbre.\n'
            'c) J\'ai vu ___ éléphant au parc.',
      ],
      corrections: [
        'Exercice 1 : Noms communs : cheval, rivière, école, professeur\n'
            'Noms propres : Daouda, Bobo-Dioulasso, Afrique, Salimata',
        'Exercice 2 : a) [Le vieux chasseur] attrape [un gros gibier].\n'
            'b) [Une belle fille] chante [une jolie chanson].',
        'Exercice 3 : a) des enfants curieux b) les petites filles c) de beaux livres',
        'Exercice 4 : a) Le b) Les / l\' c) un',
      ],
      conclusion:
          'Le groupe nominal est le bloc de base de la phrase française. '
          'N\'oublie pas d\'accorder le déterminant et l\'adjectif avec le nom '
          'en genre et en nombre. C\'est la clé d\'une belle écriture !',
    ),
  ];

  // ================================================================
  // PRIMAIRE — MATHÉMATIQUES
  // ================================================================
  static const _primaireMaths = [
    OfflineLesson(
      id: 'ma_cp_01',
      matiere: 'Mathématiques',
      niveau: 'CP',
      titre: 'Les nombres de 0 à 10 — Compter et écrire',
      objectifs: [
        'Compter de 0 à 10',
        'Écrire les chiffres de 0 à 10',
        'Associer un nombre à une quantité',
      ],
      introduction:
          'Les nombres sont partout autour de nous ! On les utilise pour compter '
          'les élèves dans la classe, les moutons dans un troupeau, ou les mangues dans un panier. '
          'Aujourd\'hui, nous apprenons à compter et à écrire les nombres de 0 à 10.',
      cours: 'LES NOMBRES DE 0 À 10\n\n'
          '0 → zéro → aucun objet\n'
          '1 → un → ● (un point)\n'
          '2 → deux → ●● (deux points)\n'
          '3 → trois → ●●● (trois points)\n'
          '4 → quatre → ●●●● (quatre points)\n'
          '5 → cinq → ●●●●● (cinq points)\n'
          '6 → six → ●●●●●● (six points)\n'
          '7 → sept → ●●●●●●● (sept points)\n'
          '8 → huit → ●●●●●●●● (huit points)\n'
          '9 → neuf → ●●●●●●●●● (neuf points)\n'
          '10 → dix → ●●●●●●●●●● (dix points)\n\n'
          'COMPARER LES NOMBRES\n\n'
          '• Plus grand que : > \n'
          '  Exemple : 7 > 3 (7 est plus grand que 3)\n'
          '• Plus petit que : <\n'
          '  Exemple : 2 < 8 (2 est plus petit que 8)\n'
          '• Égal à : =\n'
          '  Exemple : 5 = 5\n\n'
          'ORDRE DES NOMBRES\n'
          '0 - 1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9 - 10',
      exemples: [
        'Il y a 3 mangues dans le panier : ●●● → 3',
        'Le berger a 7 moutons : ●●●●●●● → 7',
        'La classe a 10 élèves : ●●●●●●●●●● → 10',
        '4 > 2 (quatre est plus grand que deux)',
        '1 < 9 (un est plus petit que neuf)',
      ],
      exercices: [
        'Exercice 1 : Écris le nombre qui correspond :\n'
            'a) ●●●●● = ___\n'
            'b) ●●●●●●●● = ___\n'
            'c) ●●● = ___',
        'Exercice 2 : Mets le bon signe (>, < ou =) :\n'
            'a) 5 ___ 8\n'
            'b) 10 ___ 3\n'
            'c) 6 ___ 6',
        'Exercice 3 : Remets ces nombres dans l\'ordre du plus petit au plus grand :\n'
            '7 - 2 - 9 - 4 - 0 - 6',
        'Exercice 4 : Écris le nombre qui vient juste après :\n'
            'a) 3 → ___\n'
            'b) 7 → ___\n'
            'c) 9 → ___',
      ],
      corrections: [
        'Exercice 1 : a) 5 b) 8 c) 3',
        'Exercice 2 : a) < b) > c) =',
        'Exercice 3 : 0 - 2 - 4 - 6 - 7 - 9',
        'Exercice 4 : a) 4 b) 8 c) 10',
      ],
      conclusion:
          'Tu sais maintenant compter de 0 à 10 ! Ces nombres sont la base de toutes '
          'les mathématiques. Entraîne-toi à les écrire et à les reconnaître partout autour de toi.',
    ),
    OfflineLesson(
      id: 'ma_ce_01',
      matiere: 'Mathématiques',
      niveau: 'CE',
      titre: 'L\'addition et la soustraction',
      objectifs: [
        'Effectuer des additions simples',
        'Effectuer des soustractions simples',
        'Résoudre des problèmes simples avec ces opérations',
      ],
      introduction:
          'L\'addition et la soustraction sont les deux premières opérations en mathématiques. '
          'On les utilise tous les jours : quand on achète quelque chose au marché, '
          'quand on partage des fruits, ou quand on compte des élèves absents.',
      cours: 'L\'ADDITION (+)\n\n'
          'Additionner = mettre ensemble, ajouter\n'
          'Exemple : Aminata a 4 mangues. Sa maman lui donne 3 mangues de plus.\n'
          'Combien a-t-elle de mangues en tout ?\n'
          '4 + 3 = 7 mangues\n\n'
          'COMMENT POSER UNE ADDITION\n'
          '   2 4\n'
          '+  1 3\n'
          '------\n'
          '   3 7\n\n'
          'On additionne d\'abord les unités (4+3=7), puis les dizaines (2+1=3).\n\n'
          'LA RETENUE\n'
          'Si la somme des unités dépasse 9, on retient 1 dizaine.\n'
          '   2 7\n'
          '+  1 5\n'
          '------\n'
          '   4 2\n'
          '7+5=12 → on écrit 2 et on retient 1. Puis 2+1+1(retenue)=4.\n\n'
          'LA SOUSTRACTION (-)\n\n'
          'Soustraire = enlever, retirer\n'
          'Exemple : Ibrahima a 10 billes. Il en perd 4.\n'
          'Combien lui reste-t-il de billes ?\n'
          '10 - 4 = 6 billes\n\n'
          'COMMENT POSER UNE SOUSTRACTION\n'
          '   1 5\n'
          '-   8\n'
          '------\n'
          '    7\n'
          '5-8 impossible → on emprunte : 15-8=7. Puis 1-1(emprunté)=0.\n\n'
          'VOCABULAIRE IMPORTANT\n'
          'Addition : augmenter, ajouter, de plus, en tout, au total\n'
          'Soustraction : diminuer, enlever, retirer, il reste, différence',
      exemples: [
        'Au marché : 25 FCFA + 13 FCFA = 38 FCFA',
        'Dans la classe : 30 élèves - 5 absents = 25 présents',
        '47 + 38 = 85 (avec retenue : 7+8=15, on écrit 5 et retient 1)',
        '52 - 24 = 28 (avec emprunt)',
      ],
      exercices: [
        'Exercice 1 : Calcule :\n'
            'a) 23 + 14 = ___\n'
            'b) 36 + 27 = ___\n'
            'c) 45 + 38 = ___',
        'Exercice 2 : Calcule :\n'
            'a) 18 - 5 = ___\n'
            'b) 43 - 21 = ___\n'
            'c) 60 - 37 = ___',
        'Exercice 3 : Problème :\n'
            'Au marché, Bintou a 500 FCFA. Elle achète du riz pour 250 FCFA '
            'et des légumes pour 175 FCFA. Combien lui reste-t-il ?',
        'Exercice 4 : Dans une école, il y a 45 garçons et 38 filles.\n'
            'a) Combien y a-t-il d\'élèves en tout ?\n'
            'b) Combien y a-t-il de garçons de plus que de filles ?',
      ],
      corrections: [
        'Exercice 1 : a) 37 b) 63 c) 83',
        'Exercice 2 : a) 13 b) 22 c) 23',
        'Exercice 3 : 250 + 175 = 425 FCFA dépensés. 500 - 425 = 75 FCFA restants.',
        'Exercice 4 : a) 45 + 38 = 83 élèves b) 45 - 38 = 7 garçons de plus',
      ],
      conclusion:
          'L\'addition et la soustraction sont indispensables dans la vie quotidienne. '
          'Continue à t\'entraîner avec des exemples du marché, '
          'de l\'école et de la maison !',
    ),
    OfflineLesson(
      id: 'ma_cm_01',
      matiere: 'Mathématiques',
      niveau: 'CM',
      titre: 'La multiplication et la division',
      objectifs: [
        'Maîtriser les tables de multiplication de 1 à 10',
        'Effectuer des multiplications et divisions posées',
        'Résoudre des problèmes concrets',
      ],
      introduction:
          'La multiplication est une addition répétée, et la division est le partage équitable. '
          'Ces deux opérations sont très utiles : pour calculer le prix de plusieurs objets, '
          'pour partager des choses en parts égales, ou pour mesurer des surfaces.',
      cours: 'LA MULTIPLICATION (×)\n\n'
          'Multiplier = additionner plusieurs fois le même nombre\n'
          '3 × 4 = 4 + 4 + 4 = 12\n'
          'Ou : 3 fois 4\n\n'
          'TABLES DE MULTIPLICATION (extraits importants) :\n'
          'Table de 2 : 2×1=2, 2×2=4, 2×3=6, 2×4=8, 2×5=10...\n'
          'Table de 5 : 5×1=5, 5×2=10, 5×3=15, 5×4=20, 5×5=25...\n'
          'Table de 10 : 10×1=10, 10×2=20, 10×3=30...\n\n'
          'MULTIPLICATION POSÉE :\n'
          '    2 4\n'
          '  ×  3\n'
          '  ---\n'
          '    7 2\n'
          '3×4=12 → on écrit 2, retient 1\n'
          '3×2=6, plus 1(retenue) = 7\n\n'
          'LA DIVISION (÷)\n\n'
          'Diviser = partager en parts égales\n'
          '12 ÷ 4 = 3 (on partage 12 en 4 parts égales = 3 dans chaque part)\n\n'
          'VOCABULAIRE DE LA DIVISION :\n'
          '12 ÷ 4 = 3\n'
          '12 = dividende (ce qu\'on partage)\n'
          '4 = diviseur (en combien de parts)\n'
          '3 = quotient (le résultat)\n\n'
          'DIVISION AVEC RESTE :\n'
          '13 ÷ 4 = 3 reste 1\n'
          'Vérification : 4 × 3 + 1 = 13 ✓\n\n'
          'LIEN ENTRE × ET ÷ :\n'
          'Si 3 × 4 = 12, alors 12 ÷ 4 = 3 et 12 ÷ 3 = 4',
      exemples: [
        'Prix : 1 kg de mil coûte 250 FCFA. Combien coûtent 5 kg ? 250 × 5 = 1 250 FCFA',
        'Partage : 24 élèves en 4 groupes = 24 ÷ 4 = 6 élèves par groupe',
        '36 × 12 = 432 (multiplication posée)',
        '75 ÷ 6 = 12 reste 3',
      ],
      exercices: [
        'Exercice 1 : Calcule :\n'
            'a) 7 × 8 = ___\n'
            'b) 9 × 6 = ___\n'
            'c) 45 × 7 = ___',
        'Exercice 2 : Calcule :\n'
            'a) 36 ÷ 9 = ___\n'
            'b) 56 ÷ 7 = ___\n'
            'c) 85 ÷ 6 = ___ reste ___',
        'Exercice 3 : Problème :\n'
            'Une fermière vend des poulets 2 500 FCFA chacun. '
            'Elle en vend 8 le lundi et 6 le mardi. '
            'a) Combien vend-elle de poulets en tout ?\n'
            'b) Combien gagne-t-elle en tout ?',
        'Exercice 4 : Partage :\n'
            'Rasmané veut distribuer 96 cahiers à ses 8 enfants. '
            'Combien de cahiers recevra chaque enfant ?',
      ],
      corrections: [
        'Exercice 1 : a) 56 b) 54 c) 315',
        'Exercice 2 : a) 4 b) 8 c) 14 reste 1',
        'Exercice 3 : a) 8+6=14 poulets b) 14×2500=35 000 FCFA',
        'Exercice 4 : 96÷8=12 cahiers par enfant',
      ],
      conclusion:
          'La multiplication et la division sont des outils puissants en mathématiques. '
          'Apprends bien tes tables et entraîne-toi à résoudre des problèmes '
          'de la vie quotidienne. Tu progresseras très vite !',
    ),
  ];

  // ================================================================
  // PRIMAIRE — SVT
  // ================================================================
  static const _primaireSVT = [
    OfflineLesson(
      id: 'svt_cp_01',
      matiere: 'SVT',
      niveau: 'CP',
      titre: 'Le corps humain — Les parties du corps',
      objectifs: [
        'Nommer les principales parties du corps humain',
        'Localiser ces parties sur son propre corps',
        'Comprendre le rôle de chaque partie',
      ],
      introduction:
          'Notre corps est une machine extraordinaire ! Chaque partie a un rôle important. '
          'Aujourd\'hui, nous allons apprendre à nommer et à connaître les différentes parties '
          'de notre corps.',
      cours: 'LES PARTIES DU CORPS HUMAIN\n\n'
          'LA TÊTE :\n'
          '• Les yeux → pour voir\n'
          '• Les oreilles → pour entendre\n'
          '• Le nez → pour sentir et respirer\n'
          '• La bouche → pour manger et parler\n'
          '• Les dents → pour mâcher les aliments\n'
          '• Les cheveux → protègent la tête\n\n'
          'LE TRONC :\n'
          '• La poitrine → contient le cœur et les poumons\n'
          '• Le ventre → contient l\'estomac\n'
          '• Le dos → soutient le corps\n\n'
          'LES MEMBRES SUPÉRIEURS (les bras) :\n'
          '• L\'épaule → relie le bras au tronc\n'
          '• Le bras\n'
          '• Le coude → permet de plier le bras\n'
          '• L\'avant-bras\n'
          '• La main → pour saisir les objets\n'
          '• Les doigts → il y en a 5 à chaque main\n\n'
          'LES MEMBRES INFÉRIEURS (les jambes) :\n'
          '• La cuisse\n'
          '• Le genou → permet de plier la jambe\n'
          '• La jambe\n'
          '• Le pied → pour marcher et courir\n'
          '• Les orteils → il y en a 5 à chaque pied\n\n'
          'NOTRE SQUELETTE :\n'
          'Notre corps est soutenu par des os. L\'ensemble des os s\'appelle le squelette. '
          'Les os protègent nos organes importants.',
      exemples: [
        'La tête est en haut du corps',
        'Nous avons 2 bras et 2 jambes',
        'Chaque main a 5 doigts : le pouce, l\'index, le majeur, l\'annulaire et l\'auriculaire',
        'Le cœur est dans la poitrine et bat pour faire circuler le sang',
      ],
      exercices: [
        'Exercice 1 : Complète les phrases :\n'
            'a) J\'entends avec mes ___.\n'
            'b) Je vois avec mes ___.\n'
            'c) Je marche avec mes ___.',
        'Exercice 2 : Combien en as-tu ?\n'
            'a) Yeux : ___\n'
            'b) Mains : ___\n'
            'c) Doigts (en tout) : ___\n'
            'd) Jambes : ___',
        'Exercice 3 : Associe la partie du corps à son rôle :\n'
            'Nez - Oreilles - Yeux - Bouche\n'
            'a) Pour voir → ___\n'
            'b) Pour entendre → ___\n'
            'c) Pour sentir → ___\n'
            'd) Pour manger → ___',
      ],
      corrections: [
        'Exercice 1 : a) oreilles b) yeux c) jambes (ou pieds)',
        'Exercice 2 : a) 2 b) 2 c) 10 d) 2',
        'Exercice 3 : a) Yeux b) Oreilles c) Nez d) Bouche',
      ],
      conclusion:
          'Notre corps est composé de nombreuses parties qui travaillent ensemble. '
          'Prends soin de ton corps : mange bien, dors suffisamment et fais du sport !',
    ),
    OfflineLesson(
      id: 'svt_ce_01',
      matiere: 'SVT',
      niveau: 'CE',
      titre: 'Les animaux — Classification et modes de vie',
      objectifs: [
        'Classer les animaux selon différents critères',
        'Distinguer animaux sauvages et domestiques',
        'Comprendre les régimes alimentaires des animaux',
      ],
      introduction:
          'Le monde animal est très riche et varié. En Afrique et au Burkina Faso, '
          'nous avons la chance de vivre près de nombreux animaux fascinants. '
          'Apprenons à les connaître et à les classer.',
      cours: 'CLASSIFICATION DES ANIMAUX\n\n'
          '1. LES MAMMIFÈRES\n'
          '• Ils ont des poils ou des fourrures\n'
          '• Ils allaitent leurs petits\n'
          '• Ils respirent avec des poumons\n'
          'Exemples : lion, éléphant, chèvre, vache, chien, chat, dauphin\n\n'
          '2. LES OISEAUX\n'
          '• Ils ont des plumes et des ailes\n'
          '• La plupart peuvent voler\n'
          '• Ils pondent des œufs\n'
          'Exemples : poulet, aigle, perroquet, autruche, pintade\n\n'
          '3. LES REPTILES\n'
          '• Ils ont des écailles\n'
          '• Ils pondent des œufs\n'
          '• Leur corps suit la température de l\'environnement\n'
          'Exemples : crocodile, lézard, serpent, tortue\n\n'
          '4. LES POISSONS\n'
          '• Ils vivent dans l\'eau\n'
          '• Ils ont des écailles et des nageoires\n'
          '• Ils respirent avec des branchies\n'
          'Exemples : tilapia, capitaine, silure\n\n'
          '5. LES INSECTES\n'
          '• Ils ont 6 pattes\n'
          '• Leur corps est divisé en 3 parties\n'
          'Exemples : fourmi, abeille, moustique, papillon, criquet\n\n'
          'ANIMAUX DOMESTIQUES ET SAUVAGES\n\n'
          'Animaux domestiques : élevés par l\'homme (vache, mouton, chèvre, poulet, chien)\n'
          'Animaux sauvages : vivent librement dans la nature (lion, éléphant, crocodile)\n\n'
          'RÉGIMES ALIMENTAIRES\n\n'
          'Herbivores : mangent des plantes (vache, mouton, girafe, lapin)\n'
          'Carnivores : mangent de la viande (lion, crocodile, aigle)\n'
          'Omnivores : mangent de tout (porc, poule, homme)',
      exemples: [
        'Le lion est un mammifère carnivore et sauvage',
        'La vache est un mammifère herbivore et domestique',
        'Le crocodile est un reptile carnivore qui vit au bord des fleuves',
        'Le poulet est un oiseau omnivore et domestique',
      ],
      exercices: [
        'Exercice 1 : Classe ces animaux (mammifère/oiseau/reptile/poisson/insecte) :\n'
            'crocodile - pintade - éléphant - papillon - tilapia - chèvre - lézard - aigle',
        'Exercice 2 : Domestique ou sauvage ?\n'
            'lion - vache - crocodile - mouton - éléphant - poulet - serpent - chien',
        'Exercice 3 : Quel est le régime alimentaire ?\n'
            'a) Le lion mange des gazelles → ___\n'
            'b) La vache mange de l\'herbe → ___\n'
            'c) La poule mange des graines et des insectes → ___',
      ],
      corrections: [
        'Exercice 1 : Reptile: crocodile, lézard. Oiseau: pintade, aigle. '
            'Mammifère: éléphant, chèvre. Insecte: papillon. Poisson: tilapia.',
        'Exercice 2 : Sauvage: lion, crocodile, éléphant, serpent. '
            'Domestique: vache, mouton, poulet, chien.',
        'Exercice 3 : a) carnivore b) herbivore c) omnivore',
      ],
      conclusion: 'Les animaux sont classés selon leurs caractéristiques. '
          'Protégeons la faune de notre pays, car elle est une richesse précieuse !',
    ),
    OfflineLesson(
      id: 'svt_cm_01',
      matiere: 'SVT',
      niveau: 'CM',
      titre: 'La nutrition — Alimentation et santé',
      objectifs: [
        'Connaître les groupes d\'aliments et leurs rôles',
        'Comprendre l\'importance d\'une alimentation équilibrée',
        'Identifier les maladies liées à la malnutrition',
      ],
      introduction: 'Ce que nous mangeons influence directement notre santé. '
          'Une bonne alimentation nous donne l\'énergie pour étudier, jouer et grandir. '
          'Apprenons à bien manger pour rester en bonne santé.',
      cours: 'LES GROUPES D\'ALIMENTS\n\n'
          '1. LES ALIMENTS ÉNERGÉTIQUES (donnent de l\'énergie)\n'
          '• Les céréales : mil, sorgho, maïs, riz\n'
          '• Les tubercules : igname, manioc, patate douce\n'
          '• Les corps gras : huile, beurre de karité\n'
          '• Les sucres : miel, sucre, fruits sucrés\n\n'
          '2. LES ALIMENTS DE CONSTRUCTION (construisent et réparent le corps)\n'
          '• Protéines animales : viande, poisson, œufs, lait\n'
          '• Protéines végétales : haricots, arachides, niébé, soja\n\n'
          '3. LES ALIMENTS PROTECTEURS (protègent contre les maladies)\n'
          '• Les légumes : tomates, oignons, gombo, épinards, carottes\n'
          '• Les fruits : mangues, oranges, papayes, citrons\n'
          '(Riches en vitamines et minéraux)\n\n'
          'L\'EAU — INDISPENSABLE À LA VIE\n'
          '• L\'eau représente 70% du corps humain\n'
          '• Il faut boire au moins 1,5 à 2 litres d\'eau par jour\n'
          '• L\'eau de boisson doit être propre (traitée ou bouillie)\n\n'
          'UNE ALIMENTATION ÉQUILIBRÉE\n'
          'Un repas équilibré contient :\n'
          '• Des aliments énergétiques (riz, mil...)\n'
          '• Des aliments de construction (viande, haricots...)\n'
          '• Des aliments protecteurs (légumes, fruits)\n'
          '• De l\'eau\n\n'
          'EXEMPLES DE REPAS TRADITIONNELS ÉQUILIBRÉS AU BURKINA FASO :\n'
          '• Tô de mil + sauce de feuilles + viande ou poisson + eau\n'
          '• Riz + haricots + légumes + poisson\n\n'
          'LA MALNUTRITION\n'
          '• Sous-alimentation : manque de nourriture → maigreur, fatigue\n'
          '• Malnutrition protéique (Kwashiorkor) : manque de protéines\n'
          '• Carences en vitamines : manque de vitamine A → problèmes de vue',
      exemples: [
        'Le tô est énergétique (céréale de mil ou de sorgho)',
        'Les haricots niébé fournissent des protéines végétales',
        'La mangue est riche en vitamine C et protège contre les maladies',
        'Un enfant qui ne mange pas assez de protéines peut avoir le ventre gonflé',
      ],
      exercices: [
        'Exercice 1 : Classe ces aliments selon leur groupe :\n'
            'riz - poisson - mangue - arachides - tomates - mil - œufs - oranges - beurre de karité',
        'Exercice 2 : Vrai ou Faux ?\n'
            'a) L\'eau n\'est pas nécessaire à notre santé.\n'
            'b) Les légumes sont des aliments protecteurs.\n'
            'c) Le mil est un aliment de construction.',
        'Exercice 3 : Compose un repas équilibré avec des aliments du Burkina Faso.\n'
            'Mon repas : ___________________',
        'Exercice 4 : Pourquoi est-il important de manger des fruits et légumes chaque jour ?',
      ],
      corrections: [
        'Exercice 1 : Énergétiques: riz, mil, beurre de karité. '
            'Construction: poisson, arachides, œufs. '
            'Protecteurs: mangue, tomates, oranges.',
        'Exercice 2 : a) Faux b) Vrai c) Faux (c\'est énergétique)',
        'Exercice 3 : Exemple : Tô + sauce gombo + viande de bœuf + eau',
        'Exercice 4 : Les fruits et légumes contiennent des vitamines et minéraux '
            'qui protègent notre corps contre les maladies.',
      ],
      conclusion: 'Manger équilibré, c\'est la base d\'une bonne santé. '
          'Notre cuisine traditionnelle burkinabè est riche et nutritive. '
          'Privilégie des repas variés avec des légumes, des protéines et des céréales !',
    ),
  ];

  // ================================================================
  // PRIMAIRE — HISTOIRE-GÉOGRAPHIE
  // ================================================================
  static const _primaireHistoireGeo = [
    OfflineLesson(
      id: 'hg_cp_01',
      matiere: 'Histoire-Géographie',
      niveau: 'CP',
      titre: 'Ma famille et mon environnement proche',
      objectifs: [
        'Identifier les membres de sa famille',
        'Décrire son environnement immédiat',
        'Situer sa maison par rapport à l\'école',
      ],
      introduction:
          'Tu vis dans un endroit particulier : ton quartier, ton village ou ta ville. '
          'Tu as une famille qui prend soin de toi. Aujourd\'hui, nous allons apprendre '
          'à parler de notre famille et de notre environnement proche.',
      cours: 'MA FAMILLE\n\n'
          'La famille est le groupe de personnes avec qui tu vis et qui s\'occupent de toi.\n\n'
          'LES MEMBRES DE LA FAMILLE :\n'
          '• Le père (papa) et la mère (maman) → les parents\n'
          '• Les frères et les sœurs → les fratries\n'
          '• Le grand-père et la grand-mère → les grands-parents\n'
          '• L\'oncle et la tante → les oncles et tantes\n'
          '• Le cousin et la cousine → les cousins\n\n'
          'LA FAMILLE NUCLÉAIRE : père + mère + enfants\n'
          'LA FAMILLE ÉLARGIE : toute la grande famille ensemble\n\n'
          'Dans de nombreuses familles burkinabè, plusieurs générations vivent ensemble. '
          'C\'est une richesse culturelle importante.\n\n'
          'MON ENVIRONNEMENT PROCHE\n\n'
          'Autour de ta maison, il y a :\n'
          '• Des voisins (les gens qui habitent près de chez toi)\n'
          '• Des commerces (boutiques, marché)\n'
          '• L\'école\n'
          '• La mosquée ou l\'église\n'
          '• Le puits ou le robinet\n'
          '• Des arbres (baobabs, néré, karité...)\n\n'
          'SE REPÉRER DANS L\'ESPACE\n'
          'Pour indiquer un chemin, on utilise :\n'
          '• À droite / À gauche\n'
          '• Tout droit\n'
          '• Devant / Derrière\n'
          '• Près de / Loin de',
      exemples: [
        'Mon père s\'appelle Rasmané. Ma mère s\'appelle Aïssata.',
        'Ma maison est près de l\'école. Pour y aller, je tourne à gauche puis je vais tout droit.',
        'Dans notre quartier, il y a un grand baobab où les vieux se retrouvent.',
      ],
      exercices: [
        'Exercice 1 : Dessine et nomme les membres de ta famille.',
        'Exercice 2 : Décris le chemin de ta maison à ton école.',
        'Exercice 3 : Cite 3 endroits importants dans ton quartier ou village.',
        'Exercice 4 : Complète :\n'
            'a) Le père de mon père est mon ___.\n'
            'b) La sœur de ma mère est ma ___.',
      ],
      corrections: [
        'Exercice 3 : Exemples : le marché, la mosquée, le puits, l\'école...',
        'Exercice 4 : a) grand-père b) tante',
      ],
      conclusion: 'Ta famille et ton quartier sont ton premier monde. '
          'Respecte les personnes qui t\'entourent et explore ton environnement avec curiosité !',
    ),
    OfflineLesson(
      id: 'hg_ce_01',
      matiere: 'Histoire-Géographie',
      niveau: 'CE',
      titre: 'Le Burkina Faso — Notre pays',
      objectifs: [
        'Situer le Burkina Faso sur une carte d\'Afrique',
        'Connaître les principales caractéristiques du Burkina Faso',
        'Identifier les régions et les grandes villes',
      ],
      introduction:
          'Le Burkina Faso est notre pays. C\'est un pays d\'Afrique de l\'Ouest '
          'que nous devons connaître et aimer. Découvrons ensemble ses caractéristiques, '
          'son histoire et ses richesses.',
      cours: 'LE BURKINA FASO EN BREF\n\n'
          '• Capitale : Ouagadougou\n'
          '• Deuxième grande ville : Bobo-Dioulasso\n'
          '• Superficie : environ 274 000 km²\n'
          '• Population : environ 22 millions d\'habitants\n'
          '• Langue officielle : le français\n'
          '• Langues nationales principales : mooré, dioula, fulfuldé\n'
          '• Monnaie : le Franc CFA (FCFA)\n'
          '• Fête nationale : 11 décembre\n\n'
          'SITUATION GÉOGRAPHIQUE\n\n'
          'Le Burkina Faso est un pays enclavé (sans accès à la mer).\n'
          'Il est entouré par 6 pays :\n'
          '• Au nord : le Mali et le Niger\n'
          '• À l\'est : le Niger et le Bénin\n'
          '• Au sud : le Togo, le Ghana, la Côte d\'Ivoire\n'
          '• À l\'ouest : le Mali\n\n'
          'LES RÉGIONS\n'
          'Le Burkina Faso est divisé en 13 régions :\n'
          'Centre, Centre-Nord, Centre-Est, Centre-Sud, Centre-Ouest,\n'
          'Nord, Est, Ouest, Hauts-Bassins, Cascades, Sahel, Boucle du Mouhoun, Sud-Ouest\n\n'
          'LE RELIEF ET LE CLIMAT\n\n'
          'Relief : plateau central, quelques collines (Pics de Sindou)\n'
          'Fleuves principaux : Mouhoun (anciennement Volta Noire), Nakambé, Nazinon\n'
          'Climat : tropical avec une saison sèche et une saison des pluies\n'
          'Zone sahélienne au nord (peu de pluies), zone soudanaise au sud\n\n'
          'L\'ÉCONOMIE\n\n'
          'Agriculture : principale activité (coton, sorgho, mil, maïs)\n'
          'Élevage : très développé (bovins, ovins, caprins)\n'
          'Mines : or, zinc, manganèse\n'
          'Le Burkina Faso est l\'un des premiers producteurs d\'or en Afrique',
      exemples: [
        'Ouagadougou est la capitale et le centre économique du pays',
        'Le FESPACO est un festival du cinéma africain qui se tient à Ouagadougou tous les 2 ans',
        'Les Mossi sont le groupe ethnique le plus nombreux au Burkina Faso',
      ],
      exercices: [
        'Exercice 1 : Vrai ou Faux ?\n'
            'a) Le Burkina Faso a une frontière avec l\'océan Atlantique.\n'
            'b) La capitale du Burkina Faso est Ouagadougou.\n'
            'c) La langue officielle est le mooré.',
        'Exercice 2 : Cite les 6 pays voisins du Burkina Faso.',
        'Exercice 3 : Complète :\n'
            'La monnaie du Burkina Faso est ___.\n'
            'La fête nationale est le ___.\n'
            'Le plus grand fleuve est ___.',
        'Exercice 4 : Pourquoi dit-on que le Burkina Faso est un pays enclavé ?',
      ],
      corrections: [
        'Exercice 1 : a) Faux b) Vrai c) Faux (c\'est le français)',
        'Exercice 2 : Mali, Niger, Bénin, Togo, Ghana, Côte d\'Ivoire',
        'Exercice 3 : FCFA / 11 décembre / Mouhoun',
        'Exercice 4 : Car il n\'a pas de côte maritime, il est entouré par d\'autres pays.',
      ],
      conclusion:
          'Le Burkina Faso, "pays des hommes intègres", est un pays riche de sa diversité '
          'culturelle et de ses ressources naturelles. Soyons fiers de notre pays '
          'et travaillons pour son développement !',
    ),
    OfflineLesson(
      id: 'hg_cm_01',
      matiere: 'Histoire-Géographie',
      niveau: 'CM',
      titre: 'L\'Empire Mossi — Histoire précoloniale du Burkina Faso',
      objectifs: [
        'Connaître les origines et l\'organisation de l\'Empire Mossi',
        'Identifier les grands royaumes du Burkina Faso précolonial',
        'Comprendre l\'importance de ce patrimoine historique',
      ],
      introduction:
          'Avant la colonisation française, le territoire qui est aujourd\'hui le Burkina Faso '
          'était organisé en royaumes puissants. L\'Empire Mossi en était le plus important. '
          'Découvrons ensemble cette histoire glorieuse de nos ancêtres.',
      cours: 'L\'EMPIRE MOSSI\n\n'
          'ORIGINES\n'
          'Les Mossi (en mooré : Moose) sont originaires du nord du Ghana actuel.\n'
          'Vers le XIe-XIIe siècle, des guerriers venus du sud s\'installèrent dans le plateau central.\n'
          'Le fondateur légendaire est Naaba Ouédraogo, fils de Nedega (roi du Dagomba).\n\n'
          'ORGANISATION POLITIQUE\n'
          'L\'Empire Mossi était organisé en royaumes (nakomsé) :\n'
          '• Le Mogho Naaba : roi suprême résidant à Ouagadougou\n'
          '• Le Yatenga : royaume au nord (capitale Ouahigouya)\n'
          '• Le Tenkodogo : royaume au sud-est\n'
          '• Le Fada N\'Gourma : royaume à l\'est\n\n'
          'LE MOGHO NAABA\n'
          'Chef suprême des Mossi, il avait un pouvoir politique, religieux et militaire.\n'
          'Sa cour comprenait de nombreux dignitaires :\n'
          '• Le Baloum Naaba : premier ministre\n'
          '• Le Wobgo : ministre de l\'intérieur\n'
          '• Le Larhalle Naaba : ministre des affaires étrangères\n\n'
          'La cérémonie du Ouidi (simulacre de fuite) a lieu chaque vendredi\n'
          'au palais du Mogho Naaba à Ouagadougou. Elle commémore un épisode historique.\n\n'
          'RÉSISTANCE À LA COLONISATION\n'
          'Les royaumes Mossi ont résisté à la colonisation française.\n'
          'En 1896, le Mogho Naaba Wobgo refusa de signer un traité avec la France.\n'
          'Malgré cette résistance, les Français colonisèrent le territoire en 1896-1897.\n\n'
          'AUTRES ROYAUMES IMPORTANTS\n'
          '• Le royaume du Gourounsi\n'
          '• L\'Empire du Kenedougou (Samori Touré)\n'
          '• Les royaumes Bissa, Lobi, Bobo\n\n'
          'HÉRITAGE CULTUREL\n'
          'La chefferie traditionnelle Mossi existe toujours aujourd\'hui.\n'
          'Le Mogho Naaba reste un symbole d\'unité nationale.',
      exemples: [
        'Le Mogho Naaba Wobgo fut le dernier roi mossi à résister aux Français en 1896',
        'La cérémonie du Ouidi a lieu chaque vendredi au palais de Ouagadougou',
        'Les Nakomsé (nobles mossi) portaient des titres héréditaires',
      ],
      exercices: [
        'Exercice 1 : Qui est Naaba Ouédraogo et pourquoi est-il important ?',
        'Exercice 2 : Cite les 4 royaumes principaux de l\'Empire Mossi.',
        'Exercice 3 : Qu\'est-ce que le Mogho Naaba ?\n'
            'Décris ses pouvoirs et son rôle.',
        'Exercice 4 : Vrai ou Faux ?\n'
            'a) Les Mossi viennent du nord du Ghana.\n'
            'b) Le Mogho Naaba Wobgo a accepté la colonisation française.\n'
            'c) La cérémonie du Ouidi a lieu le vendredi.',
      ],
      corrections: [
        'Exercice 1 : Naaba Ouédraogo est le fondateur légendaire de l\'Empire Mossi, '
            'fils de Nedega, roi du Dagomba.',
        'Exercice 2 : Ouagadougou (centre), Yatenga (nord), Tenkodogo (sud-est), Fada N\'Gourma (est)',
        'Exercice 3 : Le Mogho Naaba est le roi suprême des Mossi, avec des pouvoirs '
            'politiques, religieux et militaires.',
        'Exercice 4 : a) Vrai b) Faux (il a refusé) c) Vrai',
      ],
      conclusion:
          'L\'histoire de l\'Empire Mossi nous montre que nos ancêtres avaient '
          'des structures politiques organisées et sophistiquées. '
          'Connaître cette histoire, c\'est être fier de nos racines !',
    ),
  ];

  // ================================================================
  // PRIMAIRE — ANGLAIS
  // ================================================================
  static const _primaireAnglais = [
    OfflineLesson(
      id: 'en_cp_01',
      matiere: 'Anglais',
      niveau: 'CP',
      titre: 'Hello ! — Greetings and introductions',
      objectifs: [
        'Dire bonjour et au revoir en anglais',
        'Se présenter en anglais',
        'Compter de 1 à 10 en anglais',
      ],
      introduction: 'English is spoken by millions of people around the world. '
          'Learning English will help you communicate with people from many countries. '
          'Let\'s start with the basics: saying hello and introducing ourselves!',
      cours: 'GREETINGS — LES SALUTATIONS\n\n'
          '• Hello! / Hi! → Bonjour !\n'
          '• Good morning! → Bonjour ! (le matin)\n'
          '• Good afternoon! → Bon après-midi !\n'
          '• Good evening! → Bonsoir !\n'
          '• Goodbye! / Bye! → Au revoir !\n'
          '• Good night! → Bonne nuit !\n'
          '• How are you? → Comment vas-tu ?\n'
          '• I\'m fine, thank you! → Je vais bien, merci !\n\n'
          'INTRODUCTIONS — SE PRÉSENTER\n\n'
          '• My name is... → Je m\'appelle...\n'
          '• I am... years old → J\'ai... ans\n'
          '• I live in... → J\'habite à...\n'
          '• I am from Burkina Faso → Je viens du Burkina Faso\n\n'
          'EXAMPLE DIALOGUE :\n'
          'A: Hello! My name is Aminata. What is your name?\n'
          'B: Hi! My name is Ibrahima.\n'
          'A: How old are you?\n'
          'B: I am 7 years old. And you?\n'
          'A: I am 8 years old.\n'
          'B: Goodbye, Aminata!\n'
          'A: Bye, Ibrahima!\n\n'
          'NUMBERS 1-10 — LES CHIFFRES\n\n'
          '1 = one      6 = six\n'
          '2 = two      7 = seven\n'
          '3 = three    8 = eight\n'
          '4 = four     9 = nine\n'
          '5 = five     10 = ten',
      exemples: [
        'Hello! My name is Fatoumata. I am 6 years old.',
        'Good morning, teacher! → Bonjour, maître/maîtresse !',
        'I live in Ouagadougou → J\'habite à Ouagadougou',
        'I have 3 brothers → J\'ai 3 frères',
      ],
      exercices: [
        'Exercise 1: Match the English and French words:\n'
            'Hello / Good morning / Goodbye / Thank you\n'
            'Merci / Bonjour(matin) / Au revoir / Bonjour',
        'Exercise 2: Write the numbers in English:\n'
            'a) 3 = ___  b) 7 = ___  c) 10 = ___  d) 5 = ___',
        'Exercise 3: Complete the introduction:\n'
            '"Hello! My ___ is ___. I am ___ years old. I live in ___."',
        'Exercise 4: How do you say in English?\n'
            'a) Bonsoir !\n'
            'b) Comment vas-tu ?\n'
            'c) Je vais bien, merci !',
      ],
      corrections: [
        'Exercise 1: Hello=Bonjour / Good morning=Bonjour(matin) / '
            'Goodbye=Au revoir / Thank you=Merci',
        'Exercise 2: a) three b) seven c) ten d) five',
        'Exercise 3: Hello! My NAME is [votre prénom]. I am [votre âge] years old. '
            'I live in [votre ville].',
        'Exercise 4: a) Good evening! b) How are you? c) I\'m fine, thank you!',
      ],
      conclusion:
          'Well done! You can now greet people and introduce yourself in English. '
          'Practice every day: say "Good morning" to your teacher and "Goodbye" '
          'to your friends. English will become easy!',
    ),
    OfflineLesson(
      id: 'en_ce_01',
      matiere: 'Anglais',
      niveau: 'CE',
      titre: 'My family and my home',
      objectifs: [
        'Décrire sa famille en anglais',
        'Nommer les pièces de la maison',
        'Utiliser les pronoms personnels et les adjectifs possessifs',
      ],
      introduction:
          'Today we will learn to talk about our family and our home in English. '
          'These are topics we talk about every day, so they are very useful to know!',
      cours: 'MY FAMILY — MA FAMILLE\n\n'
          '• father / dad → père / papa\n'
          '• mother / mum → mère / maman\n'
          '• brother → frère\n'
          '• sister → sœur\n'
          '• grandfather → grand-père\n'
          '• grandmother → grand-mère\n'
          '• uncle → oncle\n'
          '• aunt → tante\n'
          '• cousin → cousin(e)\n\n'
          'TALKING ABOUT FAMILY:\n'
          '• I have one brother and two sisters.\n'
          '  → J\'ai un frère et deux sœurs.\n'
          '• My father is a farmer.\n'
          '  → Mon père est agriculteur.\n'
          '• My mother is a teacher.\n'
          '  → Ma mère est enseignante.\n\n'
          'POSSESSIVE ADJECTIVES — ADJECTIFS POSSESSIFS\n\n'
          '• my → mon/ma/mes\n'
          '• your → ton/ta/tes\n'
          '• his → son/sa/ses (pour un garçon)\n'
          '• her → son/sa/ses (pour une fille)\n'
          '• our → notre/nos\n'
          '• their → leur/leurs\n\n'
          'MY HOME — MA MAISON\n\n'
          'Rooms / Les pièces :\n'
          '• bedroom → chambre à coucher\n'
          '• kitchen → cuisine\n'
          '• living room → salon\n'
          '• bathroom → salle de bain\n'
          '• courtyard → cour (très important en Afrique !)\n\n'
          'PERSONAL PRONOUNS — PRONOMS PERSONNELS\n\n'
          'I (je), You (tu/vous), He (il-masc.), She (elle-fém.),\n'
          'We (nous), They (ils/elles)',
      exemples: [
        'My name is Adama. I have two brothers.',
        'Her mother is a nurse. His father is a farmer.',
        'Our house has three bedrooms and a big courtyard.',
        'They live in Bobo-Dioulasso.',
      ],
      exercices: [
        'Exercise 1: Translate into English:\n'
            'a) Mon frère s\'appelle Daouda.\n'
            'b) Ma grand-mère habite au village.\n'
            'c) Nous avons une grande maison.',
        'Exercise 2: Fill in with the right possessive adjective:\n'
            'a) This is ___ book. (mon)\n'
            'b) ___ sister is tall. (sa - pour une fille)\n'
            'c) ___ father is a teacher. (notre)',
        'Exercise 3: Name 4 rooms in a house in English.',
        'Exercise 4: Write 3 sentences about your family in English.',
      ],
      corrections: [
        'Exercise 1: a) My brother\'s name is Daouda. '
            'b) My grandmother lives in the village. '
            'c) We have a big house.',
        'Exercise 2: a) my b) her c) our',
        'Exercise 3: bedroom, kitchen, living room, bathroom (or courtyard)',
        'Exercise 4: Exemples: I have two brothers. My mother is a farmer. We live in Ouagadougou.',
      ],
      conclusion:
          'Great job! Now you can talk about your family and home in English. '
          'Remember: practice makes perfect! Try to use these words every day.',
    ),
    OfflineLesson(
      id: 'en_cm_01',
      matiere: 'Anglais',
      niveau: 'CM',
      titre: 'Animals and nature in Africa',
      objectifs: [
        'Nommer les animaux africains en anglais',
        'Décrire des animaux en utilisant des adjectifs',
        'Utiliser le présent simple correctement',
      ],
      introduction:
          'Africa is home to some of the most amazing animals in the world. '
          'Today, we will learn their names in English and practice describing them. '
          'These are important words that will help you talk about our beautiful continent.',
      cours: 'AFRICAN ANIMALS — ANIMAUX AFRICAINS\n\n'
          '• lion → lion\n'
          '• elephant → éléphant\n'
          '• giraffe → girafe\n'
          '• hippopotamus (hippo) → hippopotame\n'
          '• crocodile → crocodile\n'
          '• zebra → zèbre\n'
          '• antelope → antilope\n'
          '• monkey → singe\n'
          '• snake → serpent\n'
          '• eagle → aigle\n'
          '• donkey → âne\n'
          '• cow → vache\n'
          '• goat → chèvre\n'
          '• sheep → mouton\n\n'
          'DESCRIBING ANIMALS — DÉCRIRE LES ANIMAUX\n\n'
          'Adjectives / Adjectifs :\n'
          '• big / small → grand / petit\n'
          '• fast / slow → rapide / lent\n'
          '• strong → fort\n'
          '• dangerous → dangereux\n'
          '• beautiful → beau/belle\n'
          '• wild → sauvage\n'
          '• domestic → domestique\n\n'
          'THE SIMPLE PRESENT — LE PRÉSENT SIMPLE\n\n'
          'Pour décrire des habitudes ou des faits :\n'
          '• The lion eats meat. → Le lion mange de la viande.\n'
          '• Elephants live in the savanna. → Les éléphants vivent dans la savane.\n'
          '• The cow gives milk. → La vache donne du lait.\n\n'
          'RÈGLE : Avec he/she/it → on ajoute -s au verbe\n'
          '• She runs fast. / He eats fruit. / It lives in water.',
      exemples: [
        'The elephant is big and strong. It lives in the savanna.',
        'Lions are wild and dangerous animals.',
        'Goats and sheep are domestic animals. They give us milk and meat.',
        'The eagle is a beautiful bird. It flies very high.',
      ],
      exercices: [
        'Exercise 1: Write the English name for each animal:\n'
            'a) éléphant = ___  b) girafe = ___  c) crocodile = ___  d) âne = ___',
        'Exercise 2: Describe these animals using adjectives:\n'
            'a) The lion is ___ and ___.\n'
            'b) The donkey is ___ and ___.',
        'Exercise 3: Complete with the right verb form:\n'
            'a) The crocodile ___ (live) in the river.\n'
            'b) Elephants ___ (eat) grass and leaves.\n'
            'c) The eagle ___ (fly) very high.',
        'Exercise 4: Write 3 sentences about an animal you know well.',
      ],
      corrections: [
        'Exercise 1: a) elephant b) giraffe c) crocodile d) donkey',
        'Exercise 2: a) The lion is big and dangerous/strong. '
            'b) The donkey is small and slow/strong.',
        'Exercise 3: a) lives b) eat c) flies',
        'Exercise 4: Réponse libre - exemple: '
            'The goat is a domestic animal. It eats grass. It gives us milk.',
      ],
      conclusion: 'Well done! You now know many African animals in English. '
          'Africa has wonderful wildlife. Let\'s protect it! '
          'Keep practicing: try to describe animals you see around you in English.',
    ),
  ];

  // ================================================================
  // COLLÈGE — FRANÇAIS
  // ================================================================
  static const _collegeFrancais = [
    OfflineLesson(
      id: 'fr_6e_01',
      matiere: 'Français',
      niveau: '6e-5e',
      titre: 'Le récit — Comprendre et analyser un texte narratif',
      objectifs: [
        'Identifier les caractéristiques d\'un texte narratif',
        'Analyser la structure d\'un récit',
        'Distinguer narrateur, personnages et actions',
      ],
      introduction: 'Un récit est une histoire racontée par un narrateur. '
          'Les récits nous font voyager, rêver et réfléchir. '
          'En analysant un récit, on comprend mieux comment les histoires sont construites.',
      cours: 'QU\'EST-CE QU\'UN RÉCIT ?\n\n'
          'Un récit (ou texte narratif) raconte une histoire avec :\n'
          '• Des personnages (héros, personnages secondaires, antagonistes)\n'
          '• Un lieu (où se passe l\'histoire)\n'
          '• Un temps (quand se passe l\'histoire)\n'
          '• Des actions (ce qui se passe)\n\n'
          'LA STRUCTURE DU RÉCIT\n\n'
          '1. SITUATION INITIALE : présentation du cadre, des personnages, état initial\n'
          '   (tout va bien / situation normale)\n\n'
          '2. ÉLÉMENT PERTURBATEUR : un événement qui vient tout changer\n'
          '   (problème, aventure, événement inattendu)\n\n'
          '3. PÉRIPÉTIES : les aventures, obstacles et actions des personnages\n'
          '   pour résoudre le problème\n\n'
          '4. RÉSOLUTION : le problème est résolu\n\n'
          '5. SITUATION FINALE : nouvel état stable\n'
          '   (souvent différent de la situation initiale)\n\n'
          'LE NARRATEUR\n\n'
          'Qui raconte l\'histoire ?\n'
          '• Narrateur à la 1ère personne (je/nous) : le narrateur est dans l\'histoire\n'
          '  Exemple : "Je marchais dans la savane quand soudain..."\n'
          '• Narrateur à la 3ème personne (il/elle) : le narrateur est extérieur\n'
          '  Exemple : "Aminata marchait dans la savane quand soudain..."\n\n'
          'LES TEMPS DU RÉCIT\n\n'
          'Dans un récit au passé, on utilise principalement :\n'
          '• Le passé simple : pour les actions principales\n'
          '  Exemple : "Il courut, il tomba, il se releva."\n'
          '• L\'imparfait : pour les descriptions et habitudes\n'
          '  Exemple : "Le soleil brillait. Les oiseaux chantaient."',
      exemples: [
        'Situation initiale : "Il était une fois un jeune berger qui gardait ses moutons près du village..."',
        'Élément perturbateur : "Un soir, il remarqua qu\'un mouton avait disparu..."',
        'Péripétie : "Il chercha dans toute la savane, interrogea les voisins..."',
        'Résolution : "Finalement, il retrouva le mouton sous un baobab..."',
        'Situation finale : "Depuis ce jour, le berger comptait ses moutons deux fois par jour."',
      ],
      exercices: [
        'Exercice 1 : Lis ce récit et identifie les 5 étapes de la structure narrative :\n'
            '"Kouamé était un pêcheur heureux. Un matin, sa pirogue disparut. '
            'Il interrogea tout le village. Son ami Mamadou lui dit qu\'il l\'avait vue dériver. '
            'Ensemble, ils la retrouvèrent au bord du fleuve. Kouamé put reprendre sa pêche."',
        'Exercice 2 : Ce récit est-il à la 1ère ou 3ème personne ?\n'
            '"Je me promenais au marché quand j\'entendis une voix familière..."',
        'Exercice 3 : Identifie l\'imparfait et le passé simple dans cette phrase :\n'
            '"Le soleil brillait quand Salimata arriva au puits."',
        'Exercice 4 : Écris une situation initiale pour un récit qui se passe dans ton village.',
      ],
      corrections: [
        'Exercice 1 : SI: Kouamé était un pêcheur heureux. '
            'EP: sa pirogue disparut. Péripéties: Il interrogea... Mamadou lui dit... '
            'Résolution: ils la retrouvèrent. SF: Kouamé put reprendre sa pêche.',
        'Exercice 2 : 1ère personne (je)',
        'Exercice 3 : Imparfait: brillait. Passé simple: arriva.',
        'Exercice 4 : Réponse personnelle',
      ],
      conclusion:
          'Analyser un récit te permet de mieux comprendre les textes que tu lis '
          'et de mieux écrire tes propres histoires. '
          'La structure en 5 étapes est un outil précieux pour tout écrivain !',
    ),
    OfflineLesson(
      id: 'fr_4e_01',
      matiere: 'Français',
      niveau: '4e',
      titre: 'La poésie — Figures de style et versification',
      objectifs: [
        'Identifier les principales figures de style',
        'Analyser la structure d\'un poème',
        'Comprendre les effets poétiques',
      ],
      introduction:
          'La poésie est un art du langage qui joue avec les sons, les images et les émotions. '
          'Les poètes utilisent des figures de style pour créer des images puissantes '
          'et exprimer ce que la prose ordinaire ne peut pas dire.',
      cours: 'LES FIGURES DE STYLE\n\n'
          '1. LA COMPARAISON\n'
          'Elle compare deux éléments à l\'aide d\'un outil de comparaison '
          '(comme, tel, semblable à, pareil à...)\n'
          'Exemple : "Il est fort comme un lion."\n\n'
          '2. LA MÉTAPHORE\n'
          'Comparaison SANS outil de comparaison.\n'
          'Exemple : "Ce garçon est un lion." (= il est fort comme un lion)\n\n'
          '3. LA PERSONNIFICATION\n'
          'On attribue des caractéristiques humaines à un objet ou animal.\n'
          'Exemple : "Le vent gémit dans les arbres." (le vent ne peut pas gémir)\n\n'
          '4. L\'HYPERBOLE\n'
          'Exagération pour produire un effet.\n'
          'Exemple : "Il pleuvait des cordes." / "J\'ai attendu une éternité."\n\n'
          '5. L\'ANAPHORE\n'
          'Répétition d\'un mot ou groupe de mots au début de plusieurs vers.\n'
          'Exemple : "Africa! Africa! Africa!" (Léopold Sédar Senghor)\n\n'
          '6. L\'ALLITÉRATION\n'
          'Répétition du même son consonantique.\n'
          'Exemple : "Pour qui sont ces serpents qui sifflent sur vos têtes ?"\n\n'
          'LA VERSIFICATION\n\n'
          '• Le vers : une ligne de poème\n'
          '• La strophe : groupe de vers (quatrain=4 vers, tercet=3 vers)\n'
          '• La rime : sons identiques à la fin des vers\n'
          '  - Rimes plates : AABB\n'
          '  - Rimes croisées : ABAB\n'
          '  - Rimes embrassées : ABBA\n'
          '• L\'alexandrin : vers de 12 syllabes (versification classique)',
      exemples: [
        'Comparaison : "L\'Afrique est belle comme une reine parée de savanes."',
        'Métaphore : "Le Sahara est la mer de sable qui noie les caravanes."',
        'Personnification : "Le baobab tend les bras vers le ciel comme un vieux sage."',
        'Anaphore : "Terre de mes pères, terre de mes rêves, terre de ma vie."',
      ],
      exercices: [
        'Exercice 1 : Identifie la figure de style :\n'
            'a) "Il rugit comme un lion blessé."\n'
            'b) "La lune est une lampe argentée."\n'
            'c) "La rivière chante dans les pierres."\n'
            'd) "J\'ai vu cela mille fois."',
        'Exercice 2 : Lis ce poème et identifie le schéma de rimes :\n'
            '"Le baobab majestueux (A)\n'
            'Etend ses bras vers le ciel (B)\n'
            'Sous le soleil radieux (A)\n'
            'Il offre son ombre fidèle." (B)',
        'Exercice 3 : Écris une comparaison et une métaphore sur un animal africain.',
        'Exercice 4 : Transforme cette comparaison en métaphore :\n'
            '"Aminata est belle comme la lune."',
      ],
      corrections: [
        'Exercice 1 : a) comparaison b) métaphore c) personnification d) hyperbole',
        'Exercice 2 : Rimes croisées ABAB',
        'Exercice 3 : Réponse libre',
        'Exercice 4 : "Aminata est la lune." ou "Aminata est une lune radieuse."',
      ],
      conclusion:
          'Les figures de style enrichissent le langage et lui donnent de la puissance. '
          'De grands poètes africains comme Léopold Sédar Senghor ou Birago Diop '
          'ont utilisé ces techniques pour chanter la beauté de l\'Afrique. '
          'À toi d\'écrire ta propre poésie !',
    ),
    OfflineLesson(
      id: 'fr_3e_01',
      matiere: 'Français',
      niveau: '3e',
      titre: 'L\'argumentation — Rédiger un texte argumentatif',
      objectifs: [
        'Identifier la structure d\'un texte argumentatif',
        'Formuler une thèse et des arguments',
        'Utiliser les connecteurs logiques',
      ],
      introduction:
          'Argumenter, c\'est défendre un point de vue avec des preuves et des exemples. '
          'Cette compétence est essentielle pour le brevet, mais aussi dans la vie quotidienne : '
          'pour convaincre, débattre, ou rédiger une lettre.',
      cours: 'LA STRUCTURE D\'UN TEXTE ARGUMENTATIF\n\n'
          '1. L\'INTRODUCTION\n'
          '• Présentation du sujet (amener le sujet)\n'
          '• Problématique (la question centrale)\n'
          '• Annonce du plan\n\n'
          '2. LE DÉVELOPPEMENT\n'
          'Chaque paragraphe contient :\n'
          '• Une idée principale (argument)\n'
          '• Des preuves / exemples\n'
          '• Une mini-conclusion\n\n'
          '3. LA CONCLUSION\n'
          '• Bilan des arguments\n'
          '• Réponse à la problématique\n'
          '• Ouverture sur une question plus large\n\n'
          'LES CONNECTEURS LOGIQUES\n\n'
          'Pour ajouter : de plus, en outre, également, par ailleurs\n'
          'Pour opposer : mais, cependant, toutefois, en revanche, néanmoins\n'
          'Pour illustrer : par exemple, ainsi, c\'est le cas de\n'
          'Pour conclure : en conclusion, ainsi, donc, c\'est pourquoi\n'
          'Pour cause/conséquence : car, parce que, donc, c\'est pourquoi\n\n'
          'LA THÈSE ET L\'ANTITHÈSE\n\n'
          'Thèse : ton point de vue, ce que tu défends\n'
          'Antithèse : le point de vue opposé (qu\'on peut réfuter)\n'
          'Synthèse : position nuancée qui tient compte des deux\n\n'
          'LES TYPES D\'ARGUMENTS\n\n'
          '• Argument logique : basé sur la raison\n'
          '• Argument d\'autorité : citation d\'expert\n'
          '• Argument d\'exemple : cas concret\n'
          '• Argument affectif : appel aux émotions',
      exemples: [
        'Sujet : "L\'éducation des filles est-elle importante en Afrique ?"\n'
            'Thèse : Oui, l\'éducation des filles est fondamentale.\n'
            'Argument 1 : Une fille éduquée contribue mieux au développement de son pays.\n'
            'Argument 2 : L\'éducation permet aux filles d\'être économiquement indépendantes.\n'
            'Argument 3 : Une mère éduquée élève des enfants en meilleure santé.',
      ],
      exercices: [
        'Exercice 1 : Identifie les connecteurs logiques dans ce texte :\n'
            '"L\'école est importante car elle forme les citoyens. De plus, elle permet '
            'de trouver un emploi. Cependant, certains enfants ne peuvent pas y accéder. '
            'C\'est pourquoi l\'État doit rendre l\'éducation gratuite pour tous."',
        'Exercice 2 : Donne 2 arguments pour défendre cette thèse :\n'
            '"Les téléphones portables devraient être interdits à l\'école."',
        'Exercice 3 : Rédige un paragraphe argumentatif (thèse + argument + exemple + conclusion)\n'
            'sur le sujet : "La lecture est-elle utile pour les jeunes ?"',
      ],
      corrections: [
        'Exercice 1 : car (cause), De plus (addition), Cependant (opposition), '
            'C\'est pourquoi (conséquence)',
        'Exercice 2 : Exemples d\'arguments : Les téléphones distraient les élèves / '
            'Ils favorisent la triche / Ils nuisent à la concentration.',
        'Exercice 3 : Réponse personnelle',
      ],
      conclusion: 'L\'argumentation est un art qui s\'apprend et se pratique. '
          'Pour le brevet, entraîne-toi à structurer tes idées, '
          'à trouver des exemples concrets et à utiliser les connecteurs logiques. '
          'Un bon argument est clair, précis et bien illustré !',
    ),
  ];

  // ================================================================
  // COLLÈGE — MATHÉMATIQUES
  // ================================================================
  static const _collegeMaths = [
    OfflineLesson(
      id: 'ma_6e_01',
      matiere: 'Mathématiques',
      niveau: '6e-5e',
      titre: 'Les fractions — Notions et opérations de base',
      objectifs: [
        'Comprendre ce qu\'est une fraction',
        'Comparer et simplifier des fractions',
        'Additionner et soustraire des fractions simples',
      ],
      introduction:
          'Les fractions nous permettent d\'exprimer des parties d\'un tout. '
          'Quand tu coupes une orange en 4 parts et tu en manges 1, '
          'tu as mangé 1/4 de l\'orange. Les fractions sont partout dans la vie quotidienne !',
      cours: 'QU\'EST-CE QU\'UNE FRACTION ?\n\n'
          'Une fraction s\'écrit : numérateur / dénominateur\n'
          '• Le dénominateur : combien de parts égales on a divisé le tout\n'
          '• Le numérateur : combien de parts on prend\n\n'
          'Exemple : 3/4\n'
          '• Dénominateur = 4 (divisé en 4 parts)\n'
          '• Numérateur = 3 (on prend 3 parts)\n\n'
          'TYPES DE FRACTIONS\n\n'
          '• Fraction propre : numérateur < dénominateur → 3/4\n'
          '• Fraction impropre : numérateur > dénominateur → 5/3\n'
          '• Nombre mixte : 1 entier + fraction → 1 2/3\n\n'
          'FRACTIONS ÉQUIVALENTES\n\n'
          'Deux fractions sont équivalentes si elles représentent la même quantité.\n'
          '1/2 = 2/4 = 3/6 = 4/8\n'
          'On multiplie (ou divise) numérateur et dénominateur par le même nombre.\n\n'
          'SIMPLIFIER UNE FRACTION\n\n'
          'Diviser numérateur et dénominateur par leur PGCD.\n'
          'Exemple : 6/8 → PGCD(6,8)=2 → 6÷2 / 8÷2 = 3/4\n\n'
          'COMPARER DES FRACTIONS\n\n'
          'Même dénominateur : on compare les numérateurs\n'
          '3/7 < 5/7 car 3 < 5\n\n'
          'Dénominateurs différents : on met au même dénominateur\n'
          '1/3 et 1/4 → 4/12 et 3/12 → 4/12 > 3/12 donc 1/3 > 1/4\n\n'
          'ADDITION ET SOUSTRACTION DE FRACTIONS\n\n'
          'Même dénominateur :\n'
          '2/5 + 1/5 = 3/5 (on additionne les numérateurs)\n\n'
          'Dénominateurs différents : on cherche le dénominateur commun\n'
          '1/3 + 1/4 = 4/12 + 3/12 = 7/12',
      exemples: [
        'Partage : une pizza coupée en 8 parts. Tu en manges 3 → 3/8 de la pizza',
        '6/9 simplifié : PGCD(6,9)=3 → 6÷3 / 9÷3 = 2/3',
        'Comparer 2/3 et 3/4 : 8/12 et 9/12 → 2/3 < 3/4',
        '1/2 + 1/3 = 3/6 + 2/6 = 5/6',
      ],
      exercices: [
        'Exercice 1 : Simplifie ces fractions :\n'
            'a) 4/6 = ___  b) 10/15 = ___  c) 12/18 = ___',
        'Exercice 2 : Compare avec < ou > :\n'
            'a) 3/5 ___ 4/5\n'
            'b) 1/2 ___ 1/3\n'
            'c) 2/3 ___ 3/4',
        'Exercice 3 : Calcule :\n'
            'a) 2/7 + 3/7 = ___\n'
            'b) 1/2 + 1/4 = ___\n'
            'c) 3/4 - 1/3 = ___',
        'Exercice 4 : Problème :\n'
            'Aminata a bu 1/3 d\'une bouteille d\'eau le matin et 1/4 l\'après-midi.\n'
            'Quelle fraction de la bouteille a-t-elle bue en tout ?',
      ],
      corrections: [
        'Exercice 1 : a) 2/3 b) 2/3 c) 2/3',
        'Exercice 2 : a) < b) > c) <',
        'Exercice 3 : a) 5/7 b) 3/4 c) 9/12 - 4/12 = 5/12',
        'Exercice 4 : 1/3 + 1/4 = 4/12 + 3/12 = 7/12 de la bouteille',
      ],
      conclusion: 'Les fractions sont fondamentales en mathématiques. '
          'Elles reviennent dans les proportions, les pourcentages et les probabilités. '
          'Maîtrise bien la simplification et la mise au même dénominateur !',
    ),
    OfflineLesson(
      id: 'ma_4e_01',
      matiere: 'Mathématiques',
      niveau: '4e',
      titre: 'Les équations du premier degré',
      objectifs: [
        'Comprendre ce qu\'est une équation',
        'Résoudre des équations du premier degré',
        'Appliquer les équations à des problèmes concrets',
      ],
      introduction:
          'Une équation, c\'est comme une balance : les deux côtés doivent être égaux. '
          'Si tu ajoutes ou enlèves quelque chose d\'un côté, tu dois faire pareil de l\'autre. '
          'Les équations permettent de résoudre des problèmes inconnus.',
      cours: 'QU\'EST-CE QU\'UNE ÉQUATION ?\n\n'
          'Une équation est une égalité qui contient une inconnue (souvent x).\n'
          'Exemple : 2x + 5 = 13\n\n'
          'Résoudre une équation = trouver la valeur de x qui rend l\'égalité vraie.\n\n'
          'RÈGLES DE BASE\n\n'
          'On peut faire la même opération des DEUX côtés de l\'égalité :\n'
          '• Ajouter le même nombre\n'
          '• Soustraire le même nombre\n'
          '• Multiplier par le même nombre (non nul)\n'
          '• Diviser par le même nombre (non nul)\n\n'
          'MÉTHODE DE RÉSOLUTION\n\n'
          'Exemple : 3x + 7 = 22\n\n'
          'Étape 1 : Isoler les termes avec x d\'un côté\n'
          '3x + 7 - 7 = 22 - 7\n'
          '3x = 15\n\n'
          'Étape 2 : Diviser par le coefficient de x\n'
          '3x ÷ 3 = 15 ÷ 3\n'
          'x = 5\n\n'
          'Étape 3 : VÉRIFICATION (toujours !)\n'
          '3×5 + 7 = 15 + 7 = 22 ✓\n\n'
          'ÉQUATIONS AVEC x DES DEUX CÔTÉS\n\n'
          'Exemple : 5x - 3 = 2x + 9\n'
          '5x - 2x = 9 + 3\n'
          '3x = 12\n'
          'x = 4\n\n'
          'Vérification : 5×4 - 3 = 17 et 2×4 + 9 = 17 ✓',
      exemples: [
        'x + 8 = 15 → x = 15 - 8 = 7',
        '2x = 14 → x = 14 ÷ 2 = 7',
        '4x - 5 = 19 → 4x = 24 → x = 6',
        'Problème : Un père a 3 fois l\'âge de son fils. La somme de leurs âges est 48 ans.\n'
            'Fils = x, Père = 3x → x + 3x = 48 → 4x = 48 → x = 12 ans',
      ],
      exercices: [
        'Exercice 1 : Résous ces équations :\n'
            'a) x + 12 = 20\n'
            'b) 3x = 21\n'
            'c) 2x + 5 = 17',
        'Exercice 2 : Résous et vérifie :\n'
            'a) 5x - 8 = 27\n'
            'b) 4x + 3 = 2x + 11',
        'Exercice 3 : Problème :\n'
            'Adama a 250 FCFA de plus que Salimata. Ensemble, ils ont 750 FCFA.\n'
            'Combien Salimata a-t-elle ?',
        'Exercice 4 : Un rectangle a une longueur égale à (2x+3) cm et une largeur de x cm.\n'
            'Son périmètre est 36 cm. Trouve les dimensions.',
      ],
      corrections: [
        'Exercice 1 : a) x=8 b) x=7 c) x=6',
        'Exercice 2 : a) 5x=35, x=7. Vérif: 5×7-8=27✓  b) 2x=8, x=4',
        'Exercice 3 : Salimata=x, Adama=x+250. x+(x+250)=750. 2x=500. x=250 FCFA',
        'Exercice 4 : P=2(l+L)=36 → l+L=18. x+(2x+3)=18 → 3x=15 → x=5. '
            'Largeur=5cm, Longueur=13cm',
      ],
      conclusion: 'Les équations sont un outil puissant des mathématiques. '
          'Retiens bien la règle d\'or : ce qu\'on fait d\'un côté, '
          'on le fait de l\'autre. Et n\'oublie jamais de vérifier ta solution !',
    ),
    OfflineLesson(
      id: 'ma_3e_01',
      matiere: 'Mathématiques',
      niveau: '3e',
      titre: 'Le théorème de Pythagore',
      objectifs: [
        'Énoncer le théorème de Pythagore',
        'Appliquer le théorème pour calculer une longueur',
        'Utiliser la réciproque pour vérifier si un triangle est rectangle',
      ],
      introduction:
          'Le théorème de Pythagore est l\'un des théorèmes les plus célèbres des mathématiques. '
          'Découvert par le mathématicien grec Pythagore au VIe siècle avant J.-C., '
          'il est encore utilisé aujourd\'hui dans la construction, l\'architecture et la géographie.',
      cours: 'LE THÉORÈME DE PYTHAGORE\n\n'
          'Dans un triangle rectangle :\n'
          '(hypoténuse)² = (côté 1)² + (côté 2)²\n\n'
          'L\'hypoténuse est le côté opposé à l\'angle droit. '
          'C\'est TOUJOURS le côté le plus long.\n\n'
          'Si le triangle ABC a un angle droit en C :\n'
          'AB² = AC² + BC²\n\n'
          'COMMENT CALCULER UNE LONGUEUR INCONNUE\n\n'
          'Cas 1 : Trouver l\'hypoténuse (AB)\n'
          'AB² = AC² + BC²\n'
          'AB = √(AC² + BC²)\n\n'
          'Exemple : AC=3cm, BC=4cm\n'
          'AB² = 3² + 4² = 9 + 16 = 25\n'
          'AB = √25 = 5 cm\n\n'
          'Cas 2 : Trouver un côté (AC)\n'
          'AC² = AB² - BC²\n'
          'AC = √(AB² - BC²)\n\n'
          'Exemple : AB=10cm, BC=8cm\n'
          'AC² = 10² - 8² = 100 - 64 = 36\n'
          'AC = √36 = 6 cm\n\n'
          'LA RÉCIPROQUE DU THÉORÈME\n\n'
          'Si AB² = AC² + BC², alors le triangle ABC est rectangle en C.\n\n'
          'Exemple : AB=5, AC=3, BC=4\n'
          '5² = 25 et 3²+4² = 9+16 = 25\n'
          'Donc le triangle est rectangle en C ✓\n\n'
          'TRIPLETS PYTHAGORICIENS CÉLÈBRES :\n'
          '(3, 4, 5) — (5, 12, 13) — (8, 15, 17) — (6, 8, 10)',
      exemples: [
        'Construction : Une échelle de 5m est appuyée contre un mur. '
            'Son pied est à 3m du mur. À quelle hauteur touche-t-elle le mur ?\n'
            'h² = 5² - 3² = 25-9 = 16 → h = 4m',
        'Navigation : Un bateau va 6km vers l\'est, puis 8km vers le nord. '
            'Distance directe = √(36+64) = √100 = 10km',
      ],
      exercices: [
        'Exercice 1 : Le triangle ABC est rectangle en C. Calcule la longueur manquante :\n'
            'a) AC=6cm, BC=8cm → AB=?\n'
            'b) AB=13cm, BC=5cm → AC=?\n'
            'c) AB=15cm, AC=9cm → BC=?',
        'Exercice 2 : Détermine si ces triangles sont rectangles :\n'
            'a) AB=10, AC=6, BC=8\n'
            'b) AB=7, AC=5, BC=4',
        'Exercice 3 : Problème concret :\n'
            'Un terrain rectangulaire mesure 30m de long et 40m de large.\n'
            'Quelle est la longueur de sa diagonale ?',
      ],
      corrections: [
        'Exercice 1 : a) AB²=36+64=100, AB=10cm '
            'b) AC²=169-25=144, AC=12cm '
            'c) BC²=225-81=144, BC=12cm',
        'Exercice 2 : a) 10²=100 et 6²+8²=36+64=100 → OUI rectangle '
            'b) 7²=49 et 5²+4²=25+16=41 ≠ 49 → NON',
        'Exercice 3 : d²=30²+40²=900+1600=2500, d=50m',
      ],
      conclusion:
          'Le théorème de Pythagore est un outil indispensable en géométrie. '
          'Memorise bien les triplets pythagoriciens (3,4,5) et (5,12,13) — '
          'ils apparaissent souvent dans les examens. '
          'Et n\'oublie : l\'hypoténuse est TOUJOURS le côté le plus long !',
    ),
  ];

  // ================================================================
  // COLLÈGE — SVT
  // ================================================================
  static const _collegeSVT = [
    OfflineLesson(
      id: 'svt_6e_01',
      matiere: 'SVT',
      niveau: '6e-5e',
      titre: 'La cellule — Unité de base du vivant',
      objectifs: [
        'Comprendre que tout être vivant est composé de cellules',
        'Identifier les structures d\'une cellule animale et végétale',
        'Distinguer cellule procaryote et eucaryote',
      ],
      introduction: 'Toute vie sur Terre est construite à partir de cellules. '
          'De la bactérie invisible à l\'œil nu jusqu\'à l\'éléphant géant, '
          'tout être vivant est fait de cellules. Comprendre la cellule, '
          'c\'est comprendre le fondement de la vie.',
      cours: 'QU\'EST-CE QU\'UNE CELLULE ?\n\n'
          'La cellule est l\'unité structurale et fonctionnelle du vivant.\n'
          '• Un être unicellulaire = formé d\'UNE seule cellule (bactérie, amibe)\n'
          '• Un être pluricellulaire = formé de PLUSIEURS cellules (plante, animal, homme)\n'
          'Le corps humain contient environ 37 000 milliards de cellules !\n\n'
          'LA CELLULE ANIMALE\n\n'
          'Elle est composée de :\n'
          '• La membrane plasmique : enveloppe de la cellule, laisse entrer/sortir les substances\n'
          '• Le cytoplasme : liquide gélatineux qui remplit la cellule\n'
          '• Le noyau : "cerveau" de la cellule, contient l\'ADN (les informations génétiques)\n'
          '• Les mitochondries : "usines énergétiques" de la cellule\n\n'
          'LA CELLULE VÉGÉTALE\n\n'
          'Elle a en PLUS de la cellule animale :\n'
          '• La paroi cellulaire : coque rigide autour de la membrane (donne la rigidité aux plantes)\n'
          '• Les chloroplastes : contiennent la chlorophylle (photosynthèse)\n'
          '• Une grande vacuole : stocke l\'eau et les réserves\n\n'
          'CELLULES PROCARYOTES vs EUCARYOTES\n\n'
          'Procaryotes (bactéries) :\n'
          '• Pas de noyau délimité par une membrane\n'
          '• Très petites (1-10 micromètres)\n'
          '• Exemples : E. coli, staphylocoque\n\n'
          'Eucaryotes (animaux, plantes, champignons) :\n'
          '• Noyau délimité par une membrane\n'
          '• Plus grandes (10-100 micromètres)',
      exemples: [
        'La cellule sanguine (globule rouge) transporte l\'oxygène dans tout le corps',
        'La cellule musculaire est allongée pour permettre la contraction',
        'La cellule végétale du feuille est riche en chloroplastes pour la photosynthèse',
      ],
      exercices: [
        'Exercice 1 : Vrai ou Faux ?\n'
            'a) Toutes les cellules ont un noyau délimité par une membrane.\n'
            'b) Les plantes ont des cellules avec des chloroplastes.\n'
            'c) Le corps humain est unicellulaire.',
        'Exercice 2 : Cite les structures présentes dans la cellule végétale mais PAS dans la cellule animale.',
        'Exercice 3 : Complète le tableau :\n'
            'Structure | Cellule animale | Cellule végétale\n'
            'Membrane plasmique | ___ | ___\n'
            'Noyau | ___ | ___\n'
            'Chloroplastes | ___ | ___\n'
            'Paroi cellulaire | ___ | ___',
        'Exercice 4 : Pourquoi les feuilles sont-elles vertes ?',
      ],
      corrections: [
        'Exercice 1 : a) Faux (les procaryotes n\'en ont pas) b) Vrai c) Faux (pluricellulaire)',
        'Exercice 2 : Paroi cellulaire, chloroplastes, grande vacuole',
        'Exercice 3 : Membrane: Oui/Oui. Noyau: Oui/Oui. Chloroplastes: Non/Oui. Paroi: Non/Oui.',
        'Exercice 4 : Car les cellules végétales contiennent de la chlorophylle (dans les chloroplastes), '
            'un pigment vert qui capte la lumière solaire.',
      ],
      conclusion:
          'La cellule est le "bloc de construction" de tout être vivant. '
          'En comprenant sa structure, on comprend comment les organismes fonctionnent. '
          'La biologie cellulaire est à la base de la médecine moderne !',
    ),
    OfflineLesson(
      id: 'svt_4e_01',
      matiere: 'SVT',
      niveau: '4e',
      titre: 'La reproduction humaine',
      objectifs: [
        'Décrire les appareils reproducteurs masculin et féminin',
        'Comprendre les étapes de la fécondation',
        'Connaître le développement du fœtus',
      ],
      introduction:
          'La reproduction est une fonction fondamentale du vivant qui assure '
          'la continuité des espèces. Comprendre la reproduction humaine, '
          'c\'est aussi comprendre les responsabilités qui y sont liées.',
      cours: 'L\'APPAREIL REPRODUCTEUR MASCULIN\n\n'
          '• Les testicules : produisent les spermatozoïdes et la testostérone\n'
          '• L\'épididyme : stockage et maturation des spermatozoïdes\n'
          '• Les canaux déférents : transportent les spermatozoïdes\n'
          '• La prostate et les vésicules séminales : produisent le liquide séminal\n'
          '• Le pénis : organe d\'union et d\'émission de l\'urine\n\n'
          'La production de spermatozoïdes commence à la puberté (vers 12-14 ans).\n'
          'Un spermatozoïde : très petit, avec une tête et une queue (flagelle) pour nager.\n\n'
          'L\'APPAREIL REPRODUCTEUR FÉMININ\n\n'
          '• Les ovaires : produisent les ovules et les hormones (œstrogènes, progestérone)\n'
          '• Les trompes de Fallope : conduisent l\'ovule vers l\'utérus\n'
          '• L\'utérus : organe où se développe le bébé\n'
          '• Le vagin : organe d\'union et voie d\'accouchement\n\n'
          'L\'OVULATION ET LE CYCLE MENSTRUEL\n\n'
          'Chaque mois, un ovule est libéré par un ovaire : c\'est l\'ovulation.\n'
          'Si l\'ovule n\'est pas fécondé, les règles (menstruations) surviennent.\n'
          'Le cycle dure environ 28 jours.\n\n'
          'LA FÉCONDATION\n\n'
          'La fécondation = union d\'un spermatozoïde et d\'un ovule.\n'
          'Elle a lieu dans les trompes de Fallope.\n'
          'La cellule-œuf formée s\'appelle le ZYGOTE.\n\n'
          'LE DÉVELOPPEMENT EMBRYONNAIRE\n\n'
          '• Semaines 1-8 : stade embryonnaire (formation des organes)\n'
          '• Semaines 9-40 : stade fœtal (croissance et développement)\n'
          '• Durée de la grossesse : 9 mois (environ 40 semaines)\n'
          '• Le fœtus est nourri par le placenta via le cordon ombilical',
      exemples: [
        'Un spermatozoïde nage à la rencontre de l\'ovule dans les trompes de Fallope',
        'Le cœur du fœtus commence à battre vers la 5ème semaine',
        'À 3 mois, le fœtus mesure environ 9 cm et pèse 14g',
      ],
      exercices: [
        'Exercice 1 : Cite 3 organes de l\'appareil reproducteur masculin et leur rôle.',
        'Exercice 2 : Qu\'est-ce que l\'ovulation ? Quand se produit-elle ?',
        'Exercice 3 : Explique ce qu\'est la fécondation et où elle se produit.',
        'Exercice 4 : Quelle est la différence entre un embryon et un fœtus ?',
      ],
      corrections: [
        'Exercice 1 : Testicules (produisent les spermatozoïdes), '
            'canaux déférents (transportent), pénis (émission)',
        'Exercice 2 : L\'ovulation est la libération d\'un ovule par un ovaire. '
            'Elle se produit environ au 14e jour du cycle.',
        'Exercice 3 : La fécondation = union d\'un spermatozoïde et d\'un ovule. '
            'Elle se produit dans les trompes de Fallope.',
        'Exercice 4 : L\'embryon est le stade des 8 premières semaines (formation des organes). '
            'Le fœtus est le stade de la 9e semaine à la naissance (croissance).',
      ],
      conclusion:
          'La reproduction humaine est un processus complexe et merveilleux. '
          'La vie humaine commence par la rencontre de deux cellules microscopiques. '
          'Il est important de comprendre ces mécanismes pour prendre soin de sa santé.',
    ),
    OfflineLesson(
      id: 'svt_3e_01',
      matiere: 'SVT',
      niveau: '3e',
      titre: 'La génétique — L\'hérédité et les lois de Mendel',
      objectifs: [
        'Comprendre la notion d\'hérédité',
        'Connaître les lois de Mendel',
        'Utiliser un tableau de croisement (échiquier de Punnett)',
      ],
      introduction:
          'Pourquoi ressembles-tu à tes parents ? Pourquoi as-tu les yeux de ton père '
          'et le sourire de ta mère ? La réponse est dans tes gènes ! '
          'La génétique étudie la transmission des caractères héréditaires.',
      cours: 'VOCABULAIRE DE BASE\n\n'
          '• Gène : portion d\'ADN qui détermine un caractère (couleur des yeux, groupe sanguin...)\n'
          '• Allèle : forme particulière d\'un gène\n'
          '  Exemple : le gène couleur des yeux peut avoir l\'allèle "yeux bruns" ou "yeux bleus"\n'
          '• Génotype : composition génétique d\'un individu (AA, Aa, aa)\n'
          '• Phénotype : caractère visible (yeux bruns, yeux bleus)\n'
          '• Homozygote : deux allèles identiques (AA ou aa)\n'
          '• Hétérozygote : deux allèles différents (Aa)\n\n'
          'ALLÈLE DOMINANT ET RÉCESSIF\n\n'
          '• Allèle dominant (noté en majuscule A) : s\'exprime même en un seul exemplaire\n'
          '• Allèle récessif (noté en minuscule a) : ne s\'exprime que si présent en double (aa)\n\n'
          'Exemple avec la couleur des yeux :\n'
          '• A = yeux bruns (dominant)\n'
          '• a = yeux bleus (récessif)\n'
          '• AA : yeux bruns (homozygote dominant)\n'
          '• Aa : yeux bruns (hétérozygote - phénotype brun car A dominant)\n'
          '• aa : yeux bleus (homozygote récessif)\n\n'
          'L\'ÉCHIQUIER DE PUNNETT\n\n'
          'Croisement de deux hétérozygotes Aa × Aa :\n\n'
          '       A        a\n'
          '  A  | AA    |  Aa  |\n'
          '  a  | Aa    |  aa  |\n\n'
          'Résultats : 1AA + 2Aa + 1aa\n'
          'Phénotypes : 3 yeux bruns (AA + 2Aa) + 1 yeux bleus (aa)\n'
          'Ratio phénotypique : 3/4 bruns ; 1/4 bleus\n\n'
          'LES LOIS DE MENDEL\n\n'
          '1ère loi : Loi d\'uniformité → croisement AA × aa → tous Aa (phénotype dominant)\n'
          '2ème loi : Loi de ségrégation → croisement Aa × Aa → 3 dominants pour 1 récessif',
      exemples: [
        'Groupe sanguin : A, B, O sont des allèles différents du même gène',
        'La drépanocytose est une maladie récessive : les parents Aa sont porteurs sains',
        'Croisement AA × aa → 100% Aa (loi d\'uniformité de Mendel)',
      ],
      exercices: [
        'Exercice 1 : Définit les termes : génotype, phénotype, allèle dominant.',
        'Exercice 2 : Un homme (Aa) épouse une femme (Aa). '
            'Réalise l\'échiquier de Punnett et donne les proportions des phénotypes.',
        'Exercice 3 : La drépanocytose est due à un allèle récessif (s). '
            'Les parents sains sont tous deux porteurs (Ss).\n'
            'a) Quel est le risque pour leur enfant d\'être malade (ss) ?\n'
            'b) Quel est le risque d\'être porteur sain ?',
      ],
      corrections: [
        'Exercice 1 : Génotype = composition en allèles (ex: Aa). '
            'Phénotype = caractère visible. '
            'Dominant = s\'exprime même en un seul exemplaire.',
        'Exercice 2 : 1/4 AA, 2/4 Aa, 1/4 aa → 3/4 phénotype dominant, 1/4 récessif',
        'Exercice 3 : a) 1/4 = 25% de risque d\'être malade (ss) '
            'b) 2/4 = 50% de risque d\'être porteur sain (Ss)',
      ],
      conclusion:
          'La génétique explique pourquoi les enfants ressemblent à leurs parents. '
          'Elle a des applications importantes en médecine pour prévoir les maladies héréditaires. '
          'Les lois de Mendel, découvertes au XIXe siècle, restent fondamentales !',
    ),
  ];

  // ================================================================
  // COLLÈGE — HISTOIRE-GÉOGRAPHIE
  // ================================================================
  static const _collegeHistoireGeo = [
    OfflineLesson(
      id: 'hg_6e_01',
      matiere: 'Histoire-Géographie',
      niveau: '6e-5e',
      titre: 'La colonisation de l\'Afrique — Causes et conséquences',
      objectifs: [
        'Comprendre les causes de la colonisation africaine',
        'Identifier les grandes puissances coloniales',
        'Analyser les conséquences de la colonisation',
      ],
      introduction:
          'À la fin du XIXe siècle, les puissances européennes se sont partagé l\'Afrique '
          'lors de la Conférence de Berlin (1884-1885). Cette période de colonisation '
          'a profondément marqué l\'histoire du continent africain.',
      cours: 'LES CAUSES DE LA COLONISATION\n\n'
          '1. CAUSES ÉCONOMIQUES\n'
          '• Recherche de matières premières : or, caoutchouc, coton, arachides\n'
          '• Débouchés commerciaux pour les industries européennes\n'
          '• Main-d\'œuvre bon marché\n\n'
          '2. CAUSES POLITIQUES\n'
          '• Rivalités entre nations européennes (France vs Angleterre vs Allemagne)\n'
          '• Prestige national et puissance militaire\n\n'
          '3. CAUSES IDÉOLOGIQUES\n'
          '• "Mission civilisatrice" : prétexte pour imposer la culture européenne\n'
          '• Diffusion du christianisme\n\n'
          'LA CONFÉRENCE DE BERLIN (1884-1885)\n\n'
          '14 pays européens se réunissent pour se partager l\'Afrique.\n'
          'Aucun Africain n\'est invité à cette conférence !\n'
          'Résultat : le "Partage de l\'Afrique" (Scramble for Africa)\n\n'
          'LES GRANDES PUISSANCES COLONIALES\n\n'
          '• France : Afrique de l\'Ouest, Afrique centrale, Madagascar\n'
          '• Angleterre : Afrique du Sud, Kenya, Nigeria, Égypte\n'
          '• Belgique : Congo\n'
          '• Portugal : Angola, Mozambique\n'
          '• Allemagne : Cameroun, Tanzanie (jusqu\'en 1918)\n\n'
          'LE BURKINA FASO (HAUTE-VOLTA)\n\n'
          'Colonisé par la France en 1896.\n'
          'Nommé "Haute-Volta" en 1919.\n'
          'Indépendance le 5 août 1960.\n'
          'Renommé Burkina Faso le 4 août 1984.\n\n'
          'LES CONSÉQUENCES DE LA COLONISATION\n\n'
          'Conséquences négatives :\n'
          '• Destruction des structures politiques africaines\n'
          '• Exploitation économique\n'
          '• Travail forcé et impôts\n'
          '• Traçage de frontières artificielles divisant les ethnies\n\n'
          'Conséquences positives :\n'
          '• Construction d\'infrastructures (routes, écoles, hôpitaux)\n'
          '• Diffusion de l\'éducation occidentale\n'
          '• Introduction de nouvelles cultures (coton, arachide)',
      exemples: [
        'Le caoutchouc du Congo belge était exploité dans des conditions terribles',
        'La frontière entre le Burkina et le Ghana sépare le peuple Mossi en deux',
        'L\'indépendance du Burkina Faso fut proclamée le 5 août 1960',
      ],
      exercices: [
        'Exercice 1 : Cite 3 causes de la colonisation africaine.',
        'Exercice 2 : Qu\'est-ce que la Conférence de Berlin et pourquoi est-elle importante ?',
        'Exercice 3 : Quelles sont les conséquences négatives de la colonisation pour l\'Afrique ?',
        'Exercice 4 : Quand le Burkina Faso a-t-il obtenu son indépendance ? '
            'Quel était son nom colonial ?',
      ],
      corrections: [
        'Exercice 1 : Économiques (matières premières), politiques (rivalités), '
            'idéologiques (mission civilisatrice)',
        'Exercice 2 : Conférence de 14 pays européens en 1884-1885 pour se partager l\'Afrique.',
        'Exercice 3 : Destruction des structures politiques, exploitation, frontières artificielles.',
        'Exercice 4 : 5 août 1960. Nom colonial : Haute-Volta.',
      ],
      conclusion: 'La colonisation a laissé des traces profondes en Afrique. '
          'Comprendre cette histoire est essentiel pour construire un avenir meilleur. '
          'Les Africains ont résisté et ont finalement obtenu leur indépendance !',
    ),
    OfflineLesson(
      id: 'hg_4e_01',
      matiere: 'Histoire-Géographie',
      niveau: '4e',
      titre: 'La décolonisation en Afrique — Luttes et indépendances',
      objectifs: [
        'Comprendre le mouvement de décolonisation',
        'Identifier les leaders africains de l\'indépendance',
        'Analyser les défis post-indépendance',
      ],
      introduction:
          'Après la Seconde Guerre mondiale, un vent de liberté souffla sur l\'Afrique. '
          'Des leaders courageux prirent la tête des luttes pour l\'indépendance. '
          'Entre 1956 et 1965, la majorité des pays africains accédèrent à l\'indépendance.',
      cours: 'LES CAUSES DE LA DÉCOLONISATION\n\n'
          '1. La Seconde Guerre mondiale affaiblit les puissances coloniales\n'
          '2. La Charte de l\'ONU (1945) proclame le droit des peuples à disposer d\'eux-mêmes\n'
          '3. Montée des mouvements nationalistes africains\n'
          '4. Pression des États-Unis et de l\'URSS contre le colonialisme\n\n'
          'LES FORMES DE DÉCOLONISATION\n\n'
          '• Négociée (pacifique) : majorité des colonies françaises en 1960\n'
          '• Par la lutte armée : Algérie (1954-1962), Kenya, Mozambique\n\n'
          'LES GRANDS LEADERS AFRICAINS\n\n'
          '• Kwame Nkrumah (Ghana) : 1ère indépendance d\'Afrique noire (1957)\n'
          '  "Nous préférons l\'auto-gouvernement avec le danger à la servitude dans la tranquillité."\n'
          '• Sékou Touré (Guinée) : 1er à dire NON à De Gaulle (1958)\n'
          '• Félix Houphouët-Boigny (Côte d\'Ivoire) : indépendance négociée (1960)\n'
          '• Thomas Sankara (Burkina Faso) : révolution et panafricanisme (1983-1987)\n'
          '• Nelson Mandela (Afrique du Sud) : lutte contre l\'apartheid (prix Nobel 1993)\n\n'
          'THOMAS SANKARA ET LE BURKINA FASO\n\n'
          'Le 4 août 1983, Thomas Sankara prend le pouvoir.\n'
          'Il rebaptise la Haute-Volta en "Burkina Faso" le 4 août 1984.\n'
          'Il lance des révolutions : émancipation des femmes, lutte contre la corruption,\n'
          'reboisement, vaccination massive.\n'
          'Il est assassiné le 15 octobre 1987.\n\n'
          'LES DÉFIS POST-INDÉPENDANCE\n\n'
          '• Frontières héritées de la colonisation (conflits ethniques)\n'
          '• Dépendance économique envers les anciennes métropoles\n'
          '• Coups d\'État militaires\n'
          '• Développement des infrastructures',
      exemples: [
        'Le Ghana fut le premier pays d\'Afrique noire indépendant (1957)',
        'Thomas Sankara disait : "L\'esclave qui n\'est pas capable d\'assumer sa révolte ne mérite pas que l\'on s\'apitoie sur son sort."',
        '17 pays africains accédèrent à l\'indépendance en 1960 : c\'est "l\'Année de l\'Afrique"',
      ],
      exercices: [
        'Exercice 1 : Cite 3 causes de la décolonisation africaine.',
        'Exercice 2 : Qui est Thomas Sankara et quelle est son importance pour le Burkina Faso ?',
        'Exercice 3 : Pourquoi dit-on que 1960 est "l\'Année de l\'Afrique" ?',
        'Exercice 4 : Quels sont les défis auxquels font face les pays africains après l\'indépendance ?',
      ],
      corrections: [
        'Exercice 1 : Affaiblissement des puissances coloniales, droit des peuples (ONU), '
            'montée des nationalismes',
        'Exercice 2 : Sankara était un leader révolutionnaire burkinabè (1983-1987), '
            'il rebaptisa le pays Burkina Faso et mena des réformes sociales importantes.',
        'Exercice 3 : Car 17 pays africains accédèrent à l\'indépendance cette année-là.',
        'Exercice 4 : Frontières artificielles, dépendance économique, instabilité politique.',
      ],
      conclusion:
          'La décolonisation est une page glorieuse de l\'histoire africaine. '
          'Des hommes et des femmes courageux ont sacrifié leur vie pour la liberté. '
          'Aujourd\'hui, les générations africaines ont la responsabilité de construire '
          'un continent fort et uni.',
    ),
    OfflineLesson(
      id: 'hg_3e_01',
      matiere: 'Histoire-Géographie',
      niveau: '3e',
      titre: 'La mondialisation — Enjeux et inégalités',
      objectifs: [
        'Définir la mondialisation et ses acteurs',
        'Analyser les avantages et les inégalités de la mondialisation',
        'Comprendre la place de l\'Afrique dans la mondialisation',
      ],
      introduction:
          'La mondialisation désigne l\'intensification des échanges économiques, culturels '
          'et politiques à l\'échelle mondiale. Elle crée des opportunités mais aussi '
          'de grandes inégalités entre pays riches et pays pauvres.',
      cours: 'QU\'EST-CE QUE LA MONDIALISATION ?\n\n'
          'La mondialisation = processus d\'intégration croissante des économies, '
          'des sociétés et des cultures à l\'échelle mondiale.\n\n'
          'FACTEURS DE LA MONDIALISATION\n\n'
          '• Révolution des transports : avion, porte-conteneurs\n'
          '• Révolution des télécommunications : internet, téléphones\n'
          '• Libéralisation du commerce international (OMC)\n'
          '• Rôle des firmes multinationales\n\n'
          'LES ACTEURS DE LA MONDIALISATION\n\n'
          '• Les États\n'
          '• Les firmes multinationales (FMN) : Apple, Toyota, Nestlé...\n'
          '• Les organisations internationales : ONU, FMI, Banque Mondiale, OMC\n'
          '• Les ONG (Oxfam, MSF...)\n'
          '• Les individus (migrants, touristes, internautes)\n\n'
          'LES PÔLES DE LA MONDIALISATION\n\n'
          'La "Triade" domine les échanges mondiaux :\n'
          '• Amérique du Nord (États-Unis, Canada)\n'
          '• Europe occidentale\n'
          '• Asie orientale (Japon, Chine, Corée)\n\n'
          'Les pays émergents montent en puissance :\n'
          'BRICS = Brésil, Russie, Inde, Chine, Afrique du Sud\n\n'
          'LES INÉGALITÉS DE LA MONDIALISATION\n\n'
          'Nord vs Sud :\n'
          '• Les pays du Nord concentrent la majorité des richesses\n'
          '• Les pays du Sud fournissent matières premières et main-d\'œuvre bon marché\n\n'
          'L\'AFRIQUE DANS LA MONDIALISATION\n\n'
          '• 17% de la population mondiale mais seulement 3% des échanges commerciaux\n'
          '• Richesse en ressources naturelles : pétrole, or, coltan, cacao\n'
          '• Problème : les Africains exportent des matières premières brutes '
          'et importent des produits finis (manque de valeur ajoutée)\n'
          '• Solutions : industrialisation, intégration régionale (CEDEAO, UA)',
      exemples: [
        'Le téléphone que tu utilises contient du coltan extrait au Congo',
        'Le cacao ivoirien devient le chocolat suisse vendu 10 fois plus cher',
        'Le Burkina Faso exporte de l\'or brut mais importe des bijoux en or',
      ],
      exercices: [
        'Exercice 1 : Définis la mondialisation et cite 2 facteurs qui l\'ont favorisée.',
        'Exercice 2 : Qu\'est-ce que la "Triade" ? Pourquoi est-elle importante ?',
        'Exercice 3 : Pourquoi dit-on que l\'Afrique est mal intégrée dans la mondialisation ?',
        'Exercice 4 : Donne un exemple concret de la mondialisation dans ta vie quotidienne.',
      ],
      corrections: [
        'Exercice 1 : Mondialisation = intensification des échanges mondiaux. '
            'Facteurs : internet, transports, libre-échange.',
        'Exercice 2 : La Triade = Amérique du Nord + Europe + Asie orientale. '
            'Elle concentre la majorité des échanges et des richesses mondiales.',
        'Exercice 3 : L\'Afrique exporte des matières premières brutes et représente '
            'seulement 3% des échanges mondiaux malgré 17% de la population.',
        'Exercice 4 : Réponse libre (téléphone fabriqué en Chine, vêtements du Bangladesh...)',
      ],
      conclusion: 'La mondialisation est une réalité incontournable. '
          'Elle offre des opportunités mais creuse les inégalités. '
          'Pour l\'Afrique, l\'enjeu est de passer de fournisseur de matières premières '
          'à continent industrialisé qui crée de la valeur ajoutée.',
    ),
  ];

  // ================================================================
  // COLLÈGE — ANGLAIS
  // ================================================================
  static const _collegeAnglais = [
    OfflineLesson(
      id: 'en_6e2_01',
      matiere: 'Anglais',
      niveau: '6e-5e',
      titre: 'Daily routines and the present simple',
      objectifs: [
        'Décrire sa routine quotidienne en anglais',
        'Maîtriser le présent simple',
        'Utiliser les adverbes de fréquence',
      ],
      introduction:
          'We all have daily routines — things we do every day at certain times. '
          'In English, we use the Present Simple to talk about habits and routines. '
          'Let\'s learn how to describe our day in English!',
      cours: 'THE PRESENT SIMPLE\n\n'
          'USE : for habits, routines, and general truths\n\n'
          'AFFIRMATIVE:\n'
          '• I/You/We/They + verb (base form)\n'
          '  I wake up at 6 o\'clock.\n'
          '• He/She/It + verb + -s/-es\n'
          '  She goes to school every day.\n\n'
          'NEGATIVE:\n'
          '• I/You/We/They + do not (don\'t) + verb\n'
          '  I don\'t eat meat.\n'
          '• He/She/It + does not (doesn\'t) + verb\n'
          '  He doesn\'t like vegetables.\n\n'
          'QUESTION:\n'
          '• Do + I/you/we/they + verb?\n'
          '  Do you walk to school?\n'
          '• Does + he/she/it + verb?\n'
          '  Does she speak English?\n\n'
          'SPELLING RULES (He/She/It):\n'
          '• Most verbs: add -s → work → works\n'
          '• Verbs ending in -sh, -ch, -ss, -x, -o: add -es → go → goes\n'
          '• Verbs ending in consonant+y: change y to ies → study → studies\n\n'
          'FREQUENCY ADVERBS:\n'
          'always (toujours) - usually (d\'habitude) - often (souvent)\n'
          'sometimes (parfois) - rarely (rarement) - never (jamais)\n\n'
          'Position: BEFORE the main verb, AFTER "to be"\n'
          '• I always wake up at 6. / She is never late.',
      exemples: [
        'I wake up at 6 o\'clock every morning.',
        'Aminata usually has breakfast before school.',
        'My father never drinks coffee. He always drinks tea.',
        'Do you walk to school? No, I don\'t. I take the bus.',
      ],
      exercices: [
        'Exercise 1: Write the correct form of the verb:\n'
            'a) She ___ (go) to school by bus.\n'
            'b) They ___ (not play) football on Sundays.\n'
            'c) He ___ (study) English every evening.',
        'Exercise 2: Make questions:\n'
            'a) You / eat / breakfast / every morning → ___?\n'
            'b) She / speak / French → ___?',
        'Exercise 3: Add the frequency adverb in the right place:\n'
            'a) I am late for school. (never)\n'
            'b) She eats fruit. (always)\n'
            'c) They watch TV. (sometimes)',
        'Exercise 4: Describe your daily routine in 5 sentences using the present simple.',
      ],
      corrections: [
        'Exercise 1: a) goes b) don\'t play c) studies',
        'Exercise 2: a) Do you eat breakfast every morning? b) Does she speak French?',
        'Exercise 3: a) I am never late. b) She always eats fruit. c) They sometimes watch TV.',
        'Exercise 4: Réponse personnelle',
      ],
      conclusion:
          'The present simple is one of the most important tenses in English. '
          'Remember: add -s/-es for he/she/it, use do/does for questions and negatives. '
          'Practice by describing your own daily routine!',
    ),
    OfflineLesson(
      id: 'en_4e2_01',
      matiere: 'Anglais',
      niveau: '4e',
      titre: 'The past simple — Talking about past events',
      objectifs: [
        'Former et utiliser le passé simple',
        'Distinguer verbes réguliers et irréguliers',
        'Raconter des événements passés',
      ],
      introduction:
          'When we talk about things that happened in the past and are finished, '
          'we use the Past Simple. It\'s like the "passé composé" in French. '
          'Let\'s learn how to talk about our past experiences!',
      cours: 'THE PAST SIMPLE\n\n'
          'USE: for completed actions in the past\n'
          'Time markers: yesterday, last week/month/year, ago, in 1960, when I was young...\n\n'
          'REGULAR VERBS: add -ed\n'
          '• work → worked\n'
          '• play → played\n'
          '• study → studied\n'
          '• stop → stopped\n\n'
          'IRREGULAR VERBS (must be memorized!):\n'
          '• go → went         • have → had\n'
          '• come → came       • make → made\n'
          '• see → saw         • eat → ate\n'
          '• buy → bought      • think → thought\n'
          '• take → took       • write → wrote\n'
          '• give → gave       • speak → spoke\n'
          '• get → got         • run → ran\n\n'
          'NEGATIVE: did not (didn\'t) + verb (base form)\n'
          '• I didn\'t go to school yesterday.\n'
          '• She didn\'t eat breakfast this morning.\n\n'
          'QUESTION: Did + subject + verb (base form)?\n'
          '• Did you see the match?\n'
          '• Did he come to the party?\n\n'
          'SHORT ANSWERS:\n'
          '• Did you go? Yes, I did. / No, I didn\'t.',
      exemples: [
        'Yesterday, I went to the market with my mother.',
        'Last year, Thomas Sankara Day was celebrated all over Burkina Faso.',
        'Did you watch the football match last night? Yes, I did!',
        'She didn\'t study yesterday because she was sick.',
      ],
      exercices: [
        'Exercise 1: Write the past simple:\n'
            'a) walk → ___  b) go → ___  c) eat → ___  d) study → ___',
        'Exercise 2: Put the verb in the past simple:\n'
            'a) Last Sunday, I ___ (play) football with my friends.\n'
            'b) She ___ (not come) to school yesterday.\n'
            'c) They ___ (see) a lion at the park.',
        'Exercise 3: Make past simple questions:\n'
            'a) you / visit / your grandmother / last weekend?\n'
            'b) he / buy / a new book?',
        'Exercise 4: Write about what you did last weekend (5 sentences).',
      ],
      corrections: [
        'Exercise 1: a) walked b) went c) ate d) studied',
        'Exercise 2: a) played b) didn\'t come c) saw',
        'Exercise 3: a) Did you visit your grandmother last weekend? '
            'b) Did he buy a new book?',
        'Exercise 4: Réponse personnelle',
      ],
      conclusion:
          'The Past Simple is essential for storytelling and talking about history. '
          'The key challenge is learning irregular verbs — there\'s no shortcut, '
          'you must memorize them! Make flashcards and practice every day.',
    ),
    OfflineLesson(
      id: 'en_3e2_01',
      matiere: 'Anglais',
      niveau: '3e',
      titre: 'Environment and climate change',
      objectifs: [
        'Discuter des problèmes environnementaux en anglais',
        'Utiliser le futur (will) et le conditionnel',
        'Proposer des solutions pour l\'environnement',
      ],
      introduction:
          'Climate change is one of the biggest challenges of our time. '
          'Africa is particularly affected by global warming, droughts and desertification. '
          'As a student in Burkina Faso, this topic concerns you directly!',
      cours: 'ENVIRONMENT VOCABULARY\n\n'
          '• climate change → changement climatique\n'
          '• global warming → réchauffement climatique\n'
          '• drought → sécheresse\n'
          '• deforestation → déforestation\n'
          '• desertification → désertification\n'
          '• pollution → pollution\n'
          '• renewable energy → énergie renouvelable\n'
          '• solar energy → énergie solaire\n'
          '• recycling → recyclage\n'
          '• biodiversity → biodiversité\n\n'
          'THE FUTURE WITH WILL\n\n'
          'USE: predictions, promises, spontaneous decisions\n\n'
          'AFFIRMATIVE: subject + will + verb\n'
          '• If we don\'t act, temperatures will rise by 3°C.\n'
          '• Burkina Faso will face more droughts in the future.\n\n'
          'NEGATIVE: subject + will not (won\'t) + verb\n'
          '• The Sahel won\'t receive enough rain.\n\n'
          'THE CONDITIONAL (IF...WILL)\n'
          '• If + present simple, ... will + verb\n'
          '• If we plant more trees, we will stop desertification.\n'
          '• If people use solar energy, they will reduce pollution.\n\n'
          'MAKING SUGGESTIONS:\n'
          '• We should + verb → Nous devrions...\n'
          '• We must + verb → Nous devons...\n'
          '• We can + verb → Nous pouvons...',
      exemples: [
        'Burkina Faso is experiencing more droughts due to climate change.',
        'If we plant more trees, we will fight desertification.',
        'We should use solar energy because Burkina Faso has a lot of sunshine.',
        'Thomas Sankara planted millions of trees to stop desertification in the 1980s.',
      ],
      exercices: [
        'Exercise 1: Fill in with the right word:\n'
            '(drought / deforestation / solar energy / pollution)\n'
            'a) Cutting down trees causes ___.\n'
            'b) Burkina Faso has enough sunshine to produce ___.\n'
            'c) Cars and factories produce ___.',
        'Exercise 2: Complete with WILL or WON\'T:\n'
            'a) If we don\'t act, the Sahel ___ become a desert.\n'
            'b) If we recycle, we ___ reduce waste.\n'
            'c) The temperature ___ fall if we use less fossil fuels.',
        'Exercise 3: Make conditional sentences:\n'
            'a) we / plant trees / reduce / flooding\n'
            'b) students / save water / help / the environment',
        'Exercise 4: Write a short paragraph (5 sentences) about an environmental '
            'problem in Burkina Faso and suggest 2 solutions.',
      ],
      corrections: [
        'Exercise 1: a) deforestation b) solar energy c) pollution',
        'Exercise 2: a) will b) will c) will',
        'Exercise 3: a) If we plant trees, we will reduce flooding. '
            'b) If students save water, they will help the environment.',
        'Exercise 4: Réponse personnelle',
      ],
      conclusion:
          'Climate change is a global problem that requires global solutions. '
          'As young Africans, you are the most affected — but also the most motivated '
          'to find solutions. Use your English skills to communicate these important ideas '
          'to the world!',
    ),
  ];

  // ================================================================
  // COLLÈGE — PHYSIQUE-CHIMIE
  // ================================================================
  static const _collegePhyChimie = [
    OfflineLesson(
      id: 'pc_6e_01',
      matiere: 'Physique-Chimie',
      niveau: '6e-5e',
      titre: 'La matière — États et changements d\'état',
      objectifs: [
        'Identifier les trois états de la matière',
        'Décrire les changements d\'état',
        'Relier les changements d\'état à la température',
      ],
      introduction:
          'Tout ce qui nous entoure est fait de matière : l\'eau, l\'air, le sable, le bois... '
          'La matière peut exister sous différentes formes appelées états. '
          'En changeant la température, on peut transformer un état en un autre.',
      cours: 'LES TROIS ÉTATS DE LA MATIÈRE\n\n'
          '1. L\'ÉTAT SOLIDE\n'
          '• Forme et volume fixes\n'
          '• Les molécules sont très proches et organisées\n'
          '• Exemples : glace, pierre, bois, sel\n\n'
          '2. L\'ÉTAT LIQUIDE\n'
          '• Volume fixe, forme variable (prend la forme du récipient)\n'
          '• Les molécules sont proches mais désorganisées\n'
          '• Exemples : eau, huile, lait, suc de mangue\n\n'
          '3. L\'ÉTAT GAZEUX\n'
          '• Forme et volume variables (occupe tout l\'espace disponible)\n'
          '• Les molécules sont très éloignées et désorganisées\n'
          '• Exemples : vapeur d\'eau, air, fumée\n\n'
          'LES CHANGEMENTS D\'ÉTAT\n\n'
          'FUSION : solide → liquide (en chauffant)\n'
          'Exemple : la glace fond → eau\n'
          'Température de fusion de l\'eau : 0°C\n\n'
          'SOLIDIFICATION : liquide → solide (en refroidissant)\n'
          'Exemple : l\'eau gèle → glace\n\n'
          'VAPORISATION : liquide → gaz (en chauffant)\n'
          'Ébullition de l\'eau : 100°C\n\n'
          'LIQUÉFACTION (condensation) : gaz → liquide (en refroidissant)\n'
          'Exemple : la vapeur d\'eau se condense sur un miroir froid\n\n'
          'SUBLIMATION : solide → gaz directement\n'
          'Exemple : le camphre, la glace carbonique\n\n'
          'CONSERVATION DE LA MASSE\n'
          'Lors d\'un changement d\'état, la masse se conserve :\n'
          '100g d\'eau liquide → 100g de vapeur (même masse !)',
      exemples: [
        'La glace (solide) fond en eau (liquide) quand la température dépasse 0°C',
        'En saison chaude à Ouagadougou, l\'eau s\'évapore très vite',
        'La rosée du matin est due à la condensation de la vapeur d\'eau',
        'Le beurre de karité est solide la nuit et peut devenir liquide sous la chaleur',
      ],
      exercices: [
        'Exercice 1 : Dans quel état se trouvent ces substances ?\n'
            'a) Le sel de cuisine\n'
            'b) L\'eau du fleuve\n'
            'c) La fumée de bois\n'
            'd) La glace pilée',
        'Exercice 2 : Nomme le changement d\'état :\n'
            'a) Eau → vapeur d\'eau (chauffage)\n'
            'b) Glace → eau (réchauffement)\n'
            'c) Vapeur → eau (refroidissement)',
        'Exercice 3 : On fait bouillir 200g d\'eau dans une casserole.\n'
            'Quelle est la masse de la vapeur produite ?',
        'Exercice 4 : Pourquoi les habits sèchent-ils plus vite en saison sèche qu\'en saison des pluies ?',
      ],
      corrections: [
        'Exercice 1 : a) solide b) liquide c) gaz d) solide',
        'Exercice 2 : a) vaporisation b) fusion c) liquéfaction/condensation',
        'Exercice 3 : 200g (la masse se conserve)',
        'Exercice 4 : En saison sèche, l\'air est chaud et sec → l\'eau s\'évapore plus vite '
            '(vaporisation accélérée). En saison des pluies, l\'air est humide et '
            'la vaporisation est plus lente.',
      ],
      conclusion: 'La matière peut changer d\'état selon la température, '
          'mais sa masse reste toujours la même. '
          'Ces phénomènes sont partout dans notre vie quotidienne : '
          'cuisson des aliments, séchage du linge, formation des nuages !',
    ),
    OfflineLesson(
      id: 'pc_4e2_01',
      matiere: 'Physique-Chimie',
      niveau: '4e',
      titre: 'L\'électricité — Courant électrique et circuits',
      objectifs: [
        'Comprendre ce qu\'est le courant électrique',
        'Distinguer circuit en série et en parallèle',
        'Calculer la tension, l\'intensité et la résistance (loi d\'Ohm)',
      ],
      introduction:
          'L\'électricité est une forme d\'énergie indispensable dans notre vie moderne. '
          'Des lampes de nos maisons aux téléphones portables, tout fonctionne à l\'électricité. '
          'Comprendre ses lois de base est essentiel.',
      cours: 'LE COURANT ÉLECTRIQUE\n\n'
          'Le courant électrique est un déplacement de charges électriques (électrons) '
          'dans un conducteur.\n\n'
          '• Conducteurs : laissent passer le courant (métaux : cuivre, fer, aluminium)\n'
          '• Isolants : ne laissent pas passer le courant (plastique, bois, verre, caoutchouc)\n\n'
          'GRANDEURS ÉLECTRIQUES\n\n'
          '• Tension (U) : "pression" qui pousse les charges → Volt (V)\n'
          '  Mesurée avec un voltmètre (en dérivation)\n\n'
          '• Intensité (I) : quantité de charges qui passent → Ampère (A)\n'
          '  Mesurée avec un ampèremètre (en série)\n\n'
          '• Résistance (R) : s\'oppose au passage du courant → Ohm (Ω)\n\n'
          'LOI D\'OHM\n\n'
          'U = R × I\n'
          '(Tension = Résistance × Intensité)\n\n'
          'Exemples :\n'
          '• R=10Ω, I=2A → U=10×2=20V\n'
          '• U=12V, R=4Ω → I=12÷4=3A\n\n'
          'CIRCUITS EN SÉRIE\n\n'
          '• Les composants sont branchés les uns après les autres\n'
          '• Même intensité partout : I₁=I₂=I\n'
          '• Les tensions s\'additionnent : U=U₁+U₂\n'
          '• Inconvénient : si un composant est en panne, tout s\'éteint !\n\n'
          'CIRCUITS EN PARALLÈLE\n\n'
          '• Les composants sont branchés sur le même point\n'
          '• Même tension partout : U₁=U₂=U\n'
          '• Les intensités s\'additionnent : I=I₁+I₂\n'
          '• Avantage : si un composant est en panne, les autres continuent !',
      exemples: [
        'Le câble en cuivre est un conducteur, la gaine plastique est un isolant',
        'Une pile 9V avec une résistance de 3Ω → I = 9÷3 = 3A',
        'Les ampoules chez vous sont branchées en parallèle (si une grille, les autres restent allumées)',
        'Un circuit de Noël en série : si une ampoule grille, tout s\'éteint !',
      ],
      exercices: [
        'Exercice 1 : Classe en conducteurs ou isolants :\n'
            'cuivre - plastique - fer - bois - aluminium - verre - eau salée',
        'Exercice 2 : Applique la loi d\'Ohm :\n'
            'a) R=20Ω, I=3A → U=?\n'
            'b) U=24V, R=8Ω → I=?\n'
            'c) U=15V, I=5A → R=?',
        'Exercice 3 : Un circuit en série avec 3 résistances : R₁=2Ω, R₂=3Ω, R₃=5Ω.\n'
            'La tension totale est 20V. Calcule l\'intensité dans le circuit.',
        'Exercice 4 : Pourquoi préfère-t-on brancher les appareils électriques en parallèle dans une maison ?',
      ],
      corrections: [
        'Exercice 1 : Conducteurs: cuivre, fer, aluminium, eau salée. '
            'Isolants: plastique, bois, verre.',
        'Exercice 2 : a) U=60V b) I=3A c) R=3Ω',
        'Exercice 3 : R_totale=2+3+5=10Ω. I=U/R=20/10=2A',
        'Exercice 4 : En parallèle, chaque appareil reçoit la même tension et fonctionne '
            'indépendamment des autres. Si un grille, les autres continuent.',
      ],
      conclusion:
          'L\'électricité obéit à des lois précises. La loi d\'Ohm (U=RI) '
          'est la base de toute l\'électronique. '
          'Au Burkina Faso, l\'énergie solaire offre une alternative pour '
          'alimenter les villages non connectés au réseau électrique.',
    ),
    OfflineLesson(
      id: 'pc_3e2_01',
      matiere: 'Physique-Chimie',
      niveau: '3e',
      titre: 'Les réactions chimiques — Définition et équations',
      objectifs: [
        'Définir une réaction chimique',
        'Écrire et équilibrer une équation chimique',
        'Distinguer réactifs et produits',
      ],
      introduction:
          'Quand tu fais brûler du bois, quand le fer rouille, quand tu mélanges '
          'du vinaigre et du bicarbonate de soude... une réaction chimique se produit ! '
          'Ces transformations de la matière suivent des lois précises.',
      cours: 'QU\'EST-CE QU\'UNE RÉACTION CHIMIQUE ?\n\n'
          'Une réaction chimique est une transformation de la matière au cours de laquelle '
          'des substances initiales (réactifs) se transforment en nouvelles substances (produits).\n\n'
          'RÉACTIFS → PRODUITS\n\n'
          'Signes d\'une réaction chimique :\n'
          '• Changement de couleur\n'
          '• Dégagement de gaz (bulles)\n'
          '• Dégagement de chaleur ou de lumière\n'
          '• Formation d\'un précipité (solide)\n\n'
          'LOI DE CONSERVATION DE LA MASSE\n\n'
          '(Lavoisier, 1789)\n'
          '"Rien ne se perd, rien ne se crée, tout se transforme."\n'
          'La masse des réactifs = la masse des produits\n\n'
          'L\'ÉQUATION CHIMIQUE\n\n'
          'Elle représente symboliquement une réaction chimique.\n\n'
          'Exemple : combustion de l\'hydrogène dans l\'oxygène\n'
          'H₂ + O₂ → H₂O (non équilibrée)\n\n'
          'ÉQUILIBRAGE D\'UNE ÉQUATION\n\n'
          'Règle : le nombre d\'atomes de chaque élément doit être égal des deux côtés.\n\n'
          'Étapes pour équilibrer H₂ + O₂ → H₂O :\n'
          '• H : 2 à gauche, 2 à droite ✓\n'
          '• O : 2 à gauche, 1 à droite ✗\n'
          '• On met 2 devant H₂O : H₂ + O₂ → 2H₂O\n'
          '• H : 2 à gauche, 4 à droite ✗\n'
          '• On met 2 devant H₂ : 2H₂ + O₂ → 2H₂O ✓\n'
          '• H : 4=4 ✓  O : 2=2 ✓\n\n'
          'EXEMPLES DE RÉACTIONS COURANTES\n\n'
          '• Combustion du carbone : C + O₂ → CO₂\n'
          '• Formation de la rouille : 4Fe + 3O₂ → 2Fe₂O₃\n'
          '• Électrolyse de l\'eau : 2H₂O → 2H₂ + O₂',
      exemples: [
        'Le vinaigre + bicarbonate : CH₃COOH + NaHCO₃ → CO₂ + H₂O + CH₃COONa',
        'La combustion du bois (carbone) : C + O₂ → CO₂ (dioxyde de carbone)',
        'La rouille du fer : 4Fe + 3O₂ → 2Fe₂O₃',
      ],
      exercices: [
        'Exercice 1 : Identifie les réactifs et les produits dans cette réaction :\n'
            'Fer (Fe) + Soufre (S) → Sulfure de fer (FeS)',
        'Exercice 2 : Cite 3 signes qui indiquent qu\'une réaction chimique a eu lieu.',
        'Exercice 3 : Vérifie si ces équations sont équilibrées. Si non, équilibre-les :\n'
            'a) H₂ + Cl₂ → HCl\n'
            'b) Na + H₂O → NaOH + H₂\n'
            'c) C + O₂ → CO₂',
        'Exercice 4 : Si 10g de fer réagissent avec 5g de soufre pour former du sulfure de fer,\n'
            'quelle est la masse de sulfure de fer produit ?',
      ],
      corrections: [
        'Exercice 1 : Réactifs : Fe et S. Produit : FeS',
        'Exercice 2 : Changement de couleur, dégagement de gaz, chaleur ou lumière, précipité',
        'Exercice 3 : a) H₂ + Cl₂ → 2HCl (non équilibrée, corriger)\n'
            'b) 2Na + 2H₂O → 2NaOH + H₂\n'
            'c) C + O₂ → CO₂ (déjà équilibrée ✓)',
        'Exercice 4 : 10+5=15g (loi de conservation de la masse)',
      ],
      conclusion:
          'Les réactions chimiques transforment la matière mais ne la créent ni ne la détruisent. '
          'La chimie est partout : dans notre corps, notre alimentation, notre environnement. '
          'Comprendre ces réactions, c\'est comprendre le monde qui nous entoure !',
    ),
  ];

  // ================================================================
  // LYCÉE — FRANÇAIS
  // ================================================================
  static const _lyceeFrancais = [
    OfflineLesson(
      id: 'fr_sec_01',
      matiere: 'Français',
      niveau: 'Seconde',
      titre: 'Le roman — Analyse narrative et étude de personnages',
      objectifs: [
        'Analyser la structure narrative d\'un roman',
        'Étudier la construction des personnages',
        'Identifier les procédés stylistiques du romancier',
      ],
      introduction:
          'Le roman est le genre littéraire dominant de la modernité. '
          'Il reflète la société, explore la psychologie humaine et pose des questions universelles. '
          'Savoir analyser un roman, c\'est acquérir un outil de compréhension du monde.',
      cours: 'LA NARRATION DANS LE ROMAN\n\n'
          '1. LE POINT DE VUE NARRATIF (Focalisation)\n\n'
          '• Focalisation zéro (narrateur omniscient) :\n'
          '  Le narrateur sait tout : pensées, sentiments, passé de tous les personnages.\n'
          '  "Raskolnikov pensait que... il ignorait que..."\n\n'
          '• Focalisation interne :\n'
          '  Le narrateur voit à travers les yeux d\'un personnage.\n'
          '  "Je sentais une angoisse monter en moi..."\n\n'
          '• Focalisation externe :\n'
          '  Le narrateur observe de l\'extérieur, sans accès aux pensées.\n'
          '  Comme une caméra : "Il entra, s\'assit, ne dit rien."\n\n'
          '2. LE TEMPS DU RÉCIT\n\n'
          '• Ordre : l\'histoire peut ne pas être racontée dans l\'ordre chronologique\n'
          '  - Analepse (flashback) : retour en arrière\n'
          '  - Prolepse (flash-forward) : anticipation\n\n'
          '• Rythme : le temps du récit peut être différent du temps de l\'histoire\n'
          '  - Résumé : compression du temps\n'
          '  - Scène : temps réel (dialogues)\n'
          '  - Pause : description qui arrête l\'action\n\n'
          'L\'ÉTUDE DU PERSONNAGE\n\n'
          '• Portrait physique : description de l\'apparence\n'
          '• Portrait moral/psychologique : caractère, valeurs, motivations\n'
          '• Évolution : le personnage change-t-il au cours du roman ?\n'
          '• Relations : ses rapports avec les autres personnages\n'
          '• Fonction : héros, adjuvant, opposant, confident\n\n'
          'LES PROCÉDÉS DU ROMANCIER\n\n'
          '• Le discours direct : le personnage parle directement ("Je suis fatigué.")\n'
          '• Le discours indirect : rapporté par le narrateur (Il dit qu\'il était fatigué.)\n'
          '• Le discours indirect libre : mélange des deux (Il était si fatigué !)\n'
          '• Le monologue intérieur : flux de pensées du personnage\n'
          '• Le stream of consciousness (courant de conscience)',
      exemples: [
        'Dans "Une vie" de Maupassant : narrateur omniscient qui suit Jeanne tout au long de sa vie',
        'Dans "L\'Étranger" de Camus : focalisation interne avec Meursault comme narrateur',
        'Analepse : un personnage qui raconte son enfance dans le présent du roman',
        'Personnage évolutif : un héros naïf qui devient sage à travers ses épreuves',
      ],
      exercices: [
        'Exercice 1 : Identifie la focalisation dans ces extraits :\n'
            'a) "Elle était triste, mais il ne le savait pas. Dans son cœur battait un amour secret."\n'
            'b) "Je regardai par la fenêtre et je vis un homme qui courait."\n'
            'c) "L\'homme entra. Il s\'assit. Il ne dit rien."',
        'Exercice 2 : Transforme ce discours direct en discours indirect :\n'
            '"Je ne viendrai pas demain car je suis malade," dit Aminata.',
        'Exercice 3 : Analyse ce personnage : donnez 3 caractéristiques physiques '
            'et 3 traits psychologiques d\'un personnage romanesque de votre choix.',
        'Exercice 4 : Rédige un paragraphe d\'introduction pour l\'analyse d\'un roman '
            'africain que vous avez lu.',
      ],
      corrections: [
        'Exercice 1 : a) Focalisation zéro (omnisciente) b) Focalisation interne c) Focalisation externe',
        'Exercice 2 : Aminata dit qu\'elle ne viendrait pas ce jour-là car elle était malade.',
        'Exercices 3 et 4 : Réponses personnelles',
      ],
      conclusion:
          'L\'analyse narrative est un outil essentiel pour comprendre les romans '
          'et réussir les épreuves de littérature. '
          'Lis régulièrement des romans africains et francophones : '
          'Camara Laye, Mongo Beti, Aminata Sow Fall vous attendent !',
    ),
    OfflineLesson(
      id: 'fr_pre_01',
      matiere: 'Français',
      niveau: 'Première',
      titre: 'Le théâtre — Tragédie, comédie et dramaturgie',
      objectifs: [
        'Distinguer les genres dramatiques',
        'Analyser un texte de théâtre',
        'Comprendre les techniques de la dramaturgie',
      ],
      introduction: 'Le théâtre est l\'art de la représentation vivante. '
          'Depuis l\'Antiquité grecque jusqu\'au théâtre africain contemporain, '
          'il exprime les conflits et les valeurs d\'une société. '
          'Analyser le théâtre, c\'est comprendre la nature humaine.',
      cours: 'LES GENRES DRAMATIQUES\n\n'
          '1. LA TRAGÉDIE\n'
          '• Origines grecques (Sophocle, Euripide) — XVIIe siècle français (Racine, Corneille)\n'
          '• Héros nobles confrontés à un destin inéluctable\n'
          '• Fin malheureuse inévitable\n'
          '• But : provoquer la catharsis (purification des émotions)\n'
          '• Règles classiques : unité de temps, de lieu, d\'action\n\n'
          '2. LA COMÉDIE\n'
          '• Molière : "Le Bourgeois Gentilhomme", "Tartuffe"\n'
          '• Personnages ordinaires, situation comique\n'
          '• Fin heureuse\n'
          '• Procédés comiques : comique de mots, de gestes, de situation, de caractère\n\n'
          '3. LE DRAME\n'
          '• XIXe siècle (Victor Hugo)\n'
          '• Mélange de tragique et de comique\n'
          '• Reflet plus réaliste de la société\n\n'
          'STRUCTURE DU TEXTE THÉÂTRAL\n\n'
          '• Acte : grande division\n'
          '• Scène : petite division (changement de personnages)\n'
          '• Didascalie : indication de mise en scène (en italique)\n'
          '• Réplique : prise de parole d\'un personnage\n'
          '• Tirade : longue réplique\n'
          '• Aparté : personnage parle au public sans que les autres entendent\n'
          '• Monologue : personnage seul qui parle\n\n'
          'LES CONFLITS DRAMATIQUES\n\n'
          '• Conflit intérieur (personnage vs lui-même)\n'
          '• Conflit interpersonnel (deux personnages)\n'
          '• Conflit avec la société\n'
          '• Conflit avec le destin/les dieux\n\n'
          'LE THÉÂTRE AFRICAIN\n\n'
          'Auteurs importants :\n'
          '• Bernard Dadié (Côte d\'Ivoire) : "Monsieur Thôgô-gnini"\n'
          '• Cheikh Ndao (Sénégal) : "L\'Exil d\'Albouri"\n'
          '• Sony Labou Tansi (Congo) : "La Parenthèse de Sang"',
      exemples: [
        'Dans Phèdre de Racine : tragédie - Phèdre ne peut résister à sa passion fatale',
        'Dans le Tartuffe de Molière : comédie - Tartuffe est un hypocrite ridicule',
        'Aparté : Harpagon dans "L\'Avare" : (à part) Ils vont me voler !',
        'Monologue délibératif : Hamlet "Être ou ne pas être, telle est la question..."',
      ],
      exercices: [
        'Exercice 1 : Distingue tragédie et comédie en donnant les caractéristiques '
            'de chaque genre.',
        'Exercice 2 : Identifie les éléments du texte théâtral dans cet extrait :\n'
            '"Acte II, Scène 3\n'
            '(Aminata entre précipitamment)\n'
            'AMINATA : Ibrahima, tu dois partir immédiatement !\n'
            'IBRAHIMA : (à part) Elle ne sait pas encore la vérité...\n'
            'AMINATA : N\'entends-tu pas ce que je dis ?"',
        'Exercice 3 : Quel est le type de conflit dans chaque situation ?\n'
            'a) Un fils qui doit choisir entre obéir à son père et suivre son amour\n'
            'b) Deux chefs qui se disputent le pouvoir\n'
            'c) Une femme qui ne peut contrôler sa jalousie',
      ],
      corrections: [
        'Exercice 1 : Tragédie : héros noble, destin fatal, fin malheureuse, catharsis. '
            'Comédie : personnages ordinaires, procédés comiques, fin heureuse.',
        'Exercice 2 : Acte II Scène 3 (structure), (Aminata entre) = didascalie, '
            'répliques d\'Aminata et Ibrahima, "(à part)" = aparté',
        'Exercice 3 : a) Conflit intérieur b) Conflit interpersonnel c) Conflit intérieur',
      ],
      conclusion: 'Le théâtre est un miroir de la société. '
          'En Afrique, des auteurs remarquables utilisent ce genre pour critiquer '
          'les injustices sociales et politiques. '
          'Lisez et si possible, jouez des pièces de théâtre !',
    ),
    OfflineLesson(
      id: 'fr_ter_01',
      matiere: 'Français',
      niveau: 'Terminale',
      titre: 'La dissertation littéraire — Méthode et rédaction',
      objectifs: [
        'Maîtriser la méthode de la dissertation littéraire',
        'Construire une argumentation structurée',
        'Rédiger une introduction et une conclusion efficaces',
      ],
      introduction:
          'La dissertation est l\'exercice roi du baccalauréat de français. '
          'Elle exige de la méthode, de la culture littéraire et une pensée organisée. '
          'Avec un entraînement régulier, elle devient un exercice maîtrisable.',
      cours: 'QU\'EST-CE QU\'UNE DISSERTATION LITTÉRAIRE ?\n\n'
          'C\'est un exercice qui consiste à répondre à une question sur la littérature '
          'en développant une argumentation organisée, illustrée d\'exemples littéraires.\n\n'
          'LA MÉTHODE EN 5 ÉTAPES\n\n'
          '1. ANALYSER LE SUJET\n'
          '• Identifier les mots-clés\n'
          '• Repérer la question centrale\n'
          '• Trouver les limites et les nuances du sujet\n\n'
          '2. TROUVER DES IDÉES (le brouillon)\n'
          '• Pour : arguments qui soutiennent la thèse\n'
          '• Contre : arguments qui nuancent ou s\'opposent\n'
          '• Exemples littéraires pour chaque argument\n\n'
          '3. CONSTRUIRE LE PLAN\n'
          'Plan dialectique (le plus courant) :\n'
          '• Thèse : OUI, parce que...\n'
          '• Antithèse : MAIS, cependant...\n'
          '• Synthèse : En réalité / Il faut nuancer...\n\n'
          '4. RÉDIGER\n\n'
          'L\'INTRODUCTION (environ 10-15 lignes)\n'
          '• Accroche : citation, fait historique, question rhétorique\n'
          '• Présentation du sujet\n'
          '• Problématique (reformulation de la question)\n'
          '• Annonce du plan\n\n'
          'LE DÉVELOPPEMENT\n'
          '• 3 parties (I, II, III)\n'
          '• Chaque partie : 2-3 paragraphes\n'
          '• Chaque paragraphe : idée + développement + exemple littéraire\n'
          '• Transition entre les parties\n\n'
          'LA CONCLUSION (environ 8-10 lignes)\n'
          '• Bilan des 3 parties\n'
          '• Réponse à la problématique\n'
          '• Ouverture (question plus large)\n\n'
          '5. RELIRE ET CORRIGER\n\n'
          'LES ERREURS À ÉVITER\n'
          '• Paraphrase (résumer sans analyser)\n'
          '• Hors-sujet\n'
          '• Manque d\'exemples précis\n'
          '• Absence de plan visible',
      exemples: [
        'Sujet : "La littérature africaine peut-elle contribuer au développement du continent ?"\n\n'
            'Problématique : Dans quelle mesure la littérature africaine est-elle un outil '
            'de développement social et culturel ?\n\n'
            'Plan : I. Oui, elle donne une voix aux peuples africains\n'
            'II. Mais ses limites sont réelles (alphabétisation, langue française)\n'
            'III. Elle peut néanmoins jouer un rôle essentiel si elle est diffusée',
      ],
      exercices: [
        'Exercice 1 : Analysez ce sujet et trouvez une problématique :\n'
            '"Le roman doit-il nécessairement raconter une histoire ?"',
        'Exercice 2 : Rédigez une introduction complète pour ce sujet :\n'
            '"La poésie est-elle le genre littéraire le plus adapté pour exprimer les émotions ?"',
        'Exercice 3 : Rédigez un paragraphe de développement complet (idée + développement '
            '+ exemple littéraire) sur le thème du rôle de l\'écrivain.',
      ],
      corrections: [
        'Exercice 1 : Mots-clés: roman, nécessairement, histoire. '
            'Problématique possible: Le roman est-il défini par la narration d\'une histoire, '
            'ou peut-il explorer d\'autres formes ?',
        'Exercices 2 et 3 : Réponses personnelles',
      ],
      conclusion: 'La dissertation est un art qui s\'acquiert par la pratique. '
          'Entraînez-vous régulièrement, lisez des œuvres variées et '
          'construisez votre culture littéraire. '
          'Le baccalauréat n\'a pas de secret pour qui travaille avec méthode !',
    ),
  ];

  // ================================================================
  // LYCÉE — MATHÉMATIQUES
  // ================================================================
  static const _lyceeMaths = [
    OfflineLesson(
      id: 'ma_sec_01',
      matiere: 'Mathématiques',
      niveau: 'Seconde',
      titre: 'Les fonctions — Généralités et représentations graphiques',
      objectifs: [
        'Comprendre la notion de fonction',
        'Étudier les fonctions de référence',
        'Tracer et interpréter des représentations graphiques',
      ],
      introduction:
          'Une fonction mathématique est une relation qui associe à chaque valeur d\'entrée '
          'une et une seule valeur de sortie. Les fonctions sont omniprésentes en mathématiques '
          'et dans la description des phénomènes naturels.',
      cours: 'DÉFINITION D\'UNE FONCTION\n\n'
          'Une fonction f associe à tout réel x de son domaine de définition '
          'un unique réel noté f(x).\n\n'
          'Notation : f : x → f(x)   ou   y = f(x)\n\n'
          'VOCABULAIRE\n\n'
          '• Domaine de définition (Df) : ensemble des valeurs de x autorisées\n'
          '• Image : f(x) est l\'image de x par f\n'
          '• Antécédent : x est un antécédent de y si f(x) = y\n\n'
          'LES FONCTIONS DE RÉFÉRENCE\n\n'
          '1. FONCTION LINÉAIRE : f(x) = ax\n'
          '• Représentation : droite passant par l\'origine\n'
          '• a = coefficient directeur\n'
          '• Si a > 0 : croissante / Si a < 0 : décroissante\n\n'
          '2. FONCTION AFFINE : f(x) = ax + b\n'
          '• Représentation : droite quelconque\n'
          '• a = pente, b = ordonnée à l\'origine\n\n'
          '3. FONCTION CARRÉE : f(x) = x²\n'
          '• Représentation : parabole\n'
          '• Df = ℝ, décroissante sur ]-∞;0] et croissante sur [0;+∞[\n'
          '• Minimum en x=0 : f(0) = 0\n\n'
          '4. FONCTION INVERSE : f(x) = 1/x\n'
          '• Df = ℝ* (tout sauf 0)\n'
          '• Représentation : hyperbole\n\n'
          '5. FONCTION RACINE CARRÉE : f(x) = √x\n'
          '• Df = [0;+∞[ (x doit être positif)\n'
          '• Représentation : demi-parabole\n\n'
          'VARIATIONS D\'UNE FONCTION\n\n'
          '• f croissante sur I : si x₁ < x₂ alors f(x₁) < f(x₂)\n'
          '• f décroissante sur I : si x₁ < x₂ alors f(x₁) > f(x₂)\n\n'
          'TABLEAU DE VARIATIONS\n\n'
          'Il résume graphiquement les variations d\'une fonction.',
      exemples: [
        'f(x) = 3x + 2 : droite de pente 3, ordonnée à l\'origine 2',
        'f(x) = x² : l\'image de 3 est f(3) = 9. L\'antécédent de 4 est x=2 ou x=-2',
        'Df de f(x) = √(x-1) : x-1 ≥ 0 donc x ≥ 1 → Df = [1;+∞[',
        'Df de f(x) = 1/(x-3) : x-3 ≠ 0 donc x ≠ 3 → Df = ℝ\\{3}',
      ],
      exercices: [
        'Exercice 1 : Détermine le domaine de définition :\n'
            'a) f(x) = 2x + 5\n'
            'b) f(x) = √(x+3)\n'
            'c) f(x) = 1/(x²-4)',
        'Exercice 2 : Pour f(x) = x² - 3x + 2, calcule :\n'
            'a) f(0)  b) f(2)  c) f(-1)',
        'Exercice 3 : Trace le tableau de variations de f(x) = -x² + 4.',
        'Exercice 4 : Deux fonctions affines :\n'
            'f(x) = 2x + 1 et g(x) = -x + 4\n'
            'Trouve leurs points d\'intersection.',
      ],
      corrections: [
        'Exercice 1 : a) Df=ℝ b) Df=[-3;+∞[ c) Df=ℝ\\{-2;2}',
        'Exercice 2 : a) f(0)=2 b) f(2)=0 c) f(-1)=6',
        'Exercice 3 : f(x)=-x²+4, max en x=0, f(0)=4. Décroissante sur [0;+∞[.',
        'Exercice 4 : 2x+1=-x+4 → 3x=3 → x=1, y=3. Point (1;3)',
      ],
      conclusion: 'Les fonctions sont le langage des mathématiques modernes. '
          'Maîtrisez les fonctions de référence et leurs représentations graphiques : '
          'elles reviendront tout au long du lycée et en études supérieures !',
    ),
    OfflineLesson(
      id: 'ma_pre_01',
      matiere: 'Mathématiques',
      niveau: 'Première',
      titre: 'La dérivation — Définition et applications',
      objectifs: [
        'Comprendre la notion de dérivée',
        'Calculer des dérivées',
        'Utiliser la dérivée pour étudier les variations',
      ],
      introduction:
          'La dérivée est l\'un des concepts les plus puissants des mathématiques. '
          'Elle permet de mesurer la vitesse de variation d\'une fonction. '
          'En physique, elle donne la vitesse et l\'accélération. '
          'En économie, elle optimise les profits. En médecine, elle modélise les épidémies.',
      cours: 'LA DÉRIVÉE — DÉFINITION\n\n'
          'La dérivée de f en a est la limite du taux d\'accroissement :\n'
          'f\'(a) = lim[h→0] (f(a+h) - f(a)) / h\n\n'
          'Interprétation géométrique : f\'(a) est le coefficient directeur '
          'de la tangente à la courbe au point d\'abscisse a.\n\n'
          'DÉRIVÉES DES FONCTIONS DE RÉFÉRENCE\n\n'
          '• f(x) = c (constante) → f\'(x) = 0\n'
          '• f(x) = x → f\'(x) = 1\n'
          '• f(x) = xⁿ → f\'(x) = nxⁿ⁻¹\n'
          '• f(x) = √x → f\'(x) = 1/(2√x)\n'
          '• f(x) = 1/x → f\'(x) = -1/x²\n'
          '• f(x) = sin(x) → f\'(x) = cos(x)\n'
          '• f(x) = cos(x) → f\'(x) = -sin(x)\n'
          '• f(x) = eˣ → f\'(x) = eˣ\n'
          '• f(x) = ln(x) → f\'(x) = 1/x\n\n'
          'RÈGLES DE DÉRIVATION\n\n'
          '• (u + v)\' = u\' + v\'\n'
          '• (ku)\' = ku\' (k constante)\n'
          '• (uv)\' = u\'v + uv\'\n'
          '• (u/v)\' = (u\'v - uv\') / v²\n'
          '• (u(v(x)))\' = u\'(v(x)) × v\'(x) (dérivée composée)\n\n'
          'LIEN DÉRIVÉE-VARIATIONS\n\n'
          '• f\'(x) > 0 sur I → f est croissante sur I\n'
          '• f\'(x) < 0 sur I → f est décroissante sur I\n'
          '• f\'(a) = 0 → extremum potentiel en x=a',
      exemples: [
        'f(x) = 3x² + 2x - 5 → f\'(x) = 6x + 2',
        'f(x) = (2x+1)³ → f\'(x) = 3(2x+1)² × 2 = 6(2x+1)²',
        'f(x) = x³/3 - 2x → f\'(x) = x² - 2. f\'(x)=0 → x=±√2',
        'Extremum : f(√2) = minimum local, f(-√2) = maximum local',
      ],
      exercices: [
        'Exercice 1 : Calcule les dérivées :\n'
            'a) f(x) = 4x³ - 3x² + 2x - 1\n'
            'b) f(x) = (x+1)(2x-3)\n'
            'c) f(x) = (3x+1)/(x-2)',
        'Exercice 2 : Étudie les variations de f(x) = x³ - 3x + 2.',
        'Exercice 3 : Trouve l\'équation de la tangente à la courbe f(x) = x² + 1\n'
            'au point d\'abscisse x=2.',
        'Exercice 4 : Application économique :\n'
            'Le bénéfice d\'une entreprise est B(x) = -x² + 10x - 16 (en millions de FCFA)\n'
            'où x est le nombre d\'unités produites. '
            'Quel est le nombre d\'unités qui maximise le bénéfice ?',
      ],
      corrections: [
        'Exercice 1 : a) f\'(x)=12x²-6x+2 '
            'b) (x+1)(2x-3)=2x²-x-3, f\'(x)=4x-1 '
            'c) f\'(x)=[(3)(x-2)-(3x+1)(1)]/(x-2)²=(-7)/(x-2)²',
        'Exercice 2 : f\'(x)=3x²-3=3(x²-1)=3(x-1)(x+1). '
            'f\'(x)>0 sur ]-∞;-1[ et ]1;+∞[ (croissante). '
            'f\'(x)<0 sur ]-1;1[ (décroissante). Max en x=-1, min en x=1.',
        'Exercice 3 : f\'(x)=2x. f\'(2)=4. Équation: y-f(2)=4(x-2) → y=4x-3',
        'Exercice 4 : B\'(x)=-2x+10=0 → x=5 unités. B(5)=9 millions de FCFA',
      ],
      conclusion:
          'La dérivée est un outil révolutionnaire inventé par Newton et Leibniz au XVIIe siècle. '
          'Elle est à la base du calcul différentiel et intégral. '
          'Maîtrisez les formules de dérivation : elles vous accompagneront '
          'tout au long de vos études scientifiques !',
    ),
    OfflineLesson(
      id: 'ma_ter_01',
      matiere: 'Mathématiques',
      niveau: 'Terminale',
      titre: 'Les probabilités — Loi binomiale et loi normale',
      objectifs: [
        'Maîtriser les lois de probabilités discrètes et continues',
        'Calculer avec la loi binomiale',
        'Utiliser la loi normale pour des estimations',
      ],
      introduction:
          'Les probabilités mesurent l\'incertitude des phénomènes aléatoires. '
          'Elles sont utilisées en médecine (efficacité d\'un vaccin), '
          'en économie (risques financiers), en météorologie et dans les assurances. '
          'La maîtrise des lois de probabilités est indispensable en terminale.',
      cours: 'RAPPELS\n\n'
          'Un événement A a une probabilité P(A) avec 0 ≤ P(A) ≤ 1\n'
          'P(Ā) = 1 - P(A)\n\n'
          'LA LOI BINOMIALE B(n, p)\n\n'
          'On répète n fois une expérience aléatoire avec :\n'
          '• p = probabilité de succès\n'
          '• 1-p = q = probabilité d\'échec\n'
          '• X = nombre de succès\n\n'
          'X suit une loi binomiale B(n, p) :\n'
          'P(X=k) = C(n,k) × pᵏ × (1-p)ⁿ⁻ᵏ\n\n'
          'où C(n,k) = n! / (k! × (n-k)!)\n\n'
          'ESPÉRANCE ET VARIANCE\n\n'
          '• E(X) = np (valeur moyenne attendue)\n'
          '• V(X) = np(1-p)\n'
          '• σ(X) = √(np(1-p)) (écart-type)\n\n'
          'LA LOI NORMALE N(μ, σ²)\n\n'
          'Pour des grands échantillons, la loi binomiale se rapproche de la loi normale.\n\n'
          '• μ = moyenne (espérance)\n'
          '• σ = écart-type\n'
          '• Courbe en cloche symétrique autour de μ\n\n'
          'LOI NORMALE CENTRÉE RÉDUITE N(0,1)\n\n'
          '• P(-1 ≤ Z ≤ 1) ≈ 68%\n'
          '• P(-2 ≤ Z ≤ 2) ≈ 95%\n'
          '• P(-3 ≤ Z ≤ 3) ≈ 99.7%\n\n'
          'INTERVALLE DE CONFIANCE\n\n'
          'Pour une proportion p dans une population, '
          'l\'intervalle de confiance au niveau 95% est :\n'
          '[p̂ - 1/√n ; p̂ + 1/√n]\n'
          'où p̂ est la fréquence observée et n la taille de l\'échantillon.',
      exemples: [
        'Un médicament guérit 70% des malades. Sur 10 patients : X ~ B(10, 0.7)\n'
            'P(X=8) = C(10,8) × 0.7⁸ × 0.3² = 45 × 0.0576 × 0.09 ≈ 0.233',
        'E(X) = 10 × 0.7 = 7 guérisons en moyenne',
        'Sur 1000 élèves, 600 ont le bac (60%). IC à 95% : [60%-3.16% ; 60%+3.16%]',
      ],
      exercices: [
        'Exercice 1 : X ~ B(5, 0.4). Calcule :\n'
            'a) P(X=2)  b) P(X≤1)  c) E(X)',
        'Exercice 2 : On lance une pièce équilibrée 100 fois.\n'
            'Soit X le nombre de "face".\n'
            'a) Quelle loi suit X ?\n'
            'b) Calcule E(X) et σ(X).',
        'Exercice 3 : Dans un sondage sur 400 personnes, 240 sont pour la mesure A.\n'
            'Construis l\'intervalle de confiance à 95%.',
        'Exercice 4 : La taille des élèves suit une loi normale N(165, 100).\n'
            'Quelle proportion d\'élèves mesure entre 155 et 175 cm ?',
      ],
      corrections: [
        'Exercice 1 : a) C(5,2)×0.4²×0.6³=10×0.16×0.216=0.346 '
            'b) P(X=0)+P(X=1)=0.6⁵+5×0.4×0.6⁴=0.0778+0.2592=0.337 '
            'c) E(X)=5×0.4=2',
        'Exercice 2 : a) B(100, 0.5) b) E(X)=50, σ=√(100×0.5×0.5)=5',
        'Exercice 3 : p̂=240/400=0.6. IC=[0.6-1/20; 0.6+1/20]=[0.55; 0.65]=[55%;65%]',
        'Exercice 4 : μ=165, σ=10. [155;175]=[μ-σ; μ+σ] → environ 68%',
      ],
      conclusion:
          'Les probabilités et la statistique sont au cœur de la science moderne. '
          'Des vaccins aux études économiques, tout repose sur ces outils. '
          'La loi normale est omniprésente dans la nature : tailles, masses, résultats scolaires... '
          'Ces notions sont essentielles pour le baccalauréat et les études supérieures.',
    ),
  ];

  // ================================================================
  // LYCÉE — SVT
  // ================================================================
  static const _lyceeSVT = [
    OfflineLesson(
      id: 'svt_sec_01',
      matiere: 'SVT',
      niveau: 'Seconde',
      titre: 'La photosynthèse — Mécanismes et importance',
      objectifs: [
        'Comprendre les mécanismes de la photosynthèse',
        'Identifier les facteurs qui influencent la photosynthèse',
        'Expliquer l\'importance de la photosynthèse pour la vie',
      ],
      introduction:
          'La photosynthèse est le processus par lequel les plantes transforment '
          'l\'énergie lumineuse en énergie chimique. '
          'C\'est le fondement de toute vie sur Terre : '
          'elle produit l\'oxygène que nous respirons et la matière organique que nous mangeons.',
      cours: 'QU\'EST-CE QUE LA PHOTOSYNTHÈSE ?\n\n'
          'La photosynthèse est une réaction chimique qui se déroule dans les chloroplastes '
          'des cellules végétales.\n\n'
          'ÉQUATION GLOBALE :\n'
          '6CO₂ + 6H₂O + lumière → C₆H₁₂O₆ + 6O₂\n'
          '(dioxyde de carbone + eau + lumière → glucose + dioxygène)\n\n'
          'LES DEUX PHASES DE LA PHOTOSYNTHÈSE\n\n'
          '1. PHASE LUMINEUSE (dans les thylakoïdes)\n'
          '• Nécessite de la lumière\n'
          '• Capture de l\'énergie lumineuse par la chlorophylle\n'
          '• Photolyse de l\'eau : H₂O → O₂ + H⁺ + e⁻\n'
          '• Production d\'ATP et de NADPH (énergie chimique)\n'
          '• C\'est ici que l\'oxygène est libéré !\n\n'
          '2. PHASE SOMBRE - Cycle de Calvin (dans le stroma)\n'
          '• Ne nécessite pas directement de lumière\n'
          '• Utilise l\'ATP et le NADPH de la phase lumineuse\n'
          '• Fixation du CO₂ atmosphérique\n'
          '• Synthèse du glucose (C₆H₁₂O₆)\n\n'
          'LE CHLOROPLASTE\n\n'
          'Structure :\n'
          '• Membrane externe et interne\n'
          '• Thylakoïdes : membranes internes empilées (granum)\n'
          '  → Contiennent la chlorophylle\n'
          '• Stroma : liquide entourant les thylakoïdes\n'
          '  → Lieu du cycle de Calvin\n\n'
          'FACTEURS INFLUENÇANT LA PHOTOSYNTHÈSE\n\n'
          '• Intensité lumineuse : plus de lumière = plus de photosynthèse (jusqu\'à un seuil)\n'
          '• Concentration en CO₂ : plus de CO₂ = plus de glucose\n'
          '• Température : optimum entre 25-35°C (les enzymes sont efficaces)\n'
          '• Disponibilité en eau',
      exemples: [
        'Les feuilles sont vertes car la chlorophylle absorbe le rouge et le bleu, '
            'mais réfléchit le vert',
        'En saison sèche au Burkina, les plantes photosynthétisent moins (manque d\'eau)',
        'Les forêts tropicales sont les "poumons de la Terre" : elles absorbent le CO₂',
        'La photosynthèse est à la base de toutes les chaînes alimentaires',
      ],
      exercices: [
        'Exercice 1 : Écris l\'équation globale de la photosynthèse et nomme les réactifs et produits.',
        'Exercice 2 : Vrai ou Faux ?\n'
            'a) L\'oxygène est produit lors de la phase sombre.\n'
            'b) La photosynthèse se déroule dans les mitochondries.\n'
            'c) La chlorophylle est contenue dans les thylakoïdes.',
        'Exercice 3 : Explique pourquoi les plantes poussent moins bien en hiver (dans les régions tempérées).',
        'Exercice 4 : Quels sont les effets de la déforestation sur le cycle du carbone ?',
      ],
      corrections: [
        'Exercice 1 : 6CO₂ + 6H₂O + lumière → C₆H₁₂O₆ + 6O₂. '
            'Réactifs: CO₂, H₂O, lumière. Produits: glucose, O₂.',
        'Exercice 2 : a) Faux (phase lumineuse) b) Faux (chloroplastes) c) Vrai',
        'Exercice 3 : En hiver, il y a moins de lumière (jours courts), '
            'les températures basses ralentissent les enzymes, '
            'et la neige peut limiter l\'accès à l\'eau.',
        'Exercice 4 : La déforestation réduit l\'absorption de CO₂ (moins de plantes), '
            'augmente le CO₂ atmosphérique (bois brûlé), '
            'contribuant au réchauffement climatique.',
      ],
      conclusion:
          'La photosynthèse est le processus le plus important de la biosphère. '
          'Elle est à la base de toute la nourriture que nous consommons '
          'et de l\'oxygène que nous respirons. '
          'Protéger les forêts, c\'est protéger la photosynthèse et donc la vie !',
    ),
    OfflineLesson(
      id: 'svt_pre_01',
      matiere: 'SVT',
      niveau: 'Première',
      titre: 'L\'immunologie — Le système immunitaire',
      objectifs: [
        'Décrire les mécanismes de l\'immunité innée et adaptative',
        'Comprendre la vaccination',
        'Expliquer les maladies auto-immunes et les allergies',
      ],
      introduction:
          'Notre corps est constamment attaqué par des microbes, des virus et des bactéries. '
          'Le système immunitaire est notre armée de défense. '
          'Dans les pays tropicaux comme le Burkina Faso, cette défense est mise à rude épreuve '
          'par le paludisme, la méningite et d\'autres maladies infectieuses.',
      cours: 'LES LIGNES DE DÉFENSE\n\n'
          '1. BARRIÈRES PHYSIQUES ET CHIMIQUES (1ère ligne)\n'
          '• Peau : empêche l\'entrée des microbes\n'
          '• Muqueuses : sécrètent du mucus qui piège les microbes\n'
          '• Larmes, salive : contiennent des enzymes antibactériennes\n'
          '• Acidité de l\'estomac : détruit la plupart des bactéries ingérées\n\n'
          '2. IMMUNITÉ INNÉE (2ème ligne - non spécifique)\n'
          '• Réaction rapide (minutes à heures)\n'
          '• Même réponse quelle que soit l\'infection\n'
          '• Acteurs : phagocytes (macrophages, neutrophiles)\n'
          '• Phagocytose : les phagocytes "mangent" les microbes\n'
          '• Inflammation : rougeur, chaleur, douleur → signal d\'alarme\n\n'
          '3. IMMUNITÉ ADAPTATIVE (3ème ligne - spécifique)\n'
          '• Réaction plus lente (jours à semaines)\n'
          '• Spécifique à chaque agent pathogène\n'
          '• Crée une mémoire immunitaire\n\n'
          'LES LYMPHOCYTES\n\n'
          '• Lymphocytes B : produisent les anticorps\n'
          '  Un anticorps reconnaît un antigène précis\n'
          '• Lymphocytes T auxiliaires (CD4) : coordonnent la réponse\n'
          '• Lymphocytes T cytotoxiques (CD8) : détruisent les cellules infectées\n\n'
          'LES ANTICORPS\n\n'
          'Protéines en forme de Y qui reconnaissent et neutralisent les antigènes.\n'
          'Chaque anticorps est spécifique d\'un antigène unique.\n\n'
          'LA VACCINATION\n\n'
          'Principe : introduire un antigène inoffensif (vaccin) pour créer une mémoire '
          'immunitaire SANS tomber malade.\n'
          'Types de vaccins :\n'
          '• Vaccins vivants atténués : virus affaibli (rougeole, fièvre jaune)\n'
          '• Vaccins inactivés : microbe tué (grippe, polio injectable)\n'
          '• Vaccins sous-unitaires : fragment du microbe\n'
          '• Vaccins ARNm : nouveaux vaccins COVID-19\n\n'
          'VIH/SIDA\n\n'
          'Le VIH détruit les lymphocytes T CD4+ → le système immunitaire s\'effondre\n'
          'SIDA = stade avancé où le corps ne peut plus se défendre\n'
          'Transmission : rapport sexuel non protégé, sang, mère-enfant',
      exemples: [
        'La vaccination contre la méningite A est obligatoire pour le pèlerinage à La Mecque',
        'Le paludisme : Plasmodium échappe au système immunitaire en se cachant dans les globules rouges',
        'Après une infection à la varicelle, on est immunisé à vie (mémoire immunitaire)',
        'Au Burkina, la campagne de vaccination infantile a réduit la mortalité enfantine',
      ],
      exercices: [
        'Exercice 1 : Cite les 3 lignes de défense de l\'organisme.',
        'Exercice 2 : Quelle est la différence entre immunité innée et immunité adaptative ?',
        'Exercice 3 : Explique le principe de la vaccination.',
        'Exercice 4 : Pourquoi le VIH est-il si dangereux pour le système immunitaire ?',
      ],
      corrections: [
        'Exercice 1 : Barrières physiques/chimiques, immunité innée, immunité adaptative.',
        'Exercice 2 : Innée = rapide, non spécifique, sans mémoire. '
            'Adaptative = lente, spécifique à chaque agent, crée une mémoire.',
        'Exercice 3 : On introduit un antigène inoffensif → les lymphocytes apprennent à le reconnaître → '
            'mémoire immunitaire créée → si vraie infection, réponse rapide et efficace.',
        'Exercice 4 : Le VIH détruit les lymphocytes T CD4+ qui coordonnent toute la réponse immunitaire. '
            'Sans eux, le corps ne peut plus se défendre contre les infections.',
      ],
      conclusion:
          'Le système immunitaire est notre bouclier contre les maladies. '
          'La vaccination est l\'une des plus grandes réussites de la médecine moderne. '
          'Au Burkina Faso, vaccinons nos enfants et protégeons nos communautés !',
    ),
    OfflineLesson(
      id: 'svt_ter_01',
      matiere: 'SVT',
      niveau: 'Terminale',
      titre: 'L\'évolution des êtres vivants — Mécanismes et preuves',
      objectifs: [
        'Comprendre la théorie de l\'évolution de Darwin',
        'Identifier les mécanismes de l\'évolution',
        'Analyser les preuves de l\'évolution',
      ],
      introduction:
          'Pourquoi les girafes ont-elles un long cou ? Pourquoi l\'homme ressemble-t-il '
          'au chimpanzé ? La théorie de l\'évolution, proposée par Charles Darwin en 1859, '
          'répond à ces questions en montrant que toutes les espèces vivantes '
          'sont liées par une origine commune et se transforment au fil du temps.',
      cours: 'DARWIN ET LA SÉLECTION NATURELLE\n\n'
          'Charles Darwin (1809-1882) observe lors de son voyage aux Galapagos '
          'que des espèces similaires ont développé des adaptations différentes.\n\n'
          'THÉORIE DE LA SÉLECTION NATURELLE :\n\n'
          '1. Variabilité : au sein d\'une espèce, les individus sont différents\n'
          '2. Hérédité : les caractères se transmettent aux descendants\n'
          '3. Surproduction : les organismes produisent plus de descendants que nécessaire\n'
          '4. Compétition : les ressources sont limitées (nourriture, territoire)\n'
          '5. Sélection : les individus les mieux adaptés survivent et se reproduisent\n\n'
          'LES MÉCANISMES DE L\'ÉVOLUTION\n\n'
          '1. LA MUTATION\n'
          '• Modification aléatoire de l\'ADN\n'
          '• Source principale de variabilité génétique\n'
          '• Peut être neutre, bénéfique ou défavorable\n\n'
          '2. LA SÉLECTION NATURELLE\n'
          '• Les mutations favorables se propagent dans la population\n'
          '• Exemple : résistance aux antibiotiques chez les bactéries\n\n'
          '3. LA DÉRIVE GÉNÉTIQUE\n'
          '• Variation aléatoire des fréquences alléliques\n'
          '• Importante dans les petites populations\n\n'
          '4. LA SPÉCIATION\n'
          '• Formation de nouvelles espèces\n'
          '• Due à l\'isolement géographique ou reproductif\n\n'
          'LES PREUVES DE L\'ÉVOLUTION\n\n'
          '1. Paléontologie : fossiles qui montrent des formes intermédiaires\n'
          '2. Anatomie comparée : organes homologues (même structure, fonctions différentes)\n'
          '   Exemple : bras humain, aile d\'oiseau, nageoire de dauphin\n'
          '3. Biologie moléculaire : similarité de l\'ADN entre espèces proches\n'
          '   Homme = 98% ADN en commun avec le chimpanzé\n'
          '4. Embryologie : tous les vertébrés ont des stades embryonnaires similaires',
      exemples: [
        'Les bactéries résistantes aux antibiotiques : sélection naturelle accélérée',
        'Le cou de la girafe : les girafes au long cou atteignent plus de feuilles = sélection',
        'Les pinsons des Galapagos : 13 espèces issues d\'un ancêtre commun',
        'La baleine a des os de membres postérieurs vestigiaux (preuve anatomique)',
      ],
      exercices: [
        'Exercice 1 : Explique en 5 étapes la théorie de la sélection naturelle.',
        'Exercice 2 : Quelles sont les 4 preuves de l\'évolution ? Donne un exemple pour chacune.',
        'Exercice 3 : Comment expliquer la résistance croissante des bactéries aux antibiotiques '
            'par la théorie de l\'évolution ?',
        'Exercice 4 : Quelle est la différence entre évolution lamarckienne et darwinienne ?\n'
            'Exemple : le cou de la girafe.',
      ],
      corrections: [
        'Exercice 1 : Variabilité → Hérédité → Surproduction → Compétition → Sélection',
        'Exercice 2 : Fossiles (dinosaures), Anatomie (bras/aile/nageoire), '
            'ADN (98% chimp/homme), Embryologie (embryons de poisson/reptile/humain similaires)',
        'Exercice 3 : Des mutations rendent certaines bactéries résistantes. '
            'L\'antibiotique tue les sensibles mais pas les résistantes. '
            'Les résistantes se reproduisent → population entière résistante.',
        'Exercice 4 : Lamarck : effort de la girafe pour atteindre les feuilles → long cou transmis. '
            'Darwin : girafes au long cou naturellement survivent mieux → sélection naturelle.',
      ],
      conclusion: 'L\'évolution est le fil conducteur de toute la biologie. '
          'Elle explique la diversité du vivant et les adaptations des organismes. '
          'Comprendre l\'évolution, c\'est comprendre la résistance aux antibiotiques, '
          'les épidémies et la biodiversité de notre planète.',
    ),
  ];

  // ================================================================
  // LYCÉE — HISTOIRE-GÉOGRAPHIE
  // ================================================================
  static const _lyceeHistoireGeo = [
    OfflineLesson(
      id: 'hg_sec_01',
      matiere: 'Histoire-Géographie',
      niveau: 'Seconde',
      titre: 'La Première Guerre mondiale — Causes et conséquences',
      objectifs: [
        'Analyser les causes de la Grande Guerre',
        'Comprendre les principales phases du conflit',
        'Évaluer les conséquences pour l\'Afrique et le monde',
      ],
      introduction:
          'La Première Guerre mondiale (1914-1918) fut le premier conflit à l\'échelle planétaire. '
          'Elle impliqua non seulement les pays européens, mais aussi leurs colonies africaines. '
          'Des soldats africains — dont des Burkinabè — combattirent et moururent '
          'pour des nations coloniales.',
      cours: 'LES CAUSES DE LA GRANDE GUERRE\n\n'
          '1. CAUSES PROFONDES (tension de longue date)\n'
          '• Nationalisme exacerbé (chaque nation veut être la plus puissante)\n'
          '• Impérialisme : rivalités coloniales entre grandes puissances\n'
          '• Militarisme : course aux armements\n'
          '• Système des alliances :\n'
          '  - Triple Alliance : Allemagne + Autriche-Hongrie + Italie\n'
          '  - Triple Entente : France + Angleterre + Russie\n\n'
          '2. CAUSE DÉCLENCHANTE\n'
          '• 28 juin 1914 : assassinat de François-Ferdinand (héritier austro-hongrois)\n'
          '  à Sarajevo par un nationaliste serbe\n'
          '• Effet domino des alliances → Europe en guerre en quelques semaines\n\n'
          'LES PHASES DU CONFLIT\n\n'
          '• 1914 : Guerre de mouvement → échec de la stratégie allemande\n'
          '• 1915-1917 : Guerre de positions (tranchées) → des millions de morts\n'
          '• 1917 : Entrée en guerre des USA + révolution russe\n'
          '• 1918 : Contre-offensive alliée → Armistice du 11 novembre\n\n'
          'LES TIRAILLEURS SÉNÉGALAIS\n\n'
          'Terme générique désignant les soldats africains de l\'armée française.\n'
          'Plus de 600 000 soldats africains mobilisés dont des Burkinabè (Haute-Volta).\n'
          'Combattirent dans les Dardanelles, en France, en Macédoine.\n'
          'Environ 30 000 Africains trouvèrent la mort.\n\n'
          'LES CONSÉQUENCES\n\n'
          'Humaines : 18 millions de morts (soldats + civils)\n'
          'Économiques : ruine de l\'Europe, dettes de guerre\n'
          'Politiques : disparition des empires (austro-hongrois, ottoman, russe)\n'
          'Traité de Versailles (1919) : l\'Allemagne punie → germe de la WWII\n'
          'Création de la SDN (ancêtre de l\'ONU)\n\n'
          'Pour l\'Afrique : les soldats reviennent avec des idées de liberté → '
          'naissance des mouvements nationalistes',
      exemples: [
        'Des Burkinabè furent recrutés de force par le travail obligatoire pour combattre en France',
        'Blaise Diagne (Sénégalais) recruta 600 000 soldats africains pour la France',
        'La bataille de Verdun (1916) : 700 000 morts en quelques mois',
      ],
      exercices: [
        'Exercice 1 : Quelles sont les 4 causes profondes de la Première Guerre mondiale ?',
        'Exercice 2 : Qu\'est-ce que les "Tirailleurs Sénégalais" ?\n'
            'Quel fut leur rôle dans la Grande Guerre ?',
        'Exercice 3 : Quelles sont les principales conséquences de la Première Guerre mondiale ?',
        'Exercice 4 : Pourquoi dit-on que le Traité de Versailles "prépare" la Seconde Guerre mondiale ?',
      ],
      corrections: [
        'Exercice 1 : Nationalisme, impérialisme, militarisme, système des alliances.',
        'Exercice 2 : Soldats africains de l\'armée française. Plus de 600 000 mobilisés, '
            '30 000 morts, combattirent sur tous les fronts.',
        'Exercice 3 : 18 millions de morts, ruine économique, disparition des empires, '
            'germe de WWII, création SDN.',
        'Exercice 4 : Il humilie l\'Allemagne (réparations, pertes territoriales), '
            'créant une rancœur qui favorisera la montée du nazisme.',
      ],
      conclusion:
          'La Grande Guerre fut une catastrophe humaine sans précédent. '
          'Les soldats africains y participèrent mais furent souvent oubliés de l\'Histoire. '
          'Leur sacrifice doit être reconnu et honoré.',
    ),
    OfflineLesson(
      id: 'hg_pre_01',
      matiere: 'Histoire-Géographie',
      niveau: 'Première',
      titre: 'La Seconde Guerre mondiale et la Shoah',
      objectifs: [
        'Comprendre les causes et le déroulement de la WWII',
        'Analyser le génocide juif (Shoah)',
        'Évaluer les conséquences mondiales',
      ],
      introduction:
          'La Seconde Guerre mondiale (1939-1945) fut la guerre la plus meurtrière de l\'Histoire '
          'avec 60 à 80 millions de morts. Elle fut aussi le théâtre d\'un crime sans précédent : '
          'la Shoah, génocide systématique de 6 millions de Juifs par le régime nazi.',
      cours: 'LES CAUSES DE LA WWII\n\n'
          '• Humiliation de l\'Allemagne par le Traité de Versailles\n'
          '• Crise économique de 1929 → misère → montée des extrémismes\n'
          '• Montée du nazisme : Hitler au pouvoir en 1933\n'
          '• Idéologie nazie : antisémitisme, pangermanisme, racisme\n'
          '• Politique d\'apaisement des démocraties (Munich 1938)\n'
          '• 1er septembre 1939 : invasion de la Pologne → déclaration de guerre\n\n'
          'LES PHASES PRINCIPALES\n\n'
          '• 1939-1941 : Victoires allemandes (Blitzkrieg, chute de la France)\n'
          '• 1941 : Tournant mondial → invasion de l\'URSS + USA dans la guerre (Pearl Harbor)\n'
          '• 1942-1943 : Tournant → Stalingrad, El-Alamein, débarquement allié\n'
          '• 1944 : Débarquement en Normandie (6 juin), libération de Paris\n'
          '• 1945 : Capitulation allemande (8 mai) et japonaise (2 septembre)\n\n'
          'LA SHOAH\n\n'
          'La Shoah = génocide des Juifs d\'Europe par les nazis (1942-1945)\n\n'
          'Étapes :\n'
          '• Discrimination : lois de Nuremberg (1935) → Juifs privés de droits\n'
          '• Persécution : Nuit de Cristal (1938)\n'
          '• Concentration : camps de travail forcé\n'
          '• Extermination : "Solution finale" (1942) → camps d\'extermination\n'
          '  (Auschwitz, Treblinka, Sobibor...)\n'
          '• 6 millions de Juifs assassinés = 1/3 des Juifs du monde\n\n'
          'L\'AFRIQUE DANS LA WWII\n\n'
          '• Afrique du Nord : théâtre d\'opérations (Rommel vs Alliés)\n'
          '• 500 000 soldats africains dans l\'armée française\n'
          '• L\'Afrique de l\'Ouest Française : base de la France Libre de De Gaulle\n\n'
          'LES CONSÉQUENCES\n\n'
          '• 60-80 millions de morts\n'
          '• Création de l\'ONU (1945)\n'
          '• Début de la guerre froide (USA vs URSS)\n'
          '• Décolonisation accélérée\n'
          '• Création d\'Israël (1948)',
      exemples: [
        'Le débarquement en Normandie : 150 000 soldats alliés le 6 juin 1944',
        'Auschwitz : 1,1 million de personnes tuées (dont 90% de Juifs)',
        'Les soldats sénégalais libérèrent Toulon et la Provence en 1944',
      ],
      exercices: [
        'Exercice 1 : Cite 3 causes de la montée du nazisme en Allemagne.',
        'Exercice 2 : Qu\'est-ce que la Shoah ? Décris ses 4 étapes.',
        'Exercice 3 : Quel rôle jouèrent les soldats africains dans la WWII ?',
        'Exercice 4 : Quelles sont les grandes conséquences de la WWII pour le monde ?',
      ],
      corrections: [
        'Exercice 1 : Humiliation de Versailles, crise de 1929, idéologie nazie antisémite.',
        'Exercice 2 : Génocide de 6 millions de Juifs. Étapes: discrimination → '
            'persécution → concentration → extermination.',
        'Exercice 3 : 500 000 soldats africains. Combattirent en Afrique du Nord, '
            'libérèrent Toulon, servirent de base à la France Libre.',
        'Exercice 4 : 60-80M morts, ONU, guerre froide, décolonisation, création d\'Israël.',
      ],
      conclusion: 'La WWII nous rappelle où peut mener la haine et le racisme. '
          '"Plus jamais ça" est le slogan qui doit guider l\'humanité. '
          'L\'ONU, créée après ce conflit, reste notre meilleur outil pour maintenir la paix.',
    ),
    OfflineLesson(
      id: 'hg_ter_01',
      matiere: 'Histoire-Géographie',
      niveau: 'Terminale',
      titre: 'La guerre froide — Bipolarisation du monde',
      objectifs: [
        'Comprendre la bipolarisation du monde après 1945',
        'Analyser les crises majeures de la guerre froide',
        'Évaluer les impacts sur l\'Afrique',
      ],
      introduction:
          'Après la victoire commune contre le nazisme, les États-Unis et l\'URSS '
          'devinrent des rivaux dans ce qu\'on appelle la "guerre froide" (1947-1991). '
          'Ce conflit idéologique et géopolitique divisa le monde en deux blocs '
          'et influença profondément l\'Afrique nouvellement indépendante.',
      cours: 'ORIGINES DE LA GUERRE FROIDE\n\n'
          '• Deux superpuissances aux idéologies opposées :\n'
          '  - USA : capitalisme, démocratie libérale, économie de marché\n'
          '  - URSS : communisme, parti unique, économie planifiée\n'
          '• 1947 : Doctrine Truman (endiguement du communisme)\n'
          '• Plan Marshall : aide économique américaine pour l\'Europe\n'
          '• OTAN (1949) : alliance militaire occidentale\n'
          '• Pacte de Varsovie (1955) : alliance militaire soviétique\n\n'
          'LES CRISES MAJEURES\n\n'
          '• 1948-1949 : Blocus de Berlin → pont aérien américain\n'
          '• 1950-1953 : Guerre de Corée (USA vs Chine/URSS)\n'
          '• 1962 : Crise des missiles de Cuba → risque de guerre nucléaire\n'
          '• 1964-1975 : Guerre du Vietnam\n'
          '• 1979-1989 : Guerre en Afghanistan\n\n'
          'LA COURSE AUX ARMEMENTS ET À L\'ESPACE\n\n'
          '• 1949 : URSS a la bombe atomique\n'
          '• 1957 : Spoutnik (1er satellite, URSS)\n'
          '• 1961 : Gagarine (1er homme dans l\'espace, URSS)\n'
          '• 1969 : Armstrong (1er homme sur la Lune, USA)\n\n'
          'LA DÉTENTE (1970s) ET LA FIN DE LA GUERRE FROIDE\n\n'
          '• Accords SALT sur la limitation des armements nucléaires\n'
          '• 1989 : Chute du mur de Berlin\n'
          '• 1991 : Dissolution de l\'URSS → fin de la guerre froide\n\n'
          'L\'AFRIQUE DANS LA GUERRE FROIDE\n\n'
          '• L\'Afrique nouvellement indépendante = terrain d\'affrontement\n'
          '• Mouvement des Non-Alignés (Bandung 1955) : alternative aux deux blocs\n'
          '• USA et URSS soutiennent des régimes africains opposés\n'
          '• Angola, Mozambique, Éthiopie : guerres civiles par procuration\n'
          '• Thomas Sankara refusait l\'alignement sur les deux blocs',
      exemples: [
        'Cuba : Kennedy vs Khrouchtchev en 1962, le monde au bord du conflit nucléaire',
        'Le mur de Berlin (1961-1989) symbole de la division Est-Ouest',
        'Le Burkina de Sankara refusait l\'aide conditionnée des deux blocs',
        'La Conférence de Bandung (1955) : naissance du mouvement des Non-Alignés',
      ],
      exercices: [
        'Exercice 1 : Quelle est la différence idéologique entre USA et URSS pendant la guerre froide ?',
        'Exercice 2 : Décris la crise des missiles de Cuba (1962) et ses enjeux.',
        'Exercice 3 : Qu\'est-ce que le mouvement des Non-Alignés ? Pourquoi fut-il important pour l\'Afrique ?',
        'Exercice 4 : Quelles furent les conséquences de la fin de la guerre froide pour l\'Afrique ?',
      ],
      corrections: [
        'Exercice 1 : USA = capitalisme, démocratie, économie de marché. '
            'URSS = communisme, parti unique, économie planifiée.',
        'Exercice 2 : L\'URSS installe des missiles nucléaires à Cuba. '
            'Kennedy bloque Cuba par mer. Khrouchtchev retire les missiles. '
            'Risque de guerre nucléaire évité de justesse.',
        'Exercice 3 : Mouvement des pays refusant l\'alignement sur les 2 blocs. '
            'Important pour l\'Afrique car préservait son indépendance.',
        'Exercice 4 : Fin des guerres par procuration, mais aussi perte d\'importance '
            'stratégique de l\'Afrique → réduction de l\'aide internationale.',
      ],
      conclusion: 'La guerre froide divisa le monde pendant 44 ans. '
          'L\'Afrique en fut une victime collatérale, ses conflits alimentés par les deux blocs. '
          'La fin de la guerre froide ouvrit une nouvelle ère, '
          'mais les défis du développement africain restèrent entiers.',
    ),
  ];

  // ================================================================
  // LYCÉE — ANGLAIS
  // ================================================================
  static const _lyceeAnglais = [
    OfflineLesson(
      id: 'en_sec_01',
      matiere: 'Anglais',
      niveau: 'Seconde',
      titre: 'Africa and its challenges — Reading and discussing',
      objectifs: [
        'Discuter des défis africains en anglais',
        'Maîtriser les temps du passé et du présent',
        'Développer son vocabulaire thématique',
      ],
      introduction:
          'Africa is a continent full of contrasts: extraordinary natural beauty '
          'and biodiversity, rich cultures and histories, but also challenges '
          'like poverty, climate change, and conflicts. '
          'Learning to discuss these topics in English is essential '
          'for participating in global conversations.',
      cours: 'AFRICA : KEY FACTS\n\n'
          '• 54 countries, 1.4 billion people (2023)\n'
          '• Most diverse continent linguistically (over 2,000 languages)\n'
          '• Youngest population: median age ~19 years\n'
          '• Fastest growing economies in the world\n'
          '• Home to 60% of the world\'s uncultivated arable land\n\n'
          'CHALLENGES FACING AFRICA\n\n'
          '1. POVERTY AND DEVELOPMENT\n'
          '• Many countries are among the world\'s poorest\n'
          '• However, GDP growth rates are among the highest globally\n'
          '• Challenge: transforming growth into development for all\n\n'
          '2. CLIMATE CHANGE\n'
          '• Africa contributes least to climate change (3% of global emissions)\n'
          '• But suffers most: droughts, floods, desertification\n'
          '• Sahel region (including Burkina Faso) particularly vulnerable\n\n'
          '3. EDUCATION\n'
          '• 60 million children out of school in sub-Saharan Africa\n'
          '• Gender gap: girls less likely to complete school\n'
          '• Solution: apps like OARA, mobile learning, radio schools\n\n'
          'GRAMMAR REVIEW: PRESENT PERFECT\n\n'
          'USE: actions that started in the past and continue, '
          'or past actions with present relevance\n\n'
          'FORM: have/has + past participle\n'
          '• Africa has made great progress in reducing child mortality.\n'
          '• Burkina Faso has faced many challenges recently.\n'
          '• Many African countries have achieved independence since 1960.\n\n'
          'KEY WORDS:\n'
          'already, yet, just, ever, never, since, for, recently',
      exemples: [
        'Burkina Faso has invested in solar energy to address power shortages.',
        'African youth have been using mobile apps to access education offline.',
        'Since independence, many African nations have built universities and hospitals.',
        'The African Union has worked to promote peace and integration.',
      ],
      exercices: [
        'Exercise 1: Fill in with the Present Perfect:\n'
            'a) Africa ___ (become) the fastest-growing mobile market.\n'
            'b) Burkina Faso ___ (face) many security challenges recently.\n'
            'c) Many African scientists ___ (win) international prizes.',
        'Exercise 2: Correct these sentences:\n'
            'a) Africa has only deserts and wild animals.\n'
            'b) All African countries are poor.\n'
            'c) Africa has no technology.',
        'Exercise 3: Write a short paragraph (5 sentences) about ONE challenge\n'
            'facing Burkina Faso and ONE solution. Use the Present Perfect\n'
            'and vocabulary from the lesson.',
        'Exercise 4: Discussion — "Is education the key to Africa\'s development?"\n'
            'Write 3 arguments FOR and 1 argument AGAINST.',
      ],
      corrections: [
        'Exercise 1: a) has become b) has faced c) have won',
        'Exercise 2: a) Africa has diverse landscapes: forests, savannas, mountains, coastlines.\n'
            'b) Africa has the fastest-growing economies in the world.\n'
            'c) Africa is a leading mobile technology market.',
        'Exercise 3 & 4: Personal answers',
      ],
      conclusion:
          'Africa is not a problem to be solved — it is a continent full of solutions. '
          'As young Burkinabè, you are part of Africa\'s future. '
          'Use your English skills to tell Africa\'s true story to the world!',
    ),
    OfflineLesson(
      id: 'en_pre_01',
      matiere: 'Anglais',
      niveau: 'Première',
      titre: 'Social issues and argumentative writing',
      objectifs: [
        'Identifier et analyser des problèmes sociaux',
        'Rédiger un texte argumentatif structuré en anglais',
        'Utiliser les connecteurs logiques en anglais',
      ],
      introduction:
          'Being able to argue effectively in English is a crucial skill '
          'for university, international careers, and global citizenship. '
          'Today we will practice writing structured arguments about social issues '
          'that matter in Burkina Faso and across Africa.',
      cours: 'SOCIAL ISSUES VOCABULARY\n\n'
          '• inequality → inégalité\n'
          '• gender gap → écart homme-femme\n'
          '• access to education → accès à l\'éducation\n'
          '• rural-urban divide → fracture rurale-urbaine\n'
          '• youth unemployment → chômage des jeunes\n'
          '• early marriage → mariage précoce\n'
          '• food insecurity → insécurité alimentaire\n'
          '• digital divide → fracture numérique\n'
          '• empowerment → autonomisation\n'
          '• sustainable development → développement durable\n\n'
          'STRUCTURE OF AN ARGUMENTATIVE TEXT\n\n'
          '1. INTRODUCTION\n'
          '• Hook: a surprising fact or question\n'
          '• Background: context for the issue\n'
          '• Thesis: your clear position\n\n'
          '2. BODY PARAGRAPHS\n'
          'Each paragraph = Point + Explanation + Example\n'
          '(PEE method)\n\n'
          '3. COUNTER-ARGUMENT + REFUTATION\n'
          '• Acknowledge the other side: "Some argue that..."\n'
          '• Refute it: "However, this ignores the fact that..."\n\n'
          '4. CONCLUSION\n'
          '• Restate thesis (in different words)\n'
          '• Call to action or broader implication\n\n'
          'USEFUL CONNECTORS\n\n'
          'Adding: furthermore, moreover, in addition, also\n'
          'Contrasting: however, nevertheless, on the other hand, although\n'
          'Cause/Effect: therefore, consequently, as a result, because\n'
          'Exemplifying: for instance, for example, such as, namely\n'
          'Concluding: in conclusion, to sum up, ultimately, therefore\n\n'
          'EXPRESSING OPINION\n\n'
          '• I firmly believe that...\n'
          '• It is clear / evident that...\n'
          '• One cannot deny that...\n'
          '• It is widely acknowledged that...',
      exemples: [
        'Topic: "Girls\' education in Burkina Faso"\n'
            'Hook: "In Burkina Faso, only 26% of girls complete secondary school."\n'
            'Thesis: Educating girls is the single most effective way to develop a nation.',
        'PEE Paragraph: Girls who finish school earn higher incomes (Point). '
            'Studies show educated women reinvest 90% of earnings in their families (Explanation). '
            'In rural Burkina, educated mothers have healthier children (Example).',
        'Counter + Refutation: "Some argue that girls should help at home instead of studying. '
            'However, this short-term view ignores the long-term economic benefits '
            'of female education for the entire community."',
      ],
      exercices: [
        'Exercise 1: Match the connector to its function:\n'
            'Furthermore / However / Therefore / For instance\n'
            'a) to add information  b) to contrast  c) to give an example  d) to show consequence',
        'Exercise 2: Rewrite these sentences using the connector in brackets:\n'
            'a) Girls face barriers. They succeed when given opportunities. (Nevertheless)\n'
            'b) Education improves income. It also improves health. (Moreover)\n'
            'c) Many students drop out. They lack school materials. (Because)',
        'Exercise 3: Write a complete argumentative paragraph (PEE) on:\n'
            '"Mobile phones help students learn better."',
        'Exercise 4: Write a full argumentative essay (introduction + 2 body paragraphs\n'
            '+ counter-argument + conclusion) on:\n'
            '"Should secondary education be free and compulsory in Burkina Faso?"',
      ],
      corrections: [
        'Exercise 1: a) Furthermore b) However c) For instance d) Therefore',
        'Exercise 2: a) Girls face barriers. Nevertheless, they succeed when given opportunities.\n'
            'b) Education improves income. Moreover, it also improves health.\n'
            'c) Many students drop out because they lack school materials.',
        'Exercise 3 & 4: Personal answers — check structure (PEE) and connector use.',
      ],
      conclusion:
          'Argumentative writing is a skill that will open doors worldwide. '
          'Whether you apply to a university in France, Canada or the USA, '
          'or write a report at work, these techniques are essential. '
          'Practice writing one short argument every day!',
    ),
    OfflineLesson(
      id: 'en_ter_01',
      matiere: 'Anglais',
      niveau: 'Terminale',
      titre: 'Globalisation, technology and the future of Africa',
      objectifs: [
        'Débattre de sujets complexes en anglais',
        'Maîtriser les structures de discours formel',
        'Rédiger une composition de niveau baccalauréat',
      ],
      introduction:
          'At the baccalauréat level, you are expected to engage with complex global issues '
          'in English. Technology, globalisation, and Africa\'s future are key themes '
          'in international exams. This lesson prepares you for the final exam '
          'and for a globalised world.',
      cours: 'TECHNOLOGY AND AFRICA — KEY VOCABULARY\n\n'
          '• artificial intelligence (AI) → intelligence artificielle\n'
          '• fintech → technologie financière\n'
          '• mobile money → argent mobile (ex: Orange Money)\n'
          '• e-learning → apprentissage en ligne\n'
          '• innovation hub → pôle d\'innovation\n'
          '• leapfrogging → sauter des étapes technologiques\n'
          '• startup ecosystem → écosystème de startups\n'
          '• digital literacy → culture numérique\n'
          '• brain drain → fuite des cerveaux\n'
          '• tech diaspora → diaspora technologique\n\n'
          'AFRICA\'S TECH LEAPFROGGING\n\n'
          'Africa "leapfrogged" fixed telephone lines → went directly to mobile phones.\n'
          'Similarly: no landline banking → directly to mobile money (M-Pesa, Orange Money).\n'
          'Today: potential to leapfrog fossil fuels → directly to solar energy.\n\n'
          'ADVANCED GRAMMAR: HYPOTHETICALS\n\n'
          'Second conditional (hypothetical present/future):\n'
          'If + past simple, would + infinitive\n'
          '• If every student had internet access, education would improve dramatically.\n\n'
          'Third conditional (hypothetical past):\n'
          'If + past perfect, would have + past participle\n'
          '• If Africa had industrialised earlier, it would have reduced poverty faster.\n\n'
          'Mixed conditional:\n'
          'If + past perfect, would + infinitive\n'
          '• If colonial borders had been drawn differently, '
          'Africa would be more stable today.\n\n'
          'FORMAL WRITING STRUCTURES\n\n'
          '• It could be argued that...\n'
          '• There is compelling evidence to suggest that...\n'
          '• The implications of this are far-reaching...\n'
          '• A nuanced approach would recognise that...\n'
          '• Ultimately, the evidence points to...',
      exemples: [
        'Leapfrogging: "Kenya\'s M-Pesa gave millions of unbanked Africans '
            'access to financial services without ever needing a bank branch."',
        'Second conditional: "If OARA were deployed in every school in Burkina Faso, '
            'dropout rates would fall significantly."',
        'Third conditional: "If Thomas Sankara had not been assassinated, '
            'Burkina Faso would have pursued a more independent development path."',
      ],
      exercices: [
        'Exercise 1: Complete with the correct conditional:\n'
            'a) If Africa ___ (have) more engineers, tech industries ___ (grow) faster.\n'
            'b) If we ___ (invest) in education 20 years ago, poverty ___ (decrease) by now.\n'
            'c) If solar panels ___ (be) cheaper, more villages ___ (use) clean energy.',
        'Exercise 2: Rewrite using formal language:\n'
            'a) "Lots of young Africans don\'t have jobs."\n'
            'b) "Technology can help schools."\n'
            'c) "Brain drain is a big problem."',
        'Exercise 3: Write a 200-word essay on:\n'
            '"Artificial Intelligence: opportunity or threat for African students?"',
        'Exercise 4: Debate preparation — prepare 3 arguments FOR and 3 AGAINST:\n'
            '"Social media does more harm than good for African youth."',
      ],
      corrections: [
        'Exercise 1: a) had / would grow  b) had invested / would have decreased  '
            'c) were / would use',
        'Exercise 2: a) "Youth unemployment remains a critical challenge across the African continent."\n'
            'b) "Technology has the potential to transform educational outcomes significantly."\n'
            'c) "The emigration of skilled professionals poses a substantial threat to '
            'African development."',
        'Exercise 3 & 4: Personal answers — evaluate structure, vocabulary, and grammar.',
      ],
      conclusion:
          'You are now ready for the baccalauréat English exam and beyond. '
          'The skills you have built — argumentation, vocabulary, grammar — '
          'are your passport to universities and careers worldwide. '
          'Africa needs its educated youth to stay, innovate, and build. '
          'You are that generation.',
    ),
  ];

  // ================================================================
  // LYCÉE — PHYSIQUE-CHIMIE
  // ================================================================
  static const _lyceePhyChimie = [
    OfflineLesson(
      id: 'pc_sec_01',
      matiere: 'Physique-Chimie',
      niveau: 'Seconde',
      titre: 'La cinématique — Mouvement et vitesse',
      objectifs: [
        'Décrire et qualifier un mouvement',
        'Calculer vitesse moyenne et instantanée',
        'Interpréter des graphiques de mouvement',
      ],
      introduction: 'La cinématique est l\'étude du mouvement des objets, '
          'indépendamment des forces qui les causent. '
          'Elle est à la base de la physique mécanique et nous permet '
          'de décrire le mouvement d\'un vélo, d\'un avion ou d\'un satellite.',
      cours: 'LE MOUVEMENT\n\n'
          'Un objet est en mouvement par rapport à un référentiel '
          'quand sa position change au cours du temps.\n\n'
          'TYPES DE MOUVEMENTS\n\n'
          '• Mouvement rectiligne : trajectoire en ligne droite\n'
          '  - Uniforme (MRU) : vitesse constante\n'
          '  - Uniformément varié (MRUV) : vitesse varie uniformément\n'
          '• Mouvement curviligne : trajectoire courbe\n'
          '  - Circulaire : trajectoire est un cercle\n'
          '  - Parabolique : trajectoire en parabole (projectile)\n\n'
          'LA VITESSE\n\n'
          'Vitesse moyenne :\n'
          'v_moy = Δd / Δt = (d₂ - d₁) / (t₂ - t₁)\n'
          '• d = distance en mètres (m)\n'
          '• t = temps en secondes (s)\n'
          '• v = vitesse en m/s (ou km/h)\n\n'
          'Conversion : 1 m/s = 3,6 km/h\n\n'
          'Vitesse instantanée :\n'
          'v = lim[Δt→0] Δd/Δt = dd/dt (dérivée de la position)\n\n'
          'L\'ACCÉLÉRATION\n\n'
          'a = Δv / Δt = (v₂ - v₁) / (t₂ - t₁)\n'
          '• Unité : m/s²\n'
          '• Si a > 0 : objet accélère\n'
          '• Si a < 0 : objet décélère (freine)\n'
          '• Si a = 0 : vitesse constante (MRU)\n\n'
          'ÉQUATIONS DU MRUV\n\n'
          'v(t) = v₀ + a·t\n'
          'd(t) = d₀ + v₀·t + ½·a·t²\n'
          'v² = v₀² + 2·a·Δd\n\n'
          'CHUTE LIBRE\n\n'
          'Cas particulier du MRUV avec a = g = 9,8 m/s² (vers le bas)\n'
          '• v(t) = g·t\n'
          '• h(t) = ½·g·t²',
      exemples: [
        'Un vélo parcourt 30 km en 2h → v_moy = 30/2 = 15 km/h = 4,17 m/s',
        'Une voiture passe de 0 à 100 km/h en 10s → a = (100/3,6)/10 = 2,78 m/s²',
        'Chute libre depuis 20m : t = √(2h/g) = √(40/9,8) ≈ 2,02 s',
        'Balle lancée horizontalement à 20 m/s : sa trajectoire est une parabole',
      ],
      exercices: [
        'Exercice 1 : Un bus fait Ouagadougou-Bobo (360 km) en 5h.\n'
            'a) Calcule sa vitesse moyenne en km/h et en m/s.\n'
            'b) À cette vitesse, combien de temps pour aller à Dori (270 km) ?',
        'Exercice 2 : Une voiture passe de 72 km/h à 0 en 8 s (freinage d\'urgence).\n'
            'a) Calcule l\'accélération (en m/s²).\n'
            'b) Quelle distance parcourt-elle pendant ce freinage ?',
        'Exercice 3 : Un objet tombe en chute libre depuis le toit d\'un immeuble de 45 m.\n'
            'a) Quelle est sa vitesse juste avant de toucher le sol ?\n'
            'b) Combien de temps dure la chute ? (g = 10 m/s²)',
        'Exercice 4 : Trace le graphique d(t) pour un MRU à 5 m/s\n'
            'sur un intervalle de 0 à 10 s.',
      ],
      corrections: [
        'Exercice 1 : a) v = 360/5 = 72 km/h = 20 m/s\n'
            'b) t = 270/72 = 3,75 h = 3h 45 min',
        'Exercice 2 : a) v₀=72/3,6=20 m/s. a = (0-20)/8 = -2,5 m/s²\n'
            'b) d = 20×8 + ½×(-2,5)×64 = 160 - 80 = 80 m',
        'Exercice 3 : a) v² = 2×10×45 = 900 → v = 30 m/s\n'
            'b) t = v/g = 30/10 = 3 s',
        'Exercice 4 : Droite passant par l\'origine, pente = 5. '
            'Points: (0;0), (2;10), (5;25), (10;50).',
      ],
      conclusion:
          'La cinématique décrit tous les mouvements de notre monde quotidien. '
          'Les équations du MRUV s\'appliquent à la chute libre, aux véhicules, '
          'aux fusées et aux satellites. '
          'Maîtrisez les conversions d\'unités et les trois équations fondamentales !',
    ),
    OfflineLesson(
      id: 'pc_pre_01',
      matiere: 'Physique-Chimie',
      niveau: 'Première',
      titre: 'Les ondes — Nature, propagation et applications',
      objectifs: [
        'Définir une onde et ses caractéristiques',
        'Distinguer ondes mécaniques et électromagnétiques',
        'Appliquer les relations entre longueur d\'onde, fréquence et célérité',
      ],
      introduction:
          'Les ondes sont partout : son, lumière, radio, micro-ondes, ultrasons... '
          'La téléphonie mobile au Burkina Faso, la radio nationale, '
          'les radars météo — tous utilisent des ondes. '
          'Comprendre les ondes, c\'est comprendre les communications modernes.',
      cours: 'QU\'EST-CE QU\'UNE ONDE ?\n\n'
          'Une onde est la propagation d\'une perturbation dans un milieu '
          'SANS transport de matière, avec transport d\'énergie.\n\n'
          'TYPES D\'ONDES\n\n'
          '1. ONDES MÉCANIQUES : nécessitent un milieu matériel\n'
          '   • Ondes sonores (son) : se propagent dans l\'air, l\'eau, les solides\n'
          '   • Ondes sismiques : se propagent dans la Terre\n'
          '   • Vagues : se propagent à la surface de l\'eau\n'
          '   ⚠️ Le son ne se propage PAS dans le vide !\n\n'
          '2. ONDES ÉLECTROMAGNÉTIQUES : se propagent sans milieu matériel\n'
          '   • Lumière visible\n'
          '   • Ondes radio (FM, AM, télévision)\n'
          '   • Micro-ondes (wifi, 4G, fours)\n'
          '   • Infrarouges (télécommandes, chaleur)\n'
          '   • Ultraviolets (désinfection, bronzage)\n'
          '   • Rayons X (radiographies)\n'
          '   ✓ Se propagent dans le vide à c = 3×10⁸ m/s\n\n'
          'CARACTÉRISTIQUES D\'UNE ONDE SINUSOÏDALE\n\n'
          '• Longueur d\'onde (λ) : distance entre deux crêtes successives → mètre (m)\n'
          '• Fréquence (f) : nombre de cycles par seconde → Hertz (Hz)\n'
          '• Période (T) : durée d\'un cycle → seconde (s) → T = 1/f\n'
          '• Célérité (v) : vitesse de propagation → m/s\n\n'
          'RELATION FONDAMENTALE :\n\n'
          'v = λ × f   ou   λ = v/f   ou   f = v/λ\n\n'
          'CÉLÉRITÉS IMPORTANTES :\n'
          '• Son dans l\'air (20°C) : v_son ≈ 340 m/s\n'
          '• Lumière dans le vide : c = 3×10⁸ m/s\n\n'
          'LE SON\n\n'
          '• Fréquences audibles : 20 Hz à 20 000 Hz\n'
          '• En-dessous : infrasons (< 20 Hz)\n'
          '• Au-dessus : ultrasons (> 20 000 Hz)\n'
          '• Plus la fréquence est haute → son aigu\n'
          '• Plus l\'amplitude est grande → son fort',
      exemples: [
        'Radio FM 100 MHz : λ = v/f = (3×10⁸)/(10⁸) = 3 m',
        '4G à 1800 MHz : λ = (3×10⁸)/(1,8×10⁹) ≈ 0,167 m = 16,7 cm',
        'Son La (440 Hz) : λ = 340/440 ≈ 0,77 m',
        'Tonnerre : si on entend 3 s après l\'éclair → d = 340×3 = 1020 m ≈ 1 km',
      ],
      exercices: [
        'Exercice 1 : Une onde sonore a une fréquence de 680 Hz dans l\'air.\n'
            'a) Calcule sa longueur d\'onde.\n'
            'b) Calcule sa période.',
        'Exercice 2 : Une station de radio émet à λ = 2 m.\n'
            'a) Calcule sa fréquence.\n'
            'b) À quelle gamme appartient-elle (AM / FM / micro-ondes) ?',
        'Exercice 3 : On voit un éclair et on entend le tonnerre 5 s plus tard.\n'
            'À quelle distance est l\'orage ? (v_son = 340 m/s)',
        'Exercice 4 : Classe ces ondes de la plus grande à la plus petite longueur d\'onde :\n'
            'lumière visible — ondes radio — rayons X — infrarouges — micro-ondes',
      ],
      corrections: [
        'Exercice 1 : a) λ = 340/680 = 0,5 m\n'
            'b) T = 1/f = 1/680 ≈ 1,47×10⁻³ s = 1,47 ms',
        'Exercice 2 : a) f = c/λ = (3×10⁸)/2 = 1,5×10⁸ Hz = 150 MHz\n'
            'b) FM (87,5 MHz à 108 MHz) — proche de cette bande',
        'Exercice 3 : d = 340×5 = 1700 m = 1,7 km',
        'Exercice 4 : Ondes radio > micro-ondes > infrarouges > lumière visible > rayons X',
      ],
      conclusion: 'Les ondes sont le fondement des communications modernes. '
          'La 5G, le WiFi, la radio — tout repose sur la relation v = λ×f. '
          'Au Burkina Faso, la téléphonie mobile a "sauté" les infrastructures fixes '
          'grâce aux ondes radio. La physique des ondes est la physique de notre avenir !',
    ),
    OfflineLesson(
      id: 'pc_ter_01',
      matiere: 'Physique-Chimie',
      niveau: 'Terminale',
      titre: 'La thermodynamique — Énergie, chaleur et travail',
      objectifs: [
        'Maîtriser les concepts d\'énergie interne, chaleur et travail',
        'Appliquer le premier et deuxième principe de la thermodynamique',
        'Comprendre les machines thermiques et leur rendement',
      ],
      introduction:
          'La thermodynamique étudie les échanges d\'énergie entre les systèmes. '
          'Les moteurs de voitures, les climatiseurs, les panneaux solaires thermiques — '
          'tout obéit aux lois de la thermodynamique. '
          'Dans un pays ensoleillé comme le Burkina Faso, '
          'ces lois sont clés pour l\'énergie solaire.',
      cours: 'CONCEPTS DE BASE\n\n'
          '• Système : partie de l\'univers qu\'on étudie\n'
          '• Milieu extérieur : tout ce qui n\'est pas le système\n'
          '• Énergie interne (U) : énergie totale des molécules du système (J)\n'
          '• Chaleur (Q) : énergie échangée par contact thermique\n'
          '  - Q > 0 : le système reçoit de la chaleur\n'
          '  - Q < 0 : le système cède de la chaleur\n'
          '• Travail (W) : énergie échangée par action mécanique\n'
          '  - W > 0 : le système reçoit du travail\n'
          '  - W < 0 : le système fournit du travail\n\n'
          'PREMIER PRINCIPE — CONSERVATION DE L\'ÉNERGIE\n\n'
          'ΔU = Q + W\n\n'
          '(La variation d\'énergie interne = somme de la chaleur et du travail échangés)\n\n'
          'Cas particuliers :\n'
          '• Transformation adiabatique : Q = 0 → ΔU = W\n'
          '• Transformation isochore (volume constant) : W = 0 → ΔU = Q\n'
          '• Transformation cyclique : ΔU = 0 → Q + W = 0\n\n'
          'DEUXIÈME PRINCIPE — ENTROPIE\n\n'
          'L\'entropie (S) est une mesure du "désordre" d\'un système.\n'
          'ΔS ≥ 0 pour un système isolé (l\'entropie ne peut qu\'augmenter)\n\n'
          'Conséquences :\n'
          '• La chaleur passe spontanément du chaud vers le froid (jamais l\'inverse)\n'
          '• Aucune machine ne peut être 100% efficace\n\n'
          'LES MACHINES THERMIQUES\n\n'
          'Une machine thermique prend de la chaleur d\'une source chaude (T_C),\n'
          'produit du travail (W) et rejette de la chaleur vers la source froide (T_F).\n\n'
          'RENDEMENT (η) :\n'
          'η = W_utile / Q_absorbé = 1 - Q_rejeté / Q_absorbé\n\n'
          'RENDEMENT DE CARNOT (maximum théorique) :\n'
          'η_Carnot = 1 - T_F/T_C   (températures en Kelvin !)\n'
          'T(K) = T(°C) + 273\n\n'
          'Applications :\n'
          '• Moteur à essence : η ≈ 25-35%\n'
          '• Centrale thermique : η ≈ 35-45%\n'
          '• Panneau solaire thermique : η ≈ 15-20%',
      exemples: [
        'Moteur Carnot entre 400°C (673K) et 20°C (293K) :\n'
            'η_Carnot = 1 - 293/673 ≈ 0,565 = 56,5%',
        'Un gaz reçoit Q = 500 J et est comprimé (W = -200 J) :\n'
            'ΔU = 500 + (-200) = 300 J',
        'Réfrigérateur : pompe la chaleur de l\'intérieur froid vers l\'extérieur chaud '
            '(nécessite du travail extérieur → 2ème principe)',
        'Panneau solaire à Ouagadougou : absorbe ~1000 W/m² de rayonnement solaire',
      ],
      exercices: [
        'Exercice 1 : Un gaz reçoit Q = 800 J de chaleur et fournit W = 300 J de travail.\n'
            'Calcule la variation d\'énergie interne ΔU.',
        'Exercice 2 : Un moteur thermique absorbe Q_C = 2000 J et rejette Q_F = 1400 J.\n'
            'a) Calcule le travail produit W.\n'
            'b) Calcule le rendement η.\n'
            'c) Ce moteur fonctionne entre 500°C et 25°C. '
            'Quel est le rendement de Carnot ?',
        'Exercice 3 : Pourquoi un réfrigérateur ne peut-il pas refroidir une cuisine\n'
            'si on laisse sa porte ouverte ? (Utilise le 2ème principe)',
        'Exercice 4 : Un panneau solaire thermique de 2 m² avec η = 18% reçoit\n'
            '900 W/m² de rayonnement. Quelle puissance utile produit-il ?',
      ],
      corrections: [
        'Exercice 1 : W = -300 J (le système fournit du travail).\n'
            'ΔU = Q + W = 800 + (-300) = 500 J',
        'Exercice 2 : a) W = Q_C - Q_F = 2000 - 1400 = 600 J\n'
            'b) η = 600/2000 = 0,30 = 30%\n'
            'c) T_C = 773K, T_F = 298K. η_Carnot = 1 - 298/773 ≈ 0,614 = 61,4%',
        'Exercice 3 : Le réfrigérateur pompe la chaleur intérieure et la rejette à l\'arrière.\n'
            'Porte ouverte : il refroidit l\'intérieur mais réchauffe encore plus la cuisine.\n'
            'Bilan net : la cuisine se réchauffe (moteur dégage toujours plus de chaleur\n'
            'qu\'il n\'en absorbe — 2ème principe).',
        'Exercice 4 : P_reçue = 900 × 2 = 1800 W. P_utile = 1800 × 0,18 = 324 W',
      ],
      conclusion: 'La thermodynamique est la physique de l\'énergie. '
          'Dans un Burkina Faso où l\'accès à l\'électricité reste un défi, '
          'comprendre les machines thermiques et l\'énergie solaire est stratégique. '
          'Le soleil fournit 1000 W/m² à Ouagadougou — '
          'la physique est notre alliée pour l\'indépendance énergétique !',
    ),
  ];
}
