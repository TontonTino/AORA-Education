import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hand_landmarker/hand_landmarker.dart';

class GestureResult {
  final String name;
  final int? subjectIndex;

  const GestureResult(this.name, {this.subjectIndex});

  @override
  bool operator ==(Object other) =>
      other is GestureResult && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

class HandDetectorService extends ChangeNotifier {
  HandLandmarkerPlugin? _plugin;
  // CORRECTION 4 : _processingLocked géré dans un try/finally global
  // pour éviter le blocage permanent lors des retours anticipés.
  bool _processingLocked = false;
  bool isInitialized = false;
  String statusMessage = 'Initialisation...';
  String detectedGesture = '';
  GestureResult? gestureResult;
  List<Hand> detectedHands = [];

  String _pendingGesture = '';
  int _pendingCount = 0;
  static const int _requiredFrames = 10;

  DateTime _lastGestureTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _gestureCooldown = Duration(seconds: 5);
  bool _inCooldown = false;

  Future<void> init() async {
    for (final delegate in [
      HandLandmarkerDelegate.gpu,
      HandLandmarkerDelegate.cpu,
    ]) {
      try {
        _plugin = HandLandmarkerPlugin.create(
          numHands: 1,
          minHandDetectionConfidence: 0.5,
          delegate: delegate,
        );
        isInitialized = true;
        statusMessage =
            delegate == HandLandmarkerDelegate.gpu ? 'Prêt' : 'Prêt (CPU)';
        notifyListeners();
        return;
      } catch (_) {}
    }
    statusMessage = 'Erreur : plugin introuvable';
    notifyListeners();
  }

  void processImage(CameraImage image, int sensorOrientation) {
    if (_processingLocked || _plugin == null || !isInitialized) return;
    _processingLocked = true;

    // CORRECTION 4 : le try/finally englobe TOUT le corps de la méthode,
    // y compris les retours anticipés (cooldown, mains vides, etc.).
    // _processingLocked est donc toujours remis à false, même en cas de return.
    try {
      final now = DateTime.now();

      if (_inCooldown) {
        final elapsed = now.difference(_lastGestureTime);
        if (elapsed < _gestureCooldown) {
          final remaining = (_gestureCooldown - elapsed).inSeconds + 1;
          final msg = '⏳ ${remaining}s';
          if (statusMessage != msg) {
            statusMessage = msg;
            notifyListeners();
          }
          return; // finally libère le lock
        }
        _inCooldown = false;
        _pendingGesture = '';
        _pendingCount = 0;
        detectedGesture = '';
        gestureResult = null;
        statusMessage = 'Prêt — montre ta main';
        notifyListeners();
      }

      final List<Hand> hands;
      try {
        hands = _plugin!.detect(image, sensorOrientation);
      } catch (_) {
        return; // finally libère le lock
      }
      detectedHands = hands;

      if (hands.isEmpty) {
        _pendingGesture = '';
        _pendingCount = 0;
        if (statusMessage != 'Prêt — montre ta main') {
          statusMessage = 'Prêt — montre ta main';
          notifyListeners();
        }
        return; // finally libère le lock
      }

      final result = _recognizeGesture(hands.first);

      if (result.name.isEmpty) {
        _pendingGesture = '';
        _pendingCount = 0;
        if (statusMessage != 'Main détectée') {
          statusMessage = 'Main détectée';
          notifyListeners();
        }
        return; // finally libère le lock
      }

      if (result.name == _pendingGesture) {
        _pendingCount++;
      } else {
        _pendingGesture = result.name;
        _pendingCount = 1;
      }

      statusMessage = '${result.name} ($_pendingCount/$_requiredFrames)';
      notifyListeners();

      if (_pendingCount >= _requiredFrames) {
        _pendingCount = 0;
        _pendingGesture = '';
        _lastGestureTime = now;
        _inCooldown = true;
        detectedGesture = result.name;
        gestureResult = result;
        statusMessage = '✅ ${result.name}';
        notifyListeners();
      }
    } finally {
      _processingLocked = false;
    }
  }

