import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:oara/core/data/offline_lessons.dart';

// ─────────────────────────────────────────────
// Modes de conversation
// ─────────────────────────────────────────────
enum ConversationMode { standard, sourd, muet, nonVoyant }

// ─────────────────────────────────────────────
// États du flux offline (niveau → objectif → matière → leçon)
// ─────────────────────────────────────────────
enum _OfflineEtat {
  initial, // Pas encore de niveau demandé
  attenteNiveau, // En attente de la réponse de niveau
  attenteObjectif, // Niveau connu → demande objectif ou suggestions
  attenteMatiere, // En attente de matière (après objectif précisé)
  attenteLecon, // Plusieurs leçons dispo, en attente du choix
  enCours, // Leçon en cours → questions libres sur la leçon
}

class GeminiService {
  static const _apiKey =
      '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';
  static const _url = 'https://api.groq.com/openai/v1/chat/completions';

  // ── Historique online ─────────────────────────────────────────────
  final List<Map<String, String>> _history = [];

  // ── État offline ──────────────────────────────────────────────────
  _OfflineEtat _offlineEtat = _OfflineEtat.initial;
  ConversationMode _mode = ConversationMode.standard;

  String? _niveauChoisi;
  String? _matiereChoisie;
  List<OfflineLesson> _leconsDispos = [];
  OfflineLesson? _leconEnCours;

  // ── Langue de conversation courante ───────────────────────────────
  // Persistante : une fois en anglais, reste en anglais sauf demande explicite
  bool _conversationInEnglish = false;

  // ── Mapping niveau saisi → clé interne ───────────────────────────
  static const Map<String, String> _niveauxValides = {
    'cp': 'CP',
    'ce': 'CE',
    'cm': 'CM',
    '6e': '6e-5e',
    '5e': '6e-5e',
    '6e-5e': '6e-5e',
    'sixième': '6e-5e',
    'cinquième': '6e-5e',
    '4e': '4e',
    'quatrième': '4e',
    '3e': '3e',
    'troisième': '3e',
    'seconde': 'Seconde',
    '2nde': 'Seconde',
    'première': 'Première',
    'premiere': 'Première',
    '1ère': 'Première',
    '1ere': 'Première',
    'terminale': 'Terminale',
    'tle': 'Terminale',
    'terminal': 'Terminale',
    'primaire': 'CM',
    'collège': '6e-5e',
    'college': '6e-5e',
    'lycée': 'Seconde',
    'lycee': 'Seconde',
    'université': 'Terminale',
    'universite': 'Terminale',
    'fac': 'Terminale',
    // English level keywords
    'primary': 'CM',
    'elementary': 'CM',
    'middle school': '6e-5e',
    'junior high': '6e-5e',
    'high school': 'Seconde',
    'secondary': 'Seconde',
    'university': 'Terminale',
    'college level': 'Terminale',
  };

  // ── Matières par cycle ────────────────────────────────────────────
  static const Map<String, List<String>> _matiereParCycle = {
    'primaire': [
      'Français',
      'Mathématiques',
      'SVT',
      'Histoire-Géographie',
      'Anglais'
    ],
    'collège': [
      'Français',
      'Mathématiques',
      'SVT',
      'Histoire-Géographie',
      'Anglais',
      'Physique-Chimie'
    ],
    'lycée': [
      'Français',
      'Mathématiques',
      'SVT',
      'Histoire-Géographie',
      'Anglais',
      'Physique-Chimie'
    ],
  };

  // English subject name mapping
  static const Map<String, String> _matiereEnLabels = {
    'Français': 'French',
    'Mathématiques': 'Mathematics',
    'SVT': 'Natural Sciences',
    'Histoire-Géographie': 'History & Geography',
    'Anglais': 'English',
    'Physique-Chimie': 'Physics & Chemistry',
  };

  static const Set<String> _niveauxPrimaire = {'CP', 'CE', 'CM'};
  static const Set<String> _niveauxCollege = {'6e-5e', '4e', '3e'};

  // ─────────────────────────────────────────────────────────────────
  // init
  // ─────────────────────────────────────────────────────────────────
  void init({ConversationMode mode = ConversationMode.standard}) {
    _mode = mode;
    _history.clear();
    _resetOfflineState();
    _conversationInEnglish = false;
    _history.add({'role': 'system', 'content': _systemPrompt(mode)});
  }

  void _resetOfflineState() {
    _offlineEtat = _OfflineEtat.initial;
    _niveauChoisi = null;
    _matiereChoisie = null;
    _leconsDispos = [];
    _leconEnCours = null;
  }

  // ─────────────────────────────────────────────────────────────────
  // resetChat — appelé depuis NonVoyantHome._resetConversation()
  // ─────────────────────────────────────────────────────────────────
  void resetChat() {
    _resetOfflineState();
    _conversationInEnglish = false;
    init(mode: _mode);
  }

