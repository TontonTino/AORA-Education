import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/gemini_service.dart';
import '../../core/services/haptic_service.dart';
import 'stt_service.dart';
import 'tts_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// États de l'interface vocale
// ─────────────────────────────────────────────────────────────────────────────
enum _VoiceState {
  idle, // En attente — prêt à écouter
  listening, // Écoute active (micro ouvert)
  thinking, // Traitement IA en cours
  speaking, // Lecture TTS de la réponse
}

// ─────────────────────────────────────────────────────────────────────────────
// NonVoyantHome — Interface 100% vocale, sans texte visible
// ─────────────────────────────────────────────────────────────────────────────
class NonVoyantHome extends StatefulWidget {
  const NonVoyantHome({super.key});

  @override
  State<NonVoyantHome> createState() => _NonVoyantHomeState();
}

class _NonVoyantHomeState extends State<NonVoyantHome>
    with TickerProviderStateMixin {
  // ── Services ──────────────────────────────────────────────────────
  final _stt = SttService();
  final _tts = TtsService();
  final _gemini = GeminiService();

  // ── État UI ───────────────────────────────────────────────────────
  _VoiceState _state = _VoiceState.idle;
  bool _isProcessing = false;

  // ── Animations ────────────────────────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final AnimationController _rippleCtrl;
  late final AnimationController _glowCtrl;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _rippleAnim;
  late final Animation<double> _glowAnim;

  // ── Couleurs ──────────────────────────────────────────────────────
  static const _bgIdle = Color(0xFF0A0A14);
  static const _bgListening = Color(0xFF0D001A);
  static const _bgThinking = Color(0xFF001219);
  static const _bgSpeaking = Color(0xFF001A14);

  static const _accentIdle = Color(0xFF5A5A7A);
  static const _accentListening = Color(0xFFB388FF);
  static const _accentThinking = Color(0xFF48CAE4);
  static const _accentSpeaking = Color(0xFF1D9E75);

  // ─────────────────────────────────────────────────────────────────
  // Init
  // ─────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initServicesAndWelcome();
  }

  void _initAnimations() {
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _rippleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.09)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _rippleAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut));
    _glowAnim = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  Future<void> _initServicesAndWelcome() async {
    await _stt.init();
    await _tts.init();
    _gemini.init(mode: ConversationMode.nonVoyant);

    _stt.addListener(_onSttChange);
    _tts.addListener(_onTtsChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), _playWelcome);
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // Accueil unique — une seule fois au lancement
  // ─────────────────────────────────────────────────────────────────
  Future<void> _playWelcome() async {
    _applyState(_VoiceState.speaking);
    debugPrint('[UI] accueil unique');
    await _tts.speak(
      'Bonjour. Je suis OARA, votre tuteur vocal. '
      'Quelle matière souhaitez-vous apprendre aujourd\'hui ? '
      'Appuyez au centre pour parler.',
    );
    _applyState(_VoiceState.idle);
  }

  // ─────────────────────────────────────────────────────────────────
  // Listeners
  // ─────────────────────────────────────────────────────────────────
  void _onSttChange() {
    if (mounted) setState(() {});
  }

  void _onTtsChange() {
    if (mounted) setState(() {});
  }

  // ─────────────────────────────────────────────────────────────────
  // Gestion des animations par état
  // ─────────────────────────────────────────────────────────────────
  void _applyState(_VoiceState next) {
    if (!mounted) return;
    setState(() => _state = next);

    _pulseCtrl.stop();
    _pulseCtrl.reset();
    _rippleCtrl.stop();
    _rippleCtrl.reset();
    _glowCtrl.stop();
    _glowCtrl.reset();

    switch (next) {
      case _VoiceState.listening:
        _pulseCtrl.repeat(reverse: true);
        _rippleCtrl.repeat();
        break;
      case _VoiceState.thinking:
        _glowCtrl.repeat(reverse: true);
        break;
      case _VoiceState.speaking:
        _pulseCtrl.repeat(reverse: true);
        break;
      case _VoiceState.idle:
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Action bouton micro
  // ─────────────────────────────────────────────────────────────────
  Future<void> _onMicTap() async {
    if (_state == _VoiceState.listening) {
      debugPrint('[UI] 2ème appui → arrêt écoute manuel');
      HapticFeedback.mediumImpact();
      await _stt.stopListening();
      return;
    }

    if (_state == _VoiceState.speaking) {
      await _tts.stop();
      _applyState(_VoiceState.idle);
      return;
    }

    if (_state == _VoiceState.thinking || _isProcessing) return;

    _isProcessing = true;
    try {
      await _runConversationCycle();
    } finally {
      _isProcessing = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Cycle conversationnel complet — bilingue
  // ─────────────────────────────────────────────────────────────────
  Future<void> _runConversationCycle() async {
    // 1. Arrêter TTS si actif
    await _tts.stop();

    // 2. Lire la langue courante AVANT d'annoncer l'écoute
    final en = _gemini.isEnglishMode;

    // 3. Annoncer l'écoute dans la bonne langue + vibration
    await HapticService.readyToListen();
    _applyState(_VoiceState.speaking);
    debugPrint('[CYCLE] ▶ annonce écoute (en=$en)');
    await _tts.speak(en ? 'I\'m listening.' : 'Je vous écoute.');

    // 4. Configurer STT dans la bonne locale
    if (en) {
      _stt.setEnglish();
    } else {
      _stt.setFrench();
    }

    // 5. Démarrer l'écoute STT
    _applyState(_VoiceState.listening);
    debugPrint('[CYCLE] ▶ écoute STT démarrée');

    final texte = await _stt.listenAndGetResult();
    debugPrint('[CYCLE] ✓ texte reconnu : "$texte"');

    if (!mounted) return;

    // 6. Rien entendu
    if (texte.trim().isEmpty) {
      await HapticService.error();
      _applyState(_VoiceState.speaking);
      await _tts.speak(
        en
            ? 'I didn\'t hear your question. Tap to try again.'
            : 'Je n\'ai pas entendu votre question. Appuyez pour réessayer.',
      );
      _applyState(_VoiceState.idle);
      return;
    }

    // 7. Vérifier commande navigation vocale
    final navigationHandled = await _checkVocalNavigation(texte);
    if (navigationHandled) return;

    // 8. Traitement IA
    await HapticService.medium();
    _applyState(_VoiceState.thinking);
    debugPrint('[CYCLE] ▶ requête IA : "$texte"');

    // Détecter la langue du message et synchroniser STT
    final isEnglishInput = _detectIsEnglish(texte);
    if (isEnglishInput) {
      _stt.setEnglish();
    } else {
      _stt.setFrench();
    }

    // Annonce traitement dans la langue détectée
    unawaited(_tts.speak(isEnglishInput ? 'Let me think.' : 'Je réfléchis.'));

    String reponse;
    try {
      reponse = await _gemini.sendMessage(texte);
      debugPrint('[CYCLE] ✓ réponse reçue (${reponse.length} chars)');
    } catch (e) {
      debugPrint('[CYCLE] ✗ erreur IA : $e');
      reponse = _gemini.isEnglishMode
          ? 'I\'m having trouble right now. Please try again.'
          : 'Je rencontre une difficulté. Veuillez réessayer.';
    }

    if (!mounted) return;

    // 9. Arrêter "Je réfléchis" si encore en cours
    await _tts.stop();

    // 10. Lire la réponse — TTS détecte automatiquement fr/en
    await HapticService.aiResponding();
    _applyState(_VoiceState.speaking);
    debugPrint('[CYCLE] ▶ lecture TTS réponse');
    await _tts.speak(reponse);
    debugPrint('[CYCLE] ■ lecture TTS terminée');

    if (!mounted) return;

    // 11. Invitation à continuer dans la langue finale
    final enFinal = _gemini.isEnglishMode;
    await _tts.speak(
      enFinal
          ? 'Tap to ask another question.'
          : 'Appuyez pour poser une autre question.',
    );
    _applyState(_VoiceState.idle);
  }

  // ─────────────────────────────────────────────────────────────────
  // Détection de commandes vocales de navigation (bilingue)
  // ─────────────────────────────────────────────────────────────────
  Future<bool> _checkVocalNavigation(String texte) async {
    final t = texte.toLowerCase().trim();
    final en = _gemini.isEnglishMode;

    final isGoHome = _containsAny(t, [
      'retour',
      'accueil',
      'menu principal',
      'quitter',
      'sortir',
      'home',
      'retourne',
      'revenir',
      'menu',
      'principal',
      'déconnect',
      'exit',
      'go back',
      'go home',
      'main menu',
      'quit',
    ]);

    if (isGoHome) {
      debugPrint('[NAV] commande retour accueil : "$texte"');
      _applyState(_VoiceState.speaking);
      await HapticService.medium();
      await _tts.speak(
        en
            ? 'Alright, taking you back to the home screen. See you soon.'
            : 'Très bien, je vous ramène à l\'accueil. À bientôt.',
      );
      if (mounted) context.go('/onboarding');
      return true;
    }

    final isReset = _containsAny(t, [
      'recommencer',
      'nouvelle conversation',
      'repartir',
      'effacer',
      'réinitialiser',
      'nouveau',
      'recomencer',
      'restart',
      'new conversation',
      'start over',
      'reset',
      'start again',
    ]);

    if (isReset) {
      debugPrint('[NAV] commande reset conversation');
      _gemini.resetChat();
      _applyState(_VoiceState.speaking);
      await _tts.speak(
        en
            ? 'New conversation started. What subject would you like to study?'
            : 'Nouvelle conversation démarrée. Quelle matière souhaitez-vous étudier ?',
      );
      _applyState(_VoiceState.idle);
      return true;
    }

    return false;
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  // ─────────────────────────────────────────────────────────────────
  // Navigation manuelle (boutons coins)
  // ─────────────────────────────────────────────────────────────────
  Future<void> _onRetourArriere() async {
    await _tts.stop();
    await _stt.stopListening();
    await HapticService.medium();
    if (mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/onboarding');
      }
    }
  }

  Future<void> _onRetourAccueil() async {
    await _tts.stop();
    await _stt.stopListening();
    await HapticService.medium();
    await _tts.speak(
      _gemini.isEnglishMode ? 'Back to home.' : 'Retour à l\'accueil.',
    );
    if (mounted) context.go('/onboarding');
  }

  // ─────────────────────────────────────────────────────────────────
  // Getters couleurs / icônes selon état
  // ─────────────────────────────────────────────────────────────────
  Color get _bgColor {
    switch (_state) {
      case _VoiceState.idle:
        return _bgIdle;
      case _VoiceState.listening:
        return _bgListening;
      case _VoiceState.thinking:
        return _bgThinking;
      case _VoiceState.speaking:
        return _bgSpeaking;
    }
  }

  Color get _accentColor {
    switch (_state) {
      case _VoiceState.idle:
        return _accentIdle;
      case _VoiceState.listening:
        return _accentListening;
      case _VoiceState.thinking:
        return _accentThinking;
      case _VoiceState.speaking:
        return _accentSpeaking;
    }
  }

  Color get _buttonColor {
    switch (_state) {
      case _VoiceState.idle:
        return const Color(0xFF1A1A2E);
      case _VoiceState.listening:
        return const Color(0xFF3D0080);
      case _VoiceState.thinking:
        return const Color(0xFF003847);
      case _VoiceState.speaking:
        return const Color(0xFF004D3B);
    }
  }

  IconData get _micIcon {
    switch (_state) {
      case _VoiceState.idle:
        return Icons.mic_none_rounded;
      case _VoiceState.listening:
        return Icons.mic_rounded;
      case _VoiceState.thinking:
        return Icons.psychology_rounded;
      case _VoiceState.speaking:
        return Icons.volume_up_rounded;
    }
  }

  String get _semanticsLabel {
    switch (_state) {
      case _VoiceState.idle:
        return 'Appuyez pour parler';
      case _VoiceState.listening:
        return 'Écoute active. Parlez. Appuyez pour arrêter.';
      case _VoiceState.thinking:
        return 'Traitement en cours, veuillez patienter';
      case _VoiceState.speaking:
        return 'Réponse en cours. Appuyez pour interrompre.';
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final btnSize = size.width * 0.45;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Semantics(
        label: 'Tuteur vocal OARA. Interface non-voyant.',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          color: _bgColor,
          child: SafeArea(
            child: Stack(
              children: [
                // ── Zone tactile plein écran ──
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _onMicTap,
                    behavior: HitTestBehavior.translucent,
                    child: const SizedBox.expand(),
                  ),
                ),

                // ── Ondes de fond ──
                if (_state != _VoiceState.idle)
                  Positioned.fill(
                    child: _BackgroundWaves(
                      color: _accentColor,
                      rippleAnim: _rippleAnim,
                      glowAnim: _glowAnim,
                      state: _state,
                    ),
                  ),

                // ── Bouton Retour (coin haut gauche) ──
                Positioned(
                  top: 0,
                  left: 0,
                  child: _CornerNavButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    semanticsLabel: 'Retour en arrière',
                    onTap: _onRetourArriere,
                  ),
                ),

                // ── Bouton Accueil (coin haut droit) ──
                Positioned(
                  top: 0,
                  right: 0,
                  child: _CornerNavButton(
                    icon: Icons.home_rounded,
                    semanticsLabel: 'Retour à l\'accueil',
                    onTap: _onRetourAccueil,
                    alignRight: true,
                  ),
                ),

                // ── Bouton micro central ──
                Center(
                  child: _MicButton(
                    size: btnSize,
                    state: _state,
                    accentColor: _accentColor,
                    buttonColor: _buttonColor,
                    micIcon: _micIcon,
                    pulseAnim: _pulseAnim,
                    rippleAnim: _rippleAnim,
                    glowAnim: _glowAnim,
                    semanticsLabel: _semanticsLabel,
                    onTap: _onMicTap,
                  ),
                ),

                // ── Indicateur d'état (dots) ──
                Positioned(
                  bottom: 48,
                  left: 0,
                  right: 0,
                  child: _StateDotsIndicator(
                    state: _state,
                    accentColor: _accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Détection de langue (texte reconnu par STT)
  // ─────────────────────────────────────────────────────────────────
  bool _detectIsEnglish(String text) {
    if (RegExp(r'[àâäéèêëîïôùûüçœæ]').hasMatch(text)) return false;

    final frWords = RegExp(
      r'\b(le|la|les|un|une|des|du|de|et|ou|est|son|sa|ses|nous|vous|ils|elles|dans|pour|avec|sur|par|mais|donc|car|que|qui|quoi|dont|très|plus|bien|aussi|même|tout|tous|cette|ces|mon|ton|leur|leurs|quel|je|tu|il|elle|on|comment|bonjour|merci|oui|non|quand|pourquoi|où|combien|veux|veux-tu|peux|pouvez|voulez|apprendre|aider)\b',
      caseSensitive: false,
    );
    final enWords = RegExp(
      r'\b(the|a|an|is|are|was|were|have|has|do|does|will|would|could|should|can|i|you|he|she|we|they|this|that|my|your|his|her|what|when|where|who|how|why|please|hello|thank|yes|no|want|learn|help|explain|tell|give|show|make|get|take|come|go|use|need|like|know|think|see|look|say|good|great|ok|okay)\b',
      caseSensitive: false,
    );

    final frScore = frWords.allMatches(text).length;
    final enScore = enWords.allMatches(text).length;
    debugPrint(
        '[LANG] détection : fr=$frScore, en=$enScore → ${enScore > frScore ? 'EN' : 'FR'}');
    return enScore > frScore;
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _rippleCtrl.dispose();
    _glowCtrl.dispose();
    _stt.removeListener(_onSttChange);
    _tts.removeListener(_onTtsChange);
    _stt.dispose();
    _tts.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bouton micro géant
// ─────────────────────────────────────────────────────────────────────────────
class _MicButton extends StatelessWidget {
  final double size;
  final _VoiceState state;
  final Color accentColor;
  final Color buttonColor;
  final IconData micIcon;
  final Animation<double> pulseAnim;
  final Animation<double> rippleAnim;
  final Animation<double> glowAnim;
  final String semanticsLabel;
  final VoidCallback onTap;

  const _MicButton({
    required this.size,
    required this.state,
    required this.accentColor,
    required this.buttonColor,
    required this.micIcon,
    required this.pulseAnim,
    required this.rippleAnim,
    required this.glowAnim,
    required this.semanticsLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: AnimatedBuilder(
        animation: Listenable.merge([pulseAnim, rippleAnim, glowAnim]),
        builder: (context, _) {
          return GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: size * 1.7,
              height: size * 1.7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (state == _VoiceState.listening) ..._buildRipples(size),
                  if (state != _VoiceState.idle) _buildGlow(size),
                  ScaleTransition(
                    scale: (state == _VoiceState.listening ||
                            state == _VoiceState.speaking)
                        ? pulseAnim
                        : const AlwaysStoppedAnimation(1.0),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: buttonColor,
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.55),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(
                              alpha: state == _VoiceState.idle ? 0.12 : 0.38,
                            ),
                            blurRadius: 42,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        micIcon,
                        size: size * 0.42,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildRipples(double baseSize) {
    final t = rippleAnim.value;
    return [1.0, 0.65, 0.3].map((phase) {
      final progress = (t + phase) % 1.0;
      final scale = 1.0 + progress * 0.75;
      final opacity = (1.0 - progress) * 0.28;
      return Transform.scale(
        scale: scale,
        child: Container(
          width: baseSize,
          height: baseSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: accentColor.withValues(alpha: opacity),
              width: 1.8,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildGlow(double baseSize) {
    return Container(
      width: baseSize * (1.0 + glowAnim.value * 0.15),
      height: baseSize * (1.0 + glowAnim.value * 0.15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            accentColor.withValues(alpha: glowAnim.value * 0.18),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bouton de coin navigation
// ─────────────────────────────────────────────────────────────────────────────
class _CornerNavButton extends StatelessWidget {
  final IconData icon;
  final String semanticsLabel;
  final VoidCallback onTap;
  final bool alignRight;

  const _CornerNavButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 88,
          height: 88,
          color: Colors.transparent,
          alignment: alignRight ? Alignment.topRight : Alignment.topLeft,
          padding: EdgeInsets.only(
            top: 16,
            left: alignRight ? 0 : 16,
            right: alignRight ? 16 : 0,
          ),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.45),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ondes de fond animées
// ─────────────────────────────────────────────────────────────────────────────
class _BackgroundWaves extends StatelessWidget {
  final Color color;
  final Animation<double> rippleAnim;
  final Animation<double> glowAnim;
  final _VoiceState state;

  const _BackgroundWaves({
    required this.color,
    required this.rippleAnim,
    required this.glowAnim,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state == _VoiceState.listening ? rippleAnim : glowAnim,
      builder: (_, __) {
        final progress =
            state == _VoiceState.listening ? rippleAnim.value : glowAnim.value;
        return CustomPaint(
          painter: _WavePainter(color: color, progress: progress),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  final double progress;

  _WavePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = size.longestSide * 0.85;

    for (int i = 0; i < 3; i++) {
      final phase = (progress + i / 3) % 1.0;
      final r = phase * maxR;
      final opacity = (1.0 - phase) * 0.055;
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = color.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// Dots indicateurs d'état
// ─────────────────────────────────────────────────────────────────────────────
class _StateDotsIndicator extends StatelessWidget {
  final _VoiceState state;
  final Color accentColor;

  const _StateDotsIndicator({required this.state, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: state == _VoiceState.idle
          ? _buildSingleDot()
          : _AnimatedDots(
              key: ValueKey(state),
              color: accentColor,
              style: _styleForState(state),
            ),
    );
  }

  Widget _buildSingleDot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.18),
          ),
        ),
      ],
    );
  }

  _DotsStyle _styleForState(_VoiceState s) {
    switch (s) {
      case _VoiceState.listening:
        return _DotsStyle.bounce;
      case _VoiceState.thinking:
        return _DotsStyle.pulse;
      case _VoiceState.speaking:
        return _DotsStyle.wave;
      case _VoiceState.idle:
        return _DotsStyle.bounce;
    }
  }
}

enum _DotsStyle { bounce, pulse, wave }

class _AnimatedDots extends StatefulWidget {
  final Color color;
  final _DotsStyle style;

  const _AnimatedDots({super.key, required this.color, required this.style});

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            double size;
            double opacity;

            switch (widget.style) {
              case _DotsStyle.bounce:
                final bounce =
                    math.sin((t - i * 0.25).clamp(0.0, 1.0) * math.pi);
                size = 8 + bounce * 7;
                opacity = 0.35 + bounce * 0.65;
                break;
              case _DotsStyle.pulse:
                final p = (t + i * 0.33) % 1.0;
                final v = math.sin(p * math.pi * 2);
                size = 9 + v * 4;
                opacity = 0.5 + v.abs() * 0.5;
                break;
              case _DotsStyle.wave:
                final w = math.sin((t * math.pi * 2) + (i * math.pi * 0.55));
                size = 8 + w.abs() * 6;
                opacity = 0.35 + w.abs() * 0.65;
                break;
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: opacity.clamp(0.0, 1.0)),
              ),
            );
          }),
        );
      },
    );
  }
}

// Utilitaire : fire-and-forget sans warning
void unawaited(Future<void> future) {}
