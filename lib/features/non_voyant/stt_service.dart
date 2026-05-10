import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service STT bilingue (fr_FR / en_GB) :
/// - Détection automatique de la langue souhaitée avant l'écoute
/// - Basculement dynamique du localeId selon la langue courante
/// - Écoute jusqu'à 30 secondes (longues phrases)
/// - Arrêt auto après 3s de silence (pauseFor)
/// - Timeout global 30s anti-blocage absolu
/// - Push-to-talk via stopListening()
/// - Mode dictation pour les phrases continues
class SttService extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();

  bool isAvailable = false;
  bool isListening = false;
  String lastResult = '';
  String statusMessage = 'Initialisation...';

  /// Langue active pour la prochaine écoute (fr_FR par défaut)
  String _currentLocale = 'fr_FR';

  static const _locFr = 'fr_FR';
  static const _locEn =
      'en_GB'; // en_GB = accent neutre, meilleur pour apprenants

  static const _silenceTimeout = Duration(seconds: 3);
  static const _maxListenDuration = Duration(seconds: 30);

  Completer<String>? _activeCompleter;
  Timer? _globalTimer;

  // ─────────────────────────────────────────────────────────────────
  // Init
  // ─────────────────────────────────────────────────────────────────
  Future<bool> init() async {
    debugPrint('[STT] ── init()');

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      statusMessage = 'Permission micro refusée';
      debugPrint('[STT] ✗ permission refusée');
      notifyListeners();
      return false;
    }

    isAvailable = await _speech.initialize(
      debugLogging: false,
      onError: (err) {
        debugPrint(
            '[STT] ✗ erreur : ${err.errorMsg} (permanent=${err.permanent})');
        isListening = false;
        statusMessage = 'Erreur: ${err.errorMsg}';
        _resolveCompleter(lastResult);
        notifyListeners();
      },
      onStatus: (s) {
        debugPrint('[STT] status → $s');
        statusMessage = s;
        if (s == 'done' || s == 'notListening') {
          isListening = false;
          _resolveCompleter(lastResult);
          notifyListeners();
        }
      },
    );

    debugPrint('[STT] disponible = $isAvailable');
    statusMessage = isAvailable ? 'Prêt' : 'STT non disponible';
    notifyListeners();
    return isAvailable;
  }

  // ─────────────────────────────────────────────────────────────────
  // setLocale — appelé depuis NonVoyantHome quand la langue est connue
  // ─────────────────────────────────────────────────────────────────
  void setLocale(String locale) {
    if (locale != _currentLocale) {
      _currentLocale = locale;
      debugPrint('[STT] locale → $_currentLocale');
    }
  }

  void setEnglish() => setLocale(_locEn);
  void setFrench() => setLocale(_locFr);

  bool get isEnglishMode => _currentLocale == _locEn;

  // ─────────────────────────────────────────────────────────────────
  // listenAndGetResult — écoute dans la langue courante
  // ─────────────────────────────────────────────────────────────────
  Future<String> listenAndGetResult() async {
    if (!isAvailable) {
      debugPrint('[STT] ✗ non disponible');
      return '';
    }

    await _forceStop();

    lastResult = '';
    isListening = true;
    statusMessage = 'Écoute en cours...';
    notifyListeners();

    _activeCompleter = Completer<String>();

    // Failsafe absolu
    _globalTimer = Timer(_maxListenDuration, () {
      debugPrint('[STT] ⏱ timeout 30s — résultat = "$lastResult"');
      _resolveCompleter(lastResult);
    });

    debugPrint('[STT] ▶ écoute (locale=$_currentLocale, '
        'silence=${_silenceTimeout.inSeconds}s, '
        'max=${_maxListenDuration.inSeconds}s)');

    try {
      await _speech.listen(
        onResult: (result) {
          final words = result.recognizedWords.trim();
          if (words.isNotEmpty) {
            if (words.length >= lastResult.length || result.finalResult) {
              lastResult = words;
              notifyListeners();
            }
            debugPrint(
                '[STT] partial="${words.length > 50 ? '${words.substring(0, 50)}…' : words}" '
                '| final=${result.finalResult}');
          }
          if (result.finalResult) {
            debugPrint('[STT] ✓ FINAL : "$lastResult"');
            _resolveCompleter(lastResult);
          }
        },
        localeId: _currentLocale,
        listenFor: _maxListenDuration,
        pauseFor: _silenceTimeout,
        partialResults: true,
        cancelOnError: false,
        listenMode: ListenMode.dictation,
      );
    } catch (e) {
      debugPrint('[STT] ✗ exception listen() : $e');
      _resolveCompleter(lastResult);
    }

    final result = await _activeCompleter!.future;
    await _forceStop();

    debugPrint('[STT] ■ fin écoute → "$result"');
    return result;
  }

  // ─────────────────────────────────────────────────────────────────
  // Arrêt manuel (push-to-talk, 2ème appui)
  // ─────────────────────────────────────────────────────────────────
  Future<void> stopListening() async {
    debugPrint('[STT] stopListening() manuel — résultat : "$lastResult"');
    _resolveCompleter(lastResult);
    await _forceStop();
  }

  // ─────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────
  void _resolveCompleter(String value) {
    _globalTimer?.cancel();
    _globalTimer = null;
    if (_activeCompleter != null && !_activeCompleter!.isCompleted) {
      _activeCompleter!.complete(value);
    }
  }

  Future<void> _forceStop() async {
    _globalTimer?.cancel();
    _globalTimer = null;
    if (_speech.isListening) {
      await _speech.stop();
      await Future.delayed(const Duration(milliseconds: 120));
    }
    isListening = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    _resolveCompleter('');
    _speech.stop();
    super.dispose();
  }
}