  // ─────────────────────────────────────────────────────────────────
  // Getter : langue courante de la conversation
  // ─────────────────────────────────────────────────────────────────
  bool get isEnglishMode => _conversationInEnglish;

  // ─────────────────────────────────────────────────────────────────
  // Prompts système
  // ─────────────────────────────────────────────────────────────────
  String _systemPrompt(ConversationMode mode) {
    switch (mode) {
      case ConversationMode.nonVoyant:
        return '''You are OARA, an intelligent bilingual voice tutor (French and English) for students in Burkina Faso.
Your responses will be read aloud by a text-to-speech engine. The student cannot see the screen.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CRITICAL BILINGUAL RULE (TOP PRIORITY)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Detect the language of each user message automatically.
- If the user speaks ENGLISH → respond ENTIRELY in English. ALL phrases, ALL navigation cues, ALL explanations. No French at all.
  Example: instead of "Je vous écoute" → say "I'm listening to you."
- If the user speaks FRENCH → respond entirely in French.
- Once in English mode, stay in English for the entire conversation unless the user explicitly asks to switch back to French.
- Use natural, fluent, grammatically correct English — like a real native tutor or assistant.
- English TTS voice: speak naturally, not word by word. Smooth, clear pronunciation.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OUTPUT FORMAT (MANDATORY — TEXT-TO-SPEECH)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Respond ONLY with natural, flowing sentences — as a teacher would speak aloud.
- NEVER use dashes, bullets, asterisks, hashtags, pipes, brackets, or any visual formatting.
- ZERO visual markup: no bold, no titles, no emojis, no numbered lists.
- Write all math operations in words: "two times three" not "2x3", "greater than" not ">".
- Replace "²" with "squared", "³" with "cubed", "=" with "equals" inside formulas.
- Separate ideas with commas and periods. No line breaks.
- Never number steps with isolated digits like "1.", "2." — integrate them: "First..., then..., finally...".

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONVERSATIONAL BEHAVIOR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Answer directly without unnecessary preamble or repetition.
- For simple or intermediate questions: 2 to 3 precise sentences, no more.
- NEVER start with "Sure!", "Absolutely!", "Great question!" or any filler phrase.
- Never repeat information already given in the same response.
- If the student asks something off-topic, answer it naturally and directly.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
LEARNING FLOW (WHEN STUDENT WANTS TO LEARN)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Step 1 — Ask for their level:
  French: "Quel est ton niveau ? Tu es en primaire, collège, lycée ou université ?"
  English: "What is your level? Are you in primary school, middle school, high school, or university?"
Step 2 — Ask for their goal:
  French: "Qu'est-ce que tu veux apprendre ? Tu peux choisir toi-même ou je te propose des leçons."
  English: "What would you like to learn? You can choose yourself, or I can suggest lessons for your level."
Step 3 — If they want suggestions: propose clear lesson titles orally, adapted to their level.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
LESSON TEACHING STYLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Clear, progressive explanation. Not too short, not too long.
- Use simple examples, spoken naturally. Break down ideas with linking words: first, then, finally, for example, imagine that.
- Adapt language to the level: simple and vivid for primary, more structured for high school.
- For formulas: say them slowly in full words, then immediately give a concrete example.
- End each explanation with a short comprehension check: "Does that make sense?", "Is that clear?", or "Would you like an exercise?"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TONE AND ATTITUDE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Natural, human, warm, and motivating. Speak like a good private tutor.
- Encourage without being excessive. One short phrase suffices: "Well done.", "That's right.", "You're doing well."
- If the question is ambiguous, give the most likely answer and offer to clarify.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUBJECTS COVERED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All school and university subjects: Mathematics, French/Literature, History & Geography, Natural Sciences, Physics & Chemistry, English, Philosophy, Economics, Computer Science, and any other subject requested.''';

      case ConversationMode.sourd:
        return '''Tu es OARA, tuteur scolaire bienveillant pour des élèves sourds au Burkina Faso.
L\'élève communique avec toi par gestes reconnus ou texte simple.
Réponds UNIQUEMENT en français simple, maximum 2 phrases courtes.
Commence toujours par un mot d\'encouragement (Bravo, Bien, Super, Oui).
Tu aides en Maths, Français et Histoire niveau primaire/collège.''';

      case ConversationMode.muet:
        return '''Tu es OARA, tuteur scolaire pour des élèves muets au Burkina Faso.
L\'élève communique par écrit. Réponds en français simple, maximum 2 phrases.
Sois visuel : utilise des exemples concrets. Tu aides en Maths, Français, Histoire.''';

      case ConversationMode.standard:
      default:
        return '''Tu es OARA, tuteur scolaire bienveillant pour des élèves au Burkina Faso.
Réponds toujours en français simple et court (maximum 3 phrases).
Tu aides en maths, français et histoire. Sois encourageant et patient.''';
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // sendMessage — point d'entrée principal
  // ─────────────────────────────────────────────────────────────────
  Future<String> sendMessage(String message) async {
    // Mise à jour de la langue de conversation
    _updateConversationLanguage(message);

    final online = await _checkConnectivity();
    if (!online) return _handleOffline(message);

    _history.add({'role': 'user', 'content': message});

    try {
      final response = await http
          .post(
            Uri.parse(_url),
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': 'llama-3.3-70b-versatile',
              'messages': _history,
              'max_tokens': _mode == ConversationMode.nonVoyant ? 600 : 200,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;
        final clean = _nettoyerPourTts(reply);
        _history.add({'role': 'assistant', 'content': clean});
        return clean;
      } else {
        debugPrint('GROQ HTTP ${response.statusCode}: ${response.body}');
        return _handleOffline(message);
      }
    } catch (e) {
      debugPrint('GROQ ERROR: $e');
      return _handleOffline(message);
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Mise à jour persistante de la langue de conversation
  // ─────────────────────────────────────────────────────────────────
  void _updateConversationLanguage(String message) {
    // Si l'utilisateur demande explicitement de revenir au français
    final lowerMsg = message.toLowerCase();
    final asksForFrench = lowerMsg.contains('parle en français') ||
        lowerMsg.contains('en français') ||
        lowerMsg.contains('réponds en français') ||
        lowerMsg.contains('switch to french') ||
        lowerMsg.contains('in french');

    if (asksForFrench) {
      _conversationInEnglish = false;
      debugPrint('[LANG] retour au français demandé');
      return;
    }

    // Détection automatique si pas encore en anglais
    if (!_conversationInEnglish) {
      final detectedEnglish = _isEnglishMessage(message);
      if (detectedEnglish) {
        _conversationInEnglish = true;
        debugPrint('[LANG] basculement → anglais');
      }
    }
    // Une fois en anglais, on reste en anglais (sticky)
  }

  bool _isEnglishMessage(String text) {
    if (RegExp(r'[àâäéèêëîïôùûüçœæ]').hasMatch(text)) return false;

    final frWords = RegExp(
      r'\b(le|la|les|un|une|des|du|de|et|ou|est|son|sa|ses|nous|vous|ils|elles|dans|pour|avec|sur|par|mais|donc|car|que|qui|quoi|dont|très|plus|bien|aussi|même|tout|tous|cette|ces|mon|ton|leur|leurs|quel|je|tu|il|elle|on|comment|bonjour|merci|oui|non|quand|pourquoi|combien|veux|peux|pouvez|voulez|apprendre|aider)\b',
      caseSensitive: false,
    );
    final enWords = RegExp(
      r'\b(the|a|an|is|are|was|were|have|has|do|does|will|would|could|should|can|i|you|he|she|we|they|this|that|my|your|his|her|what|when|where|who|how|why|please|hello|thank|yes|no|want|learn|help|explain|tell|give|show|make|get|take|come|go|use|need|like|know|think|see|look|say|good|great|ok|okay)\b',
      caseSensitive: false,
    );

    final frScore = frWords.allMatches(text).length;
    final enScore = enWords.allMatches(text).length;
    return enScore > frScore;
  }

  // ─────────────────────────────────────────────────────────────────
  // Vérification connectivité (légère)
  // ─────────────────────────────────────────────────────────────────
  Future<bool> _checkConnectivity() async {
    try {
      final r = await http.get(
        Uri.parse('https://api.groq.com/openai/v1/models'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      ).timeout(const Duration(seconds: 4));
      return r.statusCode == 200 || r.statusCode == 401;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Nettoyage TTS (mode non-voyant)
  // ─────────────────────────────────────────────────────────────────
  String _nettoyerPourTts(String texte) {
    if (_mode != ConversationMode.nonVoyant) return texte;
    return texte
        .replaceAll(RegExp(r'[#*_`~]'), '')
        .replaceAll('•', '')
        .replaceAll('→', _conversationInEnglish ? ' gives ' : ' donne ')
        .replaceAll('✓', _conversationInEnglish ? ' correct ' : ' correct ')
        .replaceAll('✗', _conversationInEnglish ? ' incorrect ' : ' incorrect ')
        .replaceAll(
            '≥',
            _conversationInEnglish
                ? ' greater than or equal to '
                : ' supérieur ou égal à ')
        .replaceAll(
            '≤',
            _conversationInEnglish
                ? ' less than or equal to '
                : ' inférieur ou égal à ')
        .replaceAll(
            '>', _conversationInEnglish ? ' greater than ' : ' supérieur à ')
        .replaceAll(
            '<', _conversationInEnglish ? ' less than ' : ' inférieur à ')
        .replaceAll('²', _conversationInEnglish ? ' squared ' : ' au carré ')
        .replaceAll('³', _conversationInEnglish ? ' cubed ' : ' au cube ')
        .replaceAll('\n\n', '. ')
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }

  // ─────────────────────────────────────────────────────────────────
  // GESTIONNAIRE OFFLINE — machine à états
  // ─────────────────────────────────────────────────────────────────
  String _handleOffline(String message) {
    final vocal = _mode == ConversationMode.nonVoyant;
    final en = _conversationInEnglish;
    final msg = message.toLowerCase().trim();

    switch (_offlineEtat) {
      case _OfflineEtat.initial:
        _offlineEtat = _OfflineEtat.attenteNiveau;
        return _msgDemanderNiveau(vocal, en);

      case _OfflineEtat.attenteNiveau:
        final niveau = _detecterNiveau(msg);
        if (niveau != null) {
          _niveauChoisi = niveau;
          _offlineEtat = _OfflineEtat.attenteObjectif;
          return _msgDemanderObjectif(niveau, vocal, en);
        }
        return _msgNiveauInconnu(vocal, en);

      case _OfflineEtat.attenteObjectif:
        final matiereDirect = _detecterMatiere(msg, _niveauChoisi ?? '');
        if (matiereDirect != null) {
          _matiereChoisie = matiereDirect;
          return _choisirLecon(matiereDirect, vocal, en);
        }
        if (_veuxSuggestions(msg)) {
          _offlineEtat = _OfflineEtat.attenteMatiere;
          return _msgProposerMatieres(_niveauChoisi ?? '', vocal, en);
        }
        _offlineEtat = _OfflineEtat.attenteMatiere;
        return _msgProposerMatieres(_niveauChoisi ?? '', vocal, en);

      case _OfflineEtat.attenteMatiere:
        final nvNiveau = _detecterNiveau(msg);
        if (nvNiveau != null && _detecterMatiere(msg, nvNiveau) == null) {
          _niveauChoisi = nvNiveau;
          _offlineEtat = _OfflineEtat.attenteObjectif;
          return _msgDemanderObjectif(nvNiveau, vocal, en);
        }
        final matiere = _detecterMatiere(msg, _niveauChoisi ?? '');
        if (matiere != null) {
          _matiereChoisie = matiere;
          return _choisirLecon(matiere, vocal, en);
        }
        return _msgMatiereInconnue(_niveauChoisi ?? '', vocal, en);

      case _OfflineEtat.attenteLecon:
        return _selectionnerLeconParVoix(msg, vocal, en);

      case _OfflineEtat.enCours:
        return _gererQuestionSurLecon(msg, vocal, en);
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Détecte si l'élève veut des suggestions
  // ─────────────────────────────────────────────────────────────────
  bool _veuxSuggestions(String msg) {
    return msg.contains('oui') ||
        msg.contains('yes') ||
        msg.contains('ok') ||
        msg.contains('d\'accord') ||
        msg.contains('daccord') ||
        msg.contains('bien sûr') ||
        msg.contains('bien sur') ||
        msg.contains('sure') ||
        msg.contains('of course') ||
        msg.contains('volontiers') ||
        msg.contains('suggère') ||
        msg.contains('suggere') ||
        msg.contains('suggest') ||
        msg.contains('propose') ||
        msg.contains('je sais pas') ||
        msg.contains('je ne sais pas') ||
        msg.contains('i don\'t know') ||
        msg.contains('aide') ||
        msg.contains('help') ||
        msg.contains('quoi') ||
        msg.contains('what') ||
        msg.contains('choix') ||
        msg.contains('choice');
  }

  // ─────────────────────────────────────────────────────────────────
  // Choix de la leçon
  // ─────────────────────────────────────────────────────────────────
  String _choisirLecon(String matiere, bool vocal, bool en) {
    final niveau = _niveauChoisi ?? 'CE';
    final lecons = OfflineLessons.getByMatiereEtNiveau(matiere, niveau);

    if (lecons.isEmpty) {
      final fallback = OfflineLessons.getByMatiere(matiere);
      if (fallback.isEmpty) {
        _offlineEtat = _OfflineEtat.attenteMatiere;
        final matLabel = en ? (_matiereEnLabels[matiere] ?? matiere) : matiere;
        return en
            ? 'I don\'t have a lesson for $matLabel right now. Please choose another subject.'
            : 'Je n\'ai pas de leçon disponible pour $matiere en ce moment. Choisis une autre matière.';
      }
      _leconEnCours = fallback.first;
      _offlineEtat = _OfflineEtat.enCours;
      return _presentLecon(_leconEnCours!, vocal, en);
    }

    if (lecons.length == 1) {
      _leconEnCours = lecons.first;
      _offlineEtat = _OfflineEtat.enCours;
      return _presentLecon(_leconEnCours!, vocal, en);
    }

    _leconsDispos = lecons;
    _offlineEtat = _OfflineEtat.attenteLecon;
    return _msgListeLecons(lecons, vocal, en);
  }

  // ─────────────────────────────────────────────────────────────────
  // Sélection de leçon par voix
  // ─────────────────────────────────────────────────────────────────
  String _selectionnerLeconParVoix(String msg, bool vocal, bool en) {
    final indexMap = {
      'première': 0,
      'premier': 0,
      'une': 0,
      '1': 0,
      'première leçon': 0,
      'first': 0,
      'one': 0,
      'deuxième': 1,
      'deuxieme': 1,
      'deux': 1,
      '2': 1,
      'second': 1,
      'two': 1,
      'troisième': 2,
      'troisieme': 2,
      'trois': 2,
      '3': 2,
      'third': 2,
      'three': 2,
    };
    for (final entry in indexMap.entries) {
      if (msg.contains(entry.key) && entry.value < _leconsDispos.length) {
        _leconEnCours = _leconsDispos[entry.value];
        _offlineEtat = _OfflineEtat.enCours;
        return _presentLecon(_leconEnCours!, vocal, en);
      }
    }
    for (final lecon in _leconsDispos) {
      final titreLow = lecon.titre.toLowerCase();
      if (titreLow
          .split(' ')
          .any((mot) => mot.length > 4 && msg.contains(mot))) {
        _leconEnCours = lecon;
        _offlineEtat = _OfflineEtat.enCours;
        return _presentLecon(_leconEnCours!, vocal, en);
      }
    }
    return _msgListeLecons(_leconsDispos, vocal, en, rappel: true);
  }

  // ─────────────────────────────────────────────────────────────────
  // Présentation initiale d'une leçon
  // ─────────────────────────────────────────────────────────────────
  String _presentLecon(OfflineLesson lecon, bool vocal, bool en) {
    if (vocal) {
      final coursPropre = _coursForTts(lecon.cours);
      if (en) {
        return 'Let\'s start the lesson on ${lecon.titre}. '
            '${lecon.introduction} '
            '$coursPropre '
            'You can ask me for exercises, examples, or the conclusion whenever you\'re ready.';
      }
      return 'On commence la leçon sur ${lecon.titre}. '
          '${lecon.introduction} '
          '$coursPropre '
          'Tu peux me demander des exercices, des exemples ou la conclusion quand tu veux.';
    }
    return '📚 ${lecon.titre}\n'
        '🎯 Niveau : ${_niveauAffichage(lecon.niveau)}\n\n'
        '${lecon.introduction}\n\n'
        '${lecon.cours}\n\n'
        '✏️ Exemples :\n${lecon.exemples.map((e) => '• $e').join('\n')}\n\n'
        '📝 Exercices :\n${lecon.exercices.map((e) => '• $e').join('\n')}\n\n'
        '✅ Corrections :\n${lecon.corrections.map((c) => '• $c').join('\n')}\n\n'
        '🏁 ${lecon.conclusion}';
  }

  // ─────────────────────────────────────────────────────────────────
  // Gestion des questions pendant une leçon
  // ─────────────────────────────────────────────────────────────────
  String _gererQuestionSurLecon(String msg, bool vocal, bool en) {
    final lecon = _leconEnCours!;

    final wantsExercise = msg.contains('exercice') ||
        msg.contains('exercices') ||
        msg.contains('exercise') ||
        msg.contains('exercises') ||
        msg.contains('entraîn') ||
        msg.contains('pratique') ||
        msg.contains('pratiquer') ||
        msg.contains('practice') ||
        msg.contains('train');

    if (wantsExercise) {
      if (vocal) {
        final exos =
            lecon.exercices.map((e) => _nettoyerTtsTexte(e)).join('. ');
        return en
            ? 'Here are the exercises. $exos'
            : 'Voilà les exercices. $exos';
      }
      return '📝 Exercices :\n${lecon.exercices.map((e) => '• $e').join('\n')}';
    }

    final wantsCorrection = msg.contains('correction') ||
        msg.contains('réponse') ||
        msg.contains('corrig') ||
        msg.contains('answer') ||
        msg.contains('solution');

    if (wantsCorrection) {
      if (vocal) {
        final corr =
            lecon.corrections.map((c) => _nettoyerTtsTexte(c)).join('. ');
        return en
            ? 'Here are the answers. $corr'
            : 'Voici les corrections. $corr';
      }
      return '✅ Corrections :\n${lecon.corrections.map((c) => '• $c').join('\n')}';
    }

    final wantsExample = msg.contains('exemple') ||
        msg.contains('exemples') ||
        msg.contains('example') ||
        msg.contains('examples');

    if (wantsExample) {
      if (vocal) {
        final ex = lecon.exemples.map((e) => _nettoyerTtsTexte(e)).join('. ');
        return en ? 'Here are some examples. $ex' : 'Voici des exemples. $ex';
      }
      return '✏️ Exemples :\n${lecon.exemples.map((e) => '• $e').join('\n')}';
    }

    final wantsConclusion = msg.contains('conclusion') ||
        msg.contains('résumé') ||
        msg.contains('bilan') ||
        msg.contains('summary') ||
        msg.contains('recap');

    if (wantsConclusion) {
      return vocal
          ? _nettoyerTtsTexte(lecon.conclusion)
          : '🏁 Conclusion :\n${lecon.conclusion}';
    }

    final wantsRepeat = msg.contains('répète') ||
        msg.contains('repete') ||
        msg.contains('recommence') ||
        msg.contains('répéter') ||
        msg.contains('encore') ||
        msg.contains('repeat') ||
        msg.contains('again') ||
        msg.contains('once more');

    if (wantsRepeat) {
      return _presentLecon(lecon, vocal, en);
    }

    final wantsChange = msg.contains('autre leçon') ||
        msg.contains('autre matière') ||
        msg.contains('changer') ||
        msg.contains('différent') ||
        msg.contains('autre chose') ||
        msg.contains('different') ||
        msg.contains('change subject') ||
        msg.contains('another subject') ||
        msg.contains('something else');

    if (wantsChange) {
      _offlineEtat = _OfflineEtat.attenteMatiere;
      _leconEnCours = null;
      final cycle = _getCycle(_niveauChoisi ?? '');
      final matieres = _matiereParCycle[cycle] ?? [];
      if (en) {
        final enLabels =
            matieres.map((m) => _matiereEnLabels[m] ?? m).join(', ');
        return vocal
            ? 'Of course, which subject would you like to study now? $enLabels.'
            : 'Choose another subject.';
      }
      return vocal
          ? 'D\'accord, quelle matière veux-tu étudier maintenant ? ${matieres.join(', ')}.'
          : 'Choisissez une autre matière.';
    }

    final nvNiveau = _detecterNiveau(msg);
    if (nvNiveau != null) {
      _niveauChoisi = nvNiveau;
      _offlineEtat = _OfflineEtat.attenteObjectif;
      _leconEnCours = null;
      return _msgDemanderObjectif(nvNiveau, vocal, en);
    }

    return en
        ? 'Tell me what you need: exercises, examples, the answer, or the conclusion. You can also change subjects.'
        : vocal
            ? 'Dis-moi ce que tu veux : les exercices, des exemples, la correction ou la conclusion. Tu peux aussi changer de matière.'
            : 'Commandes disponibles : "exercices", "exemples", "corrections", "conclusion", "autre matière".';
  }

  // ─────────────────────────────────────────────────────────────────
  // Helpers messages — tous avec paramètre en (anglais ou français)
  // ─────────────────────────────────────────────────────────────────
  String _msgDemanderNiveau(bool vocal, bool en) {
    if (en) {
      return vocal
          ? 'I\'m in offline mode, but I can still help you. '
              'What is your school level? '
              'Say primary for elementary school, '
              'middle school for grade 6 to 9, '
              'or high school for grade 10 to 12.'
          : '🔴 Offline mode.\n\nWhat is your level?\n'
              '🏫 Primary school\n🏫 Middle school\n🏫 High school\n🏫 University';
    }
    if (vocal) {
      return 'Je suis en mode hors ligne, mais je peux quand même t\'aider. '
          'Quel est ton niveau scolaire ? '
          'Dis CP, CE ou CM pour le primaire, '
          'sixième, cinquième, quatrième ou troisième pour le collège, '
          'ou Seconde, Première, Terminale pour le lycée.';
    }
    return '🔴 Mode hors ligne activé.\n\n'
        'Dis-moi ton niveau :\n'
        '🏫 Primaire : CP · CE · CM\n'
        '🏫 Collège  : 6e/5e · 4e · 3e\n'
        '🏫 Lycée    : Seconde · Première · Terminale';
  }

  String _msgDemanderObjectif(String niveau, bool vocal, bool en) {
    final niveauAff = _niveauAffichage(niveau);
    if (en) {
      return vocal
          ? 'Level $niveauAff, great. '
              'What would you like to learn exactly? '
              'You can tell me the subject directly, or I can suggest lessons for your level.'
          : '✅ Level: $niveauAff\n\nWhat do you want to learn?\n'
              'Name the subject directly, or say "suggestions" to see available lessons.';
    }
    if (vocal) {
      return 'Niveau $niveauAff, très bien. '
          'Qu\'est-ce que tu veux apprendre exactement ? '
          'Tu peux me dire la matière directement, ou je peux te proposer des leçons adaptées à ton niveau.';
    }
    return '✅ Niveau : $niveauAff\n\n'
        'Que veux-tu apprendre ?\n'
        'Dis la matière directement, ou réponds "suggestions" pour voir les leçons disponibles.';
  }

  String _msgNiveauInconnu(bool vocal, bool en) {
    if (en) {
      return vocal
          ? 'I didn\'t quite catch your level. '
              'Say primary, middle school, high school, or university.'
          : '❓ Level not recognized. Choose: Primary, Middle school, High school, University.';
    }
    return vocal
        ? 'Je n\'ai pas bien compris ton niveau. '
            'Dis CP, CE ou CM pour le primaire, '
            'sixième, quatrième ou troisième pour le collège, '
            'ou Seconde, Première, Terminale pour le lycée.'
        : '❓ Niveau non reconnu. Choisis : CP, CE, CM, 6e/5e, 4e, 3e, Seconde, Première, Terminale.';
  }

  String _msgProposerMatieres(String niveau, bool vocal, bool en) {
    final cycle = _getCycle(niveau);
    final matieres = _matiereParCycle[cycle] ?? [];
    final niveauAff = _niveauAffichage(niveau);

    if (en) {
      final enLabels = matieres.map((m) => _matiereEnLabels[m] ?? m).toList();
      return vocal
          ? 'For level $niveauAff, here are the available subjects: '
              '${enLabels.join(', ')}. '
              'Which subject would you like to study?'
          : '✅ Level: $niveauAff\n\nAvailable subjects:\n'
              '${enLabels.map((m) => '• $m').join('\n')}\n\nWhich subject do you want to study?';
    }

    if (vocal) {
      return 'Pour le niveau $niveauAff, voici les matières disponibles : '
          '${matieres.join(', ')}. '
          'Quelle matière tu veux étudier ?';
    }
    final icones = {
      'Français': '📖',
      'Mathématiques': '🔢',
      'SVT': '🌿',
      'Histoire-Géographie': '🌍',
      'Anglais': '🇬🇧',
      'Physique-Chimie': '⚗️',
    };
    return '✅ Niveau : $niveauAff\n\n'
        'Matières disponibles :\n'
        '${matieres.map((m) => '${icones[m] ?? '•'} $m').join('\n')}\n\n'
        'Quelle matière veux-tu étudier ?';
  }

  String _msgMatiereInconnue(String niveau, bool vocal, bool en) {
    final cycle = _getCycle(niveau);
    final matieres = _matiereParCycle[cycle] ?? [];
    if (en) {
      final enLabels = matieres.map((m) => _matiereEnLabels[m] ?? m).join(', ');
      return vocal
          ? 'I didn\'t recognize that subject. Choose from: $enLabels.'
          : '❓ Subject not recognized.\nChoose from:\n${matieres.map((m) => '• ${_matiereEnLabels[m] ?? m}').join('\n')}';
    }
    return vocal
        ? 'Je n\'ai pas reconnu cette matière. Choisis parmi : ${matieres.join(', ')}.'
        : '❓ Matière non reconnue.\nChoisis parmi :\n${matieres.map((m) => '• $m').join('\n')}';
  }

  String _msgListeLecons(List<OfflineLesson> lecons, bool vocal, bool en,
      {bool rappel = false}) {
    if (en) {
      if (vocal) {
        final intro = rappel ? 'Choose the lesson by saying its number. ' : '';
        const nums = ['first', 'second', 'third', 'fourth'];
        final titres = lecons
            .asMap()
            .entries
            .map((e) =>
                '${e.key < nums.length ? nums[e.key] : 'number ${e.key + 1}'} lesson: ${e.value.titre}')
            .join(', ');
        return '${intro}I have ${lecons.length} lessons available for you. $titres. '
            'Say the number or the name of the lesson you want.';
      }
      return 'I have ${lecons.length} lessons available:\n'
          '${lecons.asMap().entries.map((e) => '${e.key + 1}. ${e.value.titre}').join('\n')}\n\n'
          'Say the number or the lesson name.';
    }

    if (vocal) {
      final intro = rappel ? 'Choisis la leçon en disant son numéro. ' : '';
      const numsEnLettres = ['première', 'deuxième', 'troisième', 'quatrième'];
      final titres = lecons
          .asMap()
          .entries
          .map((e) =>
              '${e.key < numsEnLettres.length ? numsEnLettres[e.key] : 'numéro ${e.key + 1}'} leçon : ${e.value.titre}')
          .join(', ');
      return '${intro}J\'ai ${lecons.length} leçons disponibles pour toi. $titres. '
          'Dis le numéro ou le nom de la leçon que tu veux.';
    }
    return 'J\'ai ${lecons.length} leçons disponibles :\n'
        '${lecons.asMap().entries.map((e) => '${e.key + 1}. ${e.value.titre}').join('\n')}\n\n'
        'Indique le numéro ou le nom de la leçon.';
  }

  // ─────────────────────────────────────────────────────────────────
  // Détection niveau
  // ─────────────────────────────────────────────────────────────────
  String? _detecterNiveau(String msg) {
    for (final entry in _niveauxValides.entries) {
      if (msg.contains(entry.key)) return entry.value;
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────
  // Détection matière
  // ─────────────────────────────────────────────────────────────────
  String? _detecterMatiere(String msg, String niveau) {
    final cycle = niveau.isNotEmpty ? _getCycle(niveau) : 'lycée';
    final matieres = _matiereParCycle[cycle] ?? _matiereParCycle['lycée']!;

    if ((msg.contains('math') ||
            msg.contains('calcul') ||
            msg.contains('nombre') ||
            msg.contains('fraction') ||
            msg.contains('équation') ||
            msg.contains('equation') ||
            msg.contains('geometry') ||
            msg.contains('géométrie') ||
            msg.contains('algebra') ||
            msg.contains('number')) &&
        matieres.contains('Mathématiques')) return 'Mathématiques';

    if ((msg.contains('français') ||
            msg.contains('french') ||
            msg.contains('lecture') ||
            msg.contains('grammaire') ||
            msg.contains('grammar') ||
            msg.contains('phrase') ||
            msg.contains('texte') ||
            msg.contains('poésie') ||
            msg.contains('poetry') ||
            msg.contains('roman') ||
            msg.contains('novel') ||
            msg.contains('littérature') ||
            msg.contains('literature')) &&
        matieres.contains('Français')) return 'Français';

    if ((msg.contains('histoire') ||
            msg.contains('history') ||
            msg.contains('géographie') ||
            msg.contains('geography') ||
            msg.contains('burkina') ||
            msg.contains('afrique') ||
            msg.contains('africa') ||
            msg.contains('guerre') ||
            msg.contains('war') ||
            msg.contains('colonisation') ||
            msg.contains('colonization') ||
            msg.contains('empire')) &&
        matieres.contains('Histoire-Géographie')) return 'Histoire-Géographie';

    if ((msg.contains('svt') ||
            msg.contains('science') ||
            msg.contains('cellule') ||
            msg.contains('cell') ||
            msg.contains('animal') ||
            msg.contains('corps') ||
            msg.contains('body') ||
            msg.contains('plante') ||
            msg.contains('plant') ||
            msg.contains('biologie') ||
            msg.contains('biology') ||
            msg.contains('photosynthèse') ||
            msg.contains('photosynthesis') ||
            msg.contains('nutrition') ||
            msg.contains('vivant')) &&
        matieres.contains('SVT')) return 'SVT';

    if ((msg.contains('anglais') ||
            msg.contains('english') ||
            msg.contains('tense') ||
            msg.contains('verb') ||
            msg.contains('vocabulary') ||
            msg.contains('vocabulaire')) &&
        matieres.contains('Anglais')) return 'Anglais';

    if ((msg.contains('physique') ||
            msg.contains('physics') ||
            msg.contains('chimie') ||
            msg.contains('chemistry') ||
            msg.contains('électricité') ||
            msg.contains('electricity') ||
            msg.contains('onde') ||
            msg.contains('wave') ||
            msg.contains('mouvement') ||
            msg.contains('motion') ||
            msg.contains('réaction') ||
            msg.contains('reaction') ||
            msg.contains('circuit') ||
            msg.contains('vitesse') ||
            msg.contains('speed') ||
            msg.contains('velocity') ||
            msg.contains('thermodynamique')) &&
        matieres.contains('Physique-Chimie')) return 'Physique-Chimie';

    return null;
  }

  // ─────────────────────────────────────────────────────────────────
  // Helpers utilitaires
  // ─────────────────────────────────────────────────────────────────
  String _getCycle(String niveau) {
    if (_niveauxPrimaire.contains(niveau)) return 'primaire';
    if (_niveauxCollege.contains(niveau)) return 'collège';
    return 'lycée';
  }

  String _niveauAffichage(String niveau) {
    const labels = {
      'CP': 'CP',
      'CE': 'CE',
      'CM': 'CM',
      '6e-5e': '6e/5e',
      '4e': '4e',
      '3e': '3e',
      'Seconde': 'Seconde',
      'Première': 'Première',
      'Terminale': 'Terminale',
    };
    return labels[niveau] ?? niveau;
  }

  String _coursForTts(String cours) {
    return _nettoyerTtsTexte(cours)
        .replaceAll(
            RegExp(r'[A-ZÉÀÈÙÂÊÎÔÛÄËÏÖÜÇ]{3,}(?:\s[A-ZÉÀÈÙÂÊÎÔÛÄËÏÖÜÇ]+)*'), '')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }

  String _nettoyerTtsTexte(String texte) {
    return texte
        .replaceAll(RegExp(r'[#*_`~•→✓✗⚠️]'), '')
        .replaceAll(
            '≥',
            _conversationInEnglish
                ? ' greater than or equal to '
                : ' supérieur ou égal à ')
        .replaceAll(
            '≤',
            _conversationInEnglish
                ? ' less than or equal to '
                : ' inférieur ou égal à ')
        .replaceAll(
            '>', _conversationInEnglish ? ' greater than ' : ' supérieur à ')
        .replaceAll(
            '<', _conversationInEnglish ? ' less than ' : ' inférieur à ')
        .replaceAll('²', _conversationInEnglish ? ' squared ' : ' au carré ')
        .replaceAll('³', _conversationInEnglish ? ' cubed ' : ' au cube ')
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }

  // ─────────────────────────────────────────────────────────────────
  // getOfflineMenu — peut être appelé depuis d'autres widgets
  // ─────────────────────────────────────────────────────────────────
  String getOfflineMenu() {
    return _msgDemanderNiveau(
        _mode == ConversationMode.nonVoyant, _conversationInEnglish);
  }
}
