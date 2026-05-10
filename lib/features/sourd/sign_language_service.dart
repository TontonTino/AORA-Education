import 'dart:async';
import 'package:flutter/foundation.dart';

/// Représente une animation de signe à jouer
class SignFrame {
  final String signId; // ex: "bonjour", "merci", "aide"
  final String label; // texte affiché sous l'avatar
  final Duration duration;

  const SignFrame({
    required this.signId,
    required this.label,
    this.duration = const Duration(milliseconds: 800),
  });
}

/// Geste de l'utilisateur reconnu par MediaPipe
class DetectedGesture {
  final String name; // "Bonjour", "Oui", "Non", "Aide", "Merci"
  final double confidence;
  final DateTime detectedAt;

  const DetectedGesture({
    required this.name,
    required this.confidence,
    required this.detectedAt,
  });
}

/// Profil de l'avatar choisi par l'élève sourd
class AvatarProfile {
  final AvatarGender gender;
  final SkinTone skinTone;

  const AvatarProfile({
    required this.gender,
    required this.skinTone,
  });

  String get assetPrefix {
    final g = gender == AvatarGender.female ? 'f' : 'm';
    final s = skinTone.name; // 'light', 'medium', 'dark'
    return 'assets/avatar/${g}_${s}';
  }

  String get displayName =>
      gender == AvatarGender.female ? 'Mentora' : 'Mentor';

  String get avatarIdleAsset => '$assetPrefix/idle.png';
}

enum AvatarGender { male, female }

enum SkinTone { light, medium, dark }

/// Service qui gère la file de signes à animer et la reconnaissance des gestes
class SignLanguageService extends ChangeNotifier {
  // --- État avatar ---
  AvatarProfile _profile = const AvatarProfile(
    gender: AvatarGender.female,
    skinTone: SkinTone.dark,
  );

  AvatarProfile get profile => _profile;

  void setProfile(AvatarProfile p) {
    _profile = p;
    notifyListeners();
  }

  // --- File d'animation ---
  final List<SignFrame> _queue = [];
  SignFrame? _currentFrame;
  bool _isAnimating = false;
  Timer? _frameTimer;

  SignFrame? get currentFrame => _currentFrame;
  bool get isAnimating => _isAnimating;

  // --- Geste en cours de l'utilisateur ---
  DetectedGesture? _lastGesture;
  DetectedGesture? get lastGesture => _lastGesture;

  // --- Mapping texte → séquence de signes ---
  static const Map<String, List<String>> _wordToSigns = {
    // Salutations
    'bonjour': ['bonjour'],
    'salut': ['bonjour'],
    'bonsoir': ['bonsoir'],
    'au revoir': ['au_revoir'],
    'merci': ['merci'],
    'stp': ['stp'],
    "s'il te plaît": ['stp'],
    "s'il vous plaît": ['stp'],

    // Réponses basiques
    'oui': ['oui'],
    'non': ['non'],
    'peut-être': ['peut_etre'],
    'ok': ['oui'],

    // Maths
    'fraction': ['fraction'],
    'fractions': ['fraction'],
    'numérateur': ['numerateur'],
    'dénominateur': ['denominateur'],
    'addition': ['plus', 'egal'],
    'égal': ['egal'],
    'nombre': ['nombre'],
    'moitié': ['moitie'],
    'quart': ['quart'],
    'diviser': ['diviser'],
    'multiplier': ['multiplier'],

    // Aide / Apprentissage
    'aide': ['aide'],
    'aidez': ['aide'],
    'comprends': ['comprendre'],
    'compris': ['comprendre'],
    'répète': ['repeter'],
    'répéter': ['repeter'],
    'exemple': ['exemple'],
    'bravo': ['bravo'],
    'bien': ['bien'],
    'super': ['super'],
    'excellent': ['super'],
    'difficile': ['difficile'],
    'facile': ['facile'],
    'apprendre': ['apprendre'],
    'leçon': ['lecon'],
    'exercice': ['exercice'],
    'question': ['question'],
    'réponse': ['reponse'],

    // École
    'école': ['ecole'],
    'classe': ['classe'],
    'élève': ['eleve'],
    'professeur': ['professeur'],
    'livre': ['livre'],
    'mathématiques': ['maths'],
    'maths': ['maths'],
    'français': ['francais'],
    'histoire': ['histoire'],
  };

