import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Service TTS bilingue (fr-FR / en-GB) :
/// - Détection automatique de la langue du texte
/// - Basculement fluide vers une voix anglaise native (en-GB) si le texte est en anglais
/// - Basculement automatique vers fr-FR pour le français
/// - speak() attend réellement la fin de la lecture
/// - stop() garanti avant chaque nouveau speak() (évite conflits STT/TTS)
/// - Vitesse optimisée pour accessibilité non-voyant
class TtsService extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();

  bool isSpeaking = false;
  bool isInitialized = false;

  // Langue actuellement configurée dans le moteur TTS
  String _currentLang = 'fr-FR';

  Completer<void>? _speakCompleter;

  // ── Paramètres par langue ──────────────────────────────────────────
  static const _langFr = 'fr-FR';
  static const _langEn = 'en-GB';

  static const _rateFr = 0.50;
  static const _rateEn = 0.48;

  static const _pitchFr = 1.05;
  static const _pitchEn = 1.00;

  // ─────────────────────────────────────────────────────────────────
  // Init
  // ─────────────────────────────────────────────────────────────────
  Future<void> init() async {
    debugPrint('[TTS] ── init()');

    await _applyLangConfig(_langFr);

    _tts.setStartHandler(() {
      debugPrint('[TTS] ▶ début lecture');
      isSpeaking = true;
      notifyListeners();
    });

    _tts.setCompletionHandler(() {
      debugPrint('[TTS] ■ lecture terminée');
      isSpeaking = false;
      _completeSpeak();
      notifyListeners();
    });

    _tts.setErrorHandler((err) {
      debugPrint('[TTS] ✗ erreur : $err');
      isSpeaking = false;
      _completeSpeak();
      notifyListeners();
    });

    _tts.setCancelHandler(() {
      debugPrint('[TTS] ✗ annulé');
      isSpeaking = false;
      _completeSpeak();
      notifyListeners();
    });

    isInitialized = true;
    notifyListeners();
    debugPrint('[TTS] prêt');
  }

  // ─────────────────────────────────────────────────────────────────
  // Applique la configuration TTS pour une langue donnée
  // ─────────────────────────────────────────────────────────────────
  Future<void> _applyLangConfig(String lang) async {
    final rate = lang == _langEn ? _rateEn : _rateFr;
    final pitch = lang == _langEn ? _pitchEn : _pitchFr;

    await _tts.setLanguage(lang);
    await _tts.setSpeechRate(rate);
    await _tts.setVolume(1.0);
    await _tts.setPitch(pitch);

    _currentLang = lang;
    debugPrint('[TTS] langue → $lang (rate=$rate, pitch=$pitch)');
  }

  // ─────────────────────────────────────────────────────────────────
  // Détection automatique de la langue du texte (seuil assoupli)
  // ─────────────────────────────────────────────────────────────────
  String _detectLanguage(String text) {
    // Accents français → français garanti
    final hasAccents = RegExp(r'[àâäéèêëîïôùûüçœæ]').hasMatch(text);
    if (hasAccents) return _langFr;

    final frenchPatterns = RegExp(
      r"\b(le|la|les|un|une|des|du|de|et|ou|est|son|sa|ses|nous|vous|ils|elles|dans|pour|avec|sur|par|mais|donc|car|ni|que|qui|quoi|dont|où|très|plus|bien|aussi|même|tout|tous|toute|toutes|cette|ces|mon|ton|leur|leurs|quel|quelle|je|tu|il|elle|on|oui|non|merci|bonjour)\b",
      caseSensitive: false,
    );

    final englishPatterns = RegExp(
      r"\b(the|a|an|is|are|was|were|be|been|have|has|had|do|does|did|will|would|could|should|may|might|shall|can|i|you|he|she|it|we|they|this|that|these|those|my|your|his|her|its|our|their|what|when|where|who|how|why|which|there|here|some|any|all|no|not|and|or|but|if|then|because|so|than|as|at|by|for|in|of|on|to|up|with|about|after|before|during|through|between|yes|hello|thanks|please|okay|ok|let|me|think|listening|i'm|i've|i'll|great|well|done)\b",
      caseSensitive: false,
    );

    final frMatches = frenchPatterns.allMatches(text).length;
    final enMatches = englishPatterns.allMatches(text).length;

    debugPrint('[TTS] détection langue : fr=$frMatches, en=$enMatches');

    // Seuil simple : anglais si enMatches > frMatches
    if (enMatches > frMatches) return _langEn;
    return _langFr;
  }

  // ─────────────────────────────────────────────────────────────────
  // speak() — détecte la langue, configure la voix, lit le texte
  // ─────────────────────────────────────────────────────────────────
  Future<void> speak(String text) async {
    if (!isInitialized || text.trim().isEmpty) return;

    final preview = text.length > 60 ? '${text.substring(0, 60)}…' : text;
    debugPrint('[TTS] speak → "$preview"');

    await stop();

    final targetLang = _detectLanguage(text);
    if (targetLang != _currentLang) {
      await _applyLangConfig(targetLang);
    }

    _speakCompleter = Completer<void>();

    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('[TTS] ✗ exception speak() : $e');
      _completeSpeak();
      return;
    }

    await _speakCompleter!.future;
    debugPrint('[TTS] speak() terminé');
  }

  // ─────────────────────────────────────────────────────────────────
  // speakWithLang() — forcer une langue explicitement (usage avancé)
  // ─────────────────────────────────────────────────────────────────
  Future<void> speakWithLang(String text, {bool isEnglish = false}) async {
    if (!isInitialized || text.trim().isEmpty) return;

    await stop();

    final targetLang = isEnglish ? _langEn : _langFr;
    if (targetLang != _currentLang) {
      await _applyLangConfig(targetLang);
    }

    _speakCompleter = Completer<void>();
    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('[TTS] ✗ exception speakWithLang() : $e');
      _completeSpeak();
      return;
    }

    await _speakCompleter!.future;
  }

  // ─────────────────────────────────────────────────────────────────
  // speakFrench() — forcer le français (phrases de navigation)
  // ─────────────────────────────────────────────────────────────────
  Future<void> speakFrench(String text) async {
    await speakWithLang(text, isEnglish: false);
  }

  // ─────────────────────────────────────────────────────────────────
  // speakEnglish() — forcer l'anglais explicitement
  // ─────────────────────────────────────────────────────────────────
  Future<void> speakEnglish(String text) async {
    await speakWithLang(text, isEnglish: true);
  }

  // ─────────────────────────────────────────────────────────────────
  // stop() — arrêt immédiat
  // ─────────────────────────────────────────────────────────────────
  Future<void> stop() async {
    if (!isInitialized) return;
    if (isSpeaking) {
      debugPrint('[TTS] stop()');
      await _tts.stop();
      await Future.delayed(const Duration(milliseconds: 80));
    }
    isSpeaking = false;
    _completeSpeak();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────
  void _completeSpeak() {
    if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
      _speakCompleter!.complete();
    }
    _speakCompleter = null;
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