  GestureResult _recognizeGesture(Hand hand) {
    try {
      final lm = hand.landmarks;

      // ── Landmarks ──────────────────────────────────────────────────
      final wrist = lm[0];
      final thumbMcp = lm[2];
      final thumbIp = lm[3];
      final thumbTip = lm[4];

      final indexMcp = lm[5];
      final indexPip = lm[6];
      final indexTip = lm[8];

      final middlePip = lm[10];
      final middleTip = lm[12];

      final ringPip = lm[14];
      final ringTip = lm[16];

      final pinkyPip = lm[18];
      final pinkyTip = lm[20];

      // ── CORRECTION 1 : Convention Y caméra frontale ────────────────
      // Dans MediaPipe sur mobile, y=0 est EN HAUT de l'image.
      // Un doigt LEVÉ a donc tip.y < pip.y (tip plus haut = valeur y plus petite).
      // L'ancien code avait le signe inversé (tip.y > pip.y + threshold)
      // ce qui détectait les doigts REPLIÉS comme levés.
      const double fingerThreshold = 0.05;

      final bool indexUp = indexTip.y < indexPip.y - fingerThreshold;
      final bool middleUp = middleTip.y < middlePip.y - fingerThreshold;
      final bool ringUp = ringTip.y < ringPip.y - fingerThreshold;
      final bool pinkyUp = pinkyTip.y < pinkyPip.y - fingerThreshold;

      // Compte des doigts levés — LE POUCE NE COMPTE JAMAIS (règle 1)
      final int count = (indexUp ? 1 : 0) +
          (middleUp ? 1 : 0) +
          (ringUp ? 1 : 0) +
          (pinkyUp ? 1 : 0);

      // ── CORRECTION 2 : Détection du pouce (axe horizontal) ─────────
      // Le pouce se déplace principalement sur l'axe X, pas Y.
      // On détermine si la main est gauche ou droite via la position du
      // poignet par rapport à l'index MCP.
      // Main droite (vue caméra frontale = miroir) : pouce à droite → x plus grand.
      // Main gauche : pouce à gauche → x plus petit.
      final bool isRightHand = wrist.x < indexMcp.x;

      // Pouce levé : tip clairement à l'écart latéral du ip
      final bool thumbUp = isRightHand
          ? thumbTip.x > thumbIp.x + 0.05 // main droite : tip vers la droite
          : thumbTip.x < thumbIp.x - 0.05; // main gauche : tip vers la gauche

      // Pouce vers le bas : tip clairement en dessous du mcp (y plus grand = plus bas)
      final bool thumbDown = thumbTip.y > thumbMcp.y + 0.05;

      // ── CORRECTION 3 : Inclinaison (aurevoir) ──────────────────────
      // On mesure l'écart vertical entre la base (poignet) et la tip du
      // majeur, ET l'étalement horizontal des tips (index à auriculaire).
      // Une main ouverte et inclinée a un grand étalement horizontal
      // des tips combiné à un décalage vertical significatif.
      // L'ancien code mesurait middleTip.x - wrist.x ce qui reflète
      // surtout la translation de la main entière, pas son inclinaison.
      final double spreadX = (indexTip.x - pinkyTip.x).abs();
      final double spreadY = (indexTip.y - pinkyTip.y).abs();
      // Inclinaison détectée si l'écart vertical entre les tips extrêmes
      // dépasse 40 % de leur écart horizontal (main penchée ~22°+).
      final bool tilted = spreadX > 0.05 && spreadY > spreadX * 0.4;

      // ══════════════════════════════════════════════════════════════
      //  RÈGLES STRICTES PAR ORDRE DE PRIORITÉ (règle 2)
      // ══════════════════════════════════════════════════════════════

      // 2a — 5 doigts levés (pouce + 4 autres)
      if (thumbUp && count == 4) {
        return tilted
            ? const GestureResult('aurevoir')
            : const GestureResult('bonjour');
      }

      // 2b — seul le pouce est levé (aucun autre doigt)
      if (thumbUp && count == 0) {
        return const GestureResult('oui');
      }

      // 2c — pouce vers le bas, aucun autre doigt → non
      if (thumbDown && count == 0) {
        return const GestureResult('non');
      }

      // 2d — 1 à 4 doigts levés, pouce NON levé
      if (!thumbUp && count >= 1 && count <= 4) {
        return GestureResult('$count', subjectIndex: count);
      }

      // Cas incertain → ignoré (règle 3)
      return const GestureResult('');
    } catch (_) {
      return const GestureResult('');
    }
  }

  @override
  void dispose() {
    _plugin?.dispose();
    super.dispose();
  }
}