  // Signes qui ont un asset réel vs placeholder
  static const Set<String> _availableSigns = {
    'bonjour',
    'merci',
    'oui',
    'non',
    'aide',
    'stp',
    'fraction',
    'bravo',
    'super',
    'question',
    'reponse',
    'comprendre',
    'repeter',
    'maths',
    'francais',
    'numerateur',
    'denominateur',
    'egal',
    'plus',
  };

  /// Décompose un texte IA en séquence de SignFrames et les enfile
  void enqueueTextAsSign(String text) {
    final frames = _textToSignFrames(text);
    if (frames.isEmpty) return;

    _queue.addAll(frames);
    if (!_isAnimating) _playNext();
  }

  /// Met à jour le geste détecté (appelé par HandDetectorService)
  void updateGesture(DetectedGesture? gesture) {
    _lastGesture = gesture;
    notifyListeners();
  }

  List<SignFrame> _textToSignFrames(String text) {
    final frames = <SignFrame>[];
    final lower = text.toLowerCase();

    // Cherche les phrases clés (bi-grams d'abord)
    final words = lower.split(RegExp(r'[\s,\.!?]+'));
    final usedIndices = <int>{};

    for (int i = 0; i < words.length - 1; i++) {
      final bigram = '${words[i]} ${words[i + 1]}';
      if (_wordToSigns.containsKey(bigram)) {
        for (final sign in _wordToSigns[bigram]!) {
          frames.add(_makeFrame(sign));
        }
        usedIndices.addAll([i, i + 1]);
      }
    }

    for (int i = 0; i < words.length; i++) {
      if (usedIndices.contains(i)) continue;
      final word = words[i];
      if (_wordToSigns.containsKey(word)) {
        for (final sign in _wordToSigns[word]!) {
          frames.add(_makeFrame(sign));
        }
      }
    }

    // Si aucun signe trouvé, joue "question" comme fallback
    if (frames.isEmpty && text.contains('?')) {
      frames.add(_makeFrame('question'));
    } else if (frames.isEmpty) {
      frames.add(_makeFrame('bonjour')); // acquittement par défaut
    }

    return frames;
  }

  SignFrame _makeFrame(String signId) {
    final hasAsset = _availableSigns.contains(signId);
    return SignFrame(
      signId: hasAsset ? signId : 'placeholder',
      label: _signLabel(signId),
      duration: const Duration(milliseconds: 900),
    );
  }

  String _signLabel(String signId) {
    const labels = {
      'bonjour': 'Bonjour',
      'merci': 'Merci',
      'oui': 'Oui',
      'non': 'Non',
      'aide': 'Aide',
      'stp': "S'il te plaît",
      'fraction': 'Fraction',
      'bravo': 'Bravo !',
      'super': 'Super !',
      'question': '?',
      'reponse': 'Réponse',
      'comprendre': 'Comprendre',
      'repeter': 'Répéter',
      'maths': 'Maths',
      'francais': 'Français',
      'numerateur': 'Numérateur',
      'denominateur': 'Dénominateur',
      'egal': 'Égal',
      'plus': 'Plus',
      'placeholder': '...',
    };
    return labels[signId] ?? signId;
  }

  void _playNext() {
    if (_queue.isEmpty) {
      _currentFrame = null;
      _isAnimating = false;
      notifyListeners();
      return;
    }

    _isAnimating = true;
    _currentFrame = _queue.removeAt(0);
    notifyListeners();

    _frameTimer =
        Timer(_currentFrame!.duration + const Duration(milliseconds: 100), () {
      _playNext();
    });
  }

  void stopAnimation() {
    _frameTimer?.cancel();
    _queue.clear();
    _currentFrame = null;
    _isAnimating = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    super.dispose();
  }
}
