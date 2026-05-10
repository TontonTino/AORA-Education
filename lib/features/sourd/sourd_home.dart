import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/gemini_service.dart';
import '../../core/services/haptic_service.dart';
import '../muet/hand_detector_service.dart';
import 'sign_language_service.dart';
import 'avatar_selection_screen.dart';

// ---------------------------------------------------------------------------
// Entry point — vérifie si l'avatar est choisi, sinon affiche la sélection
// ---------------------------------------------------------------------------

class SourdEntry extends StatefulWidget {
  const SourdEntry({super.key});

  @override
  State<SourdEntry> createState() => _SourdEntryState();
}

class _SourdEntryState extends State<SourdEntry> {
  AvatarProfile? _profile;

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      // Enveloppe AvatarSelectionScreen avec les boutons Retour / Accueil
      return Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        body: SafeArea(
          child: Column(
            children: [
              // Barre de navigation cohérente
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // ← Retour
                    Semantics(
                      label: 'Retour en arrière',
                      button: true,
                      child: GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/onboarding');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // 🏠 Accueil
                    Semantics(
                      label: 'Retour à l\'accueil',
                      button: true,
                      child: GestureDetector(
                        onTap: () => context.go('/onboarding'),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.home_rounded,
                              color: Colors.white70, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Contenu de la sélection d'avatar
              Expanded(
                child: AvatarSelectionScreen(
                  onConfirm: (p) => setState(() => _profile = p),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SourdHome(
        profile: _profile!, onBack: () => setState(() => _profile = null));
  }
}

// ---------------------------------------------------------------------------
// SourdHome — interface principale de dialogue en langue des signes
// ---------------------------------------------------------------------------

class SourdHome extends StatefulWidget {
  final AvatarProfile profile;

  /// Appelé quand l'utilisateur appuie sur ← Retour (revient à la sélection d'avatar)
  final VoidCallback? onBack;

  const SourdHome({super.key, required this.profile, this.onBack});

  @override
  State<SourdHome> createState() => _SourdHomeState();
}

class _SourdHomeState extends State<SourdHome> with TickerProviderStateMixin {
  // Services
  late final SignLanguageService _signService;
  late final GeminiService _geminiService;
  late final HandDetectorService _handService;

  // Caméra
  CameraController? _cameraCtrl;
  bool _cameraReady = false;
  bool _cameraVisible = true;

  // Chat
  final List<_ChatMessage> _messages = [];
  bool _isAiThinking = false;

  // Geste en attente d'envoi
  String? _pendingGesture;
  Timer? _gestureDebounce;

  // Matières actuellement affichées dans le dernier message IA
  // Rempli chaque fois que l'IA liste des matières (ex: "1. Maths 2. Français")
  List<String> _lastSubjectList = [];

  // Animations
  late final AnimationController _avatarBounce;
  late final AnimationController _signAnim;
  late final Animation<double> _bounceAnim;
  late final Animation<double> _signScale;

  @override
  void initState() {
    super.initState();

    _signService = SignLanguageService()..setProfile(widget.profile);
    _geminiService = GeminiService()..init(mode: ConversationMode.sourd);
    _handService = HandDetectorService();

    _avatarBounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _signAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _avatarBounce, curve: Curves.elasticOut),
    );
    _signScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _signAnim, curve: Curves.easeOut),
    );

    _signService.addListener(_onSignServiceUpdate);
    _handService.addListener(_onHandUpdate);

    _initCamera();
    _initHandDetector();
    _sendWelcome();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraCtrl = CameraController(
        front,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await _cameraCtrl!.initialize();
      if (mounted) {
        setState(() => _cameraReady = true);
        _cameraCtrl!.startImageStream((img) {
          _handService.processImage(
            img,
            _cameraCtrl!.description.sensorOrientation,
          );
        });
      }
    } catch (e) {
      // Pas de caméra — mode icônes fallback
      if (mounted) setState(() => _cameraReady = false);
    }
  }

  Future<void> _initHandDetector() async {
    await _handService.init();
  }

  void _sendWelcome() {
    final name = widget.profile.displayName;
    final welcome =
        'Bonjour $name ! Je suis OARA, ton tuteur. Montre-moi un signe ou tape une question.';
    _addAiMessage(welcome);
    _signService.enqueueTextAsSign(welcome);
  }

  void _onSignServiceUpdate() {
    if (_signService.isAnimating) {
      _avatarBounce.forward(from: 0);
      _signAnim.forward(from: 0);
    }
    if (mounted) setState(() {});
  }

  void _onHandUpdate() {
    final result = _handService.gestureResult;
    if (result == null || result.name.isEmpty) return;
    if (result.name == _pendingGesture) return;

    _gestureDebounce?.cancel();
    setState(() => _pendingGesture = result.name);

    _gestureDebounce = Timer(const Duration(milliseconds: 1200), () {
      if (mounted && _pendingGesture != null) {
        final currentResult = _handService.gestureResult;
        if (currentResult != null && currentResult.subjectIndex != null) {
          // Geste matière : sélectionne la Nième matière de la liste IA
          _sendSubjectGesture(currentResult);
        } else {
          _sendGestureAsMessage(_pendingGesture!);
        }
        _pendingGesture = null;
        if (mounted) setState(() {});
      }
    });
  }

  Future<void> _sendSubjectGesture(GestureResult result) async {
    final idx = result.subjectIndex! - 1; // 0-based
    await HapticService.light();

    if (_lastSubjectList.isNotEmpty && idx < _lastSubjectList.length) {
      // On a une liste de matières en contexte → sélection directe
      final subject = _lastSubjectList[idx];
      final emoji = _subjectEmoji(idx);
      _addUserMessage('$emoji ${result.name} → $subject', isGesture: true);
      await _askAi('Je veux apprendre : $subject');
    } else {
      // Pas de liste active → envoie le geste brut
      _addUserMessage('☝️ ${result.name}', isGesture: true);
      await _askAi(result.name);
    }
  }

  String _subjectEmoji(int idx) {
    const emojis = ['☝️', '✌️', '🤟', '🖖'];
    return idx < emojis.length ? emojis[idx] : '👆';
  }

  Future<void> _sendGestureAsMessage(String gesture) async {
    await HapticService.light();
    final emoji = _gestureEmoji(gesture);
    _addUserMessage('$emoji $gesture', isGesture: true);
    await _askAi(gesture);
  }

  String _gestureEmoji(String gesture) {
    switch (gesture) {
      case 'Bonjour':
        return '👋';
      case 'Oui':
        return '👍';
      case 'Non':
        return '👎';
      case 'Aide':
        return '✊';
      default:
        return '🤲';
    }
  }

  Future<void> _sendIconMessage(String text, String emoji) async {
    await HapticService.light();
    _addUserMessage('$emoji $text', isGesture: false);
    await _askAi(text);
  }

  Future<void> _askAi(String input) async {
    if (_isAiThinking) return;
    setState(() => _isAiThinking = true);

    try {
      final reply = await _geminiService.sendMessage(input);
      if (mounted) {
        _addAiMessage(reply);
        _signService.enqueueTextAsSign(reply);
        // Détecte si l'IA a listé des matières (ex: "1. Maths\n2. Français\n3. Histoire")
        _lastSubjectList = _extractSubjectList(reply);
        await HapticService.aiResponding();
      }
    } catch (e) {
      if (mounted) {
        _addAiMessage('Je suis hors ligne. Réessaie dans un moment.');
      }
    } finally {
      if (mounted) setState(() => _isAiThinking = false);
    }
  }

  /// Extrait une liste de matières numérotées depuis la réponse IA.
  /// Ex: "1. Maths 2. Français 3. Histoire" → ['Maths', 'Français', 'Histoire']
  List<String> _extractSubjectList(String text) {
    // Pattern : chiffre suivi d'un point/parenthèse, puis le texte de la matière
    final pattern = RegExp(r'\d+[\.\)]\s*([^\d\n\.,!?]{2,30})');
    final matches = pattern.allMatches(text);
    if (matches.length < 2) return []; // Pas une liste, on ignore
    return matches
        .map((m) => m.group(1)?.trim() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  void _addUserMessage(String text, {required bool isGesture}) {
    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isUser: true,
        isGesture: isGesture,
      ));
    });
  }

  void _addAiMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: false));
    });
  }

  @override
  void dispose() {
    _gestureDebounce?.cancel();
    _cameraCtrl?.dispose();
    _handService.dispose();
    _signService.removeListener(_onSignServiceUpdate);
    _handService.removeListener(_onHandUpdate);
    _signService.dispose();
    _avatarBounce.dispose();
    _signAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildAvatarZone(),
            _buildChatHistory(),
            _buildInputZone(),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // AppBar custom
  // -------------------------------------------------------------------------
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // ← Retour
          Semantics(
            label: 'Retour en arrière',
            button: true,
            child: GestureDetector(
              onTap: () {
                if (widget.onBack != null) {
                  // Revient à la sélection d'avatar
                  widget.onBack!();
                } else if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/onboarding');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.profile.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
                Text(
                  _isAiThinking ? 'En train de signer...' : 'Prêt',
                  style: TextStyle(
                    color: _isAiThinking
                        ? const Color(0xFF1D9E75)
                        : Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // 🏠 Accueil
          Semantics(
            label: 'Retour à l\'accueil',
            button: true,
            child: GestureDetector(
              onTap: () => context.go('/onboarding'),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.home_rounded,
                    color: Colors.white70, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Toggle caméra
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _cameraVisible = !_cameraVisible);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _cameraVisible
                    ? const Color(0xFF1D9E75).withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _cameraVisible
                      ? const Color(0xFF1D9E75)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                _cameraVisible ? Icons.videocam : Icons.videocam_off,
                color:
                    _cameraVisible ? const Color(0xFF1D9E75) : Colors.white38,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Zone avatar + caméra
  // -------------------------------------------------------------------------
  Widget _buildAvatarZone() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B3C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _signService.isAnimating
              ? const Color(0xFF1D9E75).withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.07),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Avatar principal
          Expanded(
            flex: 3,
            child: _buildAvatarDisplay(),
          ),
          // Caméra utilisateur (vue de soi)
          if (_cameraVisible)
            Expanded(
              flex: 2,
              child: _buildCameraPreview(),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarDisplay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Fond dégradé derrière l'avatar
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.2,
              colors: [
                const Color(0xFF1D9E75)
                    .withValues(alpha: _signService.isAnimating ? 0.15 : 0.05),
                const Color(0xFF1A2B3C),
              ],
            ),
          ),
        ),

        // Avatar animé
        ScaleTransition(
          scale: _bounceAnim,
          child: _AvatarWidget(
            profile: widget.profile,
            currentSign: _signService.currentFrame,
          ),
        ),

        // Badge du signe en cours
        if (_signService.currentFrame != null)
          Positioned(
            bottom: 12,
            child: ScaleTransition(
              scale: _signScale,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9E75),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  _signService.currentFrame!.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black,
        border: Border.all(
          color: _pendingGesture != null
              ? const Color(0xFFFFD700)
              : Colors.white.withValues(alpha: 0.1),
          width: _pendingGesture != null ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_cameraReady && _cameraCtrl != null)
              CameraPreview(_cameraCtrl!)
            else
              const Center(
                child: Icon(Icons.camera_alt, color: Colors.white30, size: 32),
              ),

            // Overlay geste détecté
            if (_handService.detectedGesture.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Text(
                    _handService.detectedGesture,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

            // Indicateur de confirmation
            if (_pendingGesture != null)
              Positioned(
                top: 8,
                right: 8,
                child: _GestureConfirmTimer(),
              ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Historique du chat
  // -------------------------------------------------------------------------
  Widget _buildChatHistory() {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: _messages.length + (_isAiThinking ? 1 : 0),
        itemBuilder: (context, idx) {
          if (_isAiThinking && idx == 0) {
            return _buildTypingIndicator();
          }
          final msgIdx = _isAiThinking ? idx - 1 : idx;
          final msg = _messages[_messages.length - 1 - msgIdx];
          return _buildMessageBubble(msg);
        },
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isUser
              ? const Color(0xFF1D9E75).withValues(alpha: 0.9)
              : const Color(0xFF1E2D3D),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 18),
          ),
          border: msg.isGesture
              ? Border.all(color: const Color(0xFFFFD700), width: 1.5)
              : null,
        ),
        child: Text(
          msg.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D3D),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: _DotsAnimation(),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Zone d'input — icônes prédictives + clavier
  // -------------------------------------------------------------------------
  Widget _buildInputZone() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C28),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Geste en attente
          if (_pendingGesture != null) _buildPendingGestureBanner(),

          // Liste matières active (si l'IA vient d'en lister)
          if (_lastSubjectList.isNotEmpty && _pendingGesture == null)
            _buildActiveSubjectChips(),

          const SizedBox(height: 8),

          // Icônes prédictives
          _buildQuickIcons(),
        ],
      ),
    );
  }

  Widget _buildPendingGestureBanner() {
    final result = _handService.gestureResult;
    final isSubject = result?.subjectIndex != null;
    // Détermine le texte contextuel
    String contextHint = '';
    if (isSubject && _lastSubjectList.isNotEmpty) {
      final idx =
          (result!.subjectIndex! - 1).clamp(0, _lastSubjectList.length - 1);
      contextHint = ' → ${_lastSubjectList[idx]}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Text(
            _gestureEmoji(_pendingGesture ?? ''),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Signe : $_pendingGesture$contextHint — envoi dans 1s…',
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _gestureDebounce?.cancel();
              setState(() => _pendingGesture = null);
            },
            child: const Icon(Icons.close, color: Color(0xFFFFD700), size: 18),
          ),
        ],
      ),
    );
  }

  /// Chips de sélection par doigt quand l'IA a listé des matières.
  /// Affiche "☝️ Maths", "✌️ Français", "🤟 Histoire" etc.
  Widget _buildActiveSubjectChips() {
    const fingerEmojis = ['☝️', '✌️', '🤟', '🖖'];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1D9E75).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sélectionne avec tes doigts :',
            style: TextStyle(
              color: const Color(0xFF1D9E75).withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(_lastSubjectList.length, (i) {
              final emoji = i < fingerEmojis.length ? fingerEmojis[i] : '👆';
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _addUserMessage('$emoji ${_lastSubjectList[i]}',
                      isGesture: false);
                  _askAi('Je veux apprendre : ${_lastSubjectList[i]}');
                  setState(() => _lastSubjectList = []);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    '$emoji  ${_lastSubjectList[i]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickIcons() {
    final icons = [
      _QuickIcon('Bonjour', '👋', 'Bonjour'),
      _QuickIcon('Aide', '✊', 'Aide'),
      _QuickIcon('Répète', '🔁', 'Répète'),
      _QuickIcon('Bravo', '👏', 'Bravo'),
      _QuickIcon('?', '❓', 'Je ne comprends pas'),
      _QuickIcon('Non', '👎', 'Non'),
    ];

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: icons.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) => _buildIconButton(icons[i]),
      ),
    );
  }

  Widget _buildIconButton(_QuickIcon qi) {
    return GestureDetector(
      onTap: () => _sendIconMessage(qi.message, qi.emoji),
      child: Container(
        width: 68,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(qi.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              qi.label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget avatar principal avec animation de signe
// ---------------------------------------------------------------------------

class _AvatarWidget extends StatelessWidget {
  final AvatarProfile profile;
  final SignFrame? currentSign;

  const _AvatarWidget({required this.profile, this.currentSign});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Corps de l'avatar
          CustomPaint(
            size: const Size(140, 180),
            painter: _FullAvatarPainter(
              skinColor: _skinColor,
              isFemale: profile.gender == AvatarGender.female,
              signId: currentSign?.signId,
            ),
          ),
        ],
      ),
    );
  }

  Color get _skinColor {
    switch (profile.skinTone) {
      case SkinTone.light:
        return const Color(0xFFF5D5A0);
      case SkinTone.medium:
        return const Color(0xFFC68A4A);
      case SkinTone.dark:
        return const Color(0xFF6B3A2A);
    }
  }
}

/// Peint un avatar complet (tête + bras) avec des positions de mains
/// correspondant au signe en cours.
class _FullAvatarPainter extends CustomPainter {
  final Color skinColor;
  final bool isFemale;
  final String? signId;

  _FullAvatarPainter({
    required this.skinColor,
    required this.isFemale,
    this.signId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // --- Corps / buste ---
    final bodyPaint = Paint()..color = const Color(0xFF1D9E75);
    final bodyPath = Path()
      ..moveTo(cx - w * 0.38, h)
      ..quadraticBezierTo(cx - w * 0.3, h * 0.72, cx - w * 0.18, h * 0.65)
      ..lineTo(cx + w * 0.18, h * 0.65)
      ..quadraticBezierTo(cx + w * 0.3, h * 0.72, cx + w * 0.38, h)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // --- Bras (position selon signe) ---
    _drawArms(canvas, size, cx);

    // --- Cou ---
    final skinPaint = Paint()..color = skinColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - w * 0.075, h * 0.54, w * 0.15, h * 0.13),
        const Radius.circular(4),
      ),
      skinPaint,
    );

    // --- Tête ---
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, h * 0.34),
        width: w * 0.55,
        height: h * 0.46,
      ),
      skinPaint,
    );

    // --- Cheveux ---
    _drawHair(canvas, size, cx);

    // --- Visage ---
    _drawFace(canvas, size, cx);
  }

  void _drawArms(Canvas canvas, Size size, double cx) {
    final w = size.width;
    final h = size.height;
    final skinPaint = Paint()..color = skinColor;
    final sign = signId ?? '';

    // Calcule les positions des mains selon le signe
    Offset leftHand, rightHand;
    Offset leftElbow, rightElbow;

    switch (sign) {
      case 'bonjour':
        // Main droite levée, paume ouverte vers l'avant (salut)
        leftElbow = Offset(cx - w * 0.28, h * 0.7);
        leftHand = Offset(cx - w * 0.3, h * 0.8);
        rightElbow = Offset(cx + w * 0.28, h * 0.5);
        rightHand = Offset(cx + w * 0.22, h * 0.32);
        break;
      case 'merci':
        // Les deux mains qui se touchent puis s'ouvrent
        leftElbow = Offset(cx - w * 0.1, h * 0.65);
        leftHand = Offset(cx - w * 0.05, h * 0.52);
        rightElbow = Offset(cx + w * 0.1, h * 0.65);
        rightHand = Offset(cx + w * 0.05, h * 0.52);
        break;
      case 'oui':
        // Pouce levé à droite
        leftElbow = Offset(cx - w * 0.28, h * 0.7);
        leftHand = Offset(cx - w * 0.3, h * 0.8);
        rightElbow = Offset(cx + w * 0.25, h * 0.6);
        rightHand = Offset(cx + w * 0.3, h * 0.38);
        break;
      case 'non':
        // Index gauche levé, bras croisés
        leftElbow = Offset(cx - w * 0.18, h * 0.6);
        leftHand = Offset(cx - w * 0.08, h * 0.4);
        rightElbow = Offset(cx + w * 0.28, h * 0.7);
        rightHand = Offset(cx + w * 0.32, h * 0.82);
        break;
      case 'aide':
        // Les deux bras tendus vers le haut
        leftElbow = Offset(cx - w * 0.28, h * 0.58);
        leftHand = Offset(cx - w * 0.32, h * 0.35);
        rightElbow = Offset(cx + w * 0.28, h * 0.58);
        rightHand = Offset(cx + w * 0.32, h * 0.35);
        break;
      case 'bravo':
      case 'super':
        // Applaudissements : mains au centre
        leftElbow = Offset(cx - w * 0.15, h * 0.62);
        leftHand = Offset(cx - w * 0.05, h * 0.55);
        rightElbow = Offset(cx + w * 0.15, h * 0.62);
        rightHand = Offset(cx + w * 0.05, h * 0.55);
        break;
      case 'question':
        // Index levé et incliné (question)
        leftElbow = Offset(cx - w * 0.28, h * 0.7);
        leftHand = Offset(cx - w * 0.3, h * 0.82);
        rightElbow = Offset(cx + w * 0.2, h * 0.58);
        rightHand = Offset(cx + w * 0.28, h * 0.38);
        break;
      default:
        // Position repos
        leftElbow = Offset(cx - w * 0.3, h * 0.7);
        leftHand = Offset(cx - w * 0.32, h * 0.85);
        rightElbow = Offset(cx + w * 0.3, h * 0.7);
        rightHand = Offset(cx + w * 0.32, h * 0.85);
    }

    final armPaint = Paint()
      ..color = skinColor
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Bras gauche
    final leftPath = Path()
      ..moveTo(cx - w * 0.18, h * 0.66)
      ..quadraticBezierTo(leftElbow.dx, leftElbow.dy, leftHand.dx, leftHand.dy);
    canvas.drawPath(leftPath, armPaint);

    // Bras droit
    final rightPath = Path()
      ..moveTo(cx + w * 0.18, h * 0.66)
      ..quadraticBezierTo(
          rightElbow.dx, rightElbow.dy, rightHand.dx, rightHand.dy);
    canvas.drawPath(rightPath, armPaint);

    // Mains (cercles)
    canvas.drawCircle(leftHand, w * 0.07, skinPaint);
    canvas.drawCircle(rightHand, w * 0.07, skinPaint);

    // Détails de la main selon signe
    _drawHandDetails(canvas, sign, leftHand, rightHand, w);
  }

  void _drawHandDetails(
      Canvas canvas, String sign, Offset left, Offset right, double w) {
    final detailPaint = Paint()
      ..color = skinColor.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    switch (sign) {
      case 'oui':
        // Pouce levé sur main droite
        canvas.drawLine(
          right,
          Offset(right.dx - w * 0.02, right.dy - w * 0.1),
          detailPaint,
        );
        break;
      case 'non':
        // Index levé sur main gauche
        canvas.drawLine(
          left,
          Offset(left.dx, left.dy - w * 0.1),
          detailPaint,
        );
        break;
      case 'bonjour':
        // Doigts écartés sur main droite (lignes)
        for (int i = -2; i <= 2; i++) {
          canvas.drawLine(
            right,
            Offset(right.dx + i * w * 0.03, right.dy - w * 0.1),
            detailPaint,
          );
        }
        break;
    }
  }

  void _drawHair(Canvas canvas, Size size, double cx) {
    final w = size.width;
    final h = size.height;
    final hairPaint = Paint()
      ..color = isFemale ? const Color(0xFF1A0A00) : const Color(0xFF120700);

    if (isFemale) {
      // Calotte haute — couvre le dessus de la tête
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, h * 0.15), // HAUT de la tête, pas le milieu
          width: w * 0.58,
          height: h * 0.24,
        ),
        hairPaint,
      );
      // Mèches latérales tombantes
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - w * 0.28, h * 0.32),
          width: w * 0.10,
          height: h * 0.30,
        ),
        hairPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + w * 0.28, h * 0.32),
          width: w * 0.10,
          height: h * 0.30,
        ),
        hairPaint,
      );
    } else {
      // Cheveux courts masculins — calotte serrée en haut
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, h * 0.14),
          width: w * 0.56,
          height: h * 0.20,
        ),
        hairPaint,
      );
      // Tempes
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - w * 0.27, h * 0.22),
          width: w * 0.09,
          height: h * 0.10,
        ),
        hairPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + w * 0.27, h * 0.22),
          width: w * 0.09,
          height: h * 0.10,
        ),
        hairPaint,
      );
    }
  }

  void _drawFace(Canvas canvas, Size size, double cx) {
    final w = size.width;
    final h = size.height;

    // Yeux
    final eyePaint = Paint()..color = const Color(0xFF1A0A00);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - w * 0.1, h * 0.31), width: 8, height: 6),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + w * 0.1, h * 0.31), width: 8, height: 6),
      eyePaint,
    );

    // Sourcils expressifs selon le signe
    final browPaint = Paint()
      ..color = const Color(0xFF1A0A00)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sign = signId ?? '';
    final isQuestion = sign == 'question' || sign == 'non';
    final isHappy = sign == 'bravo' || sign == 'super' || sign == 'merci';

    // Sourcil gauche
    canvas.drawLine(
      Offset(cx - w * 0.17,
          isQuestion ? h * 0.24 : (isHappy ? h * 0.26 : h * 0.25)),
      Offset(cx - w * 0.06,
          isQuestion ? h * 0.26 : (isHappy ? h * 0.24 : h * 0.25)),
      browPaint,
    );
    // Sourcil droit
    canvas.drawLine(
      Offset(cx + w * 0.06,
          isQuestion ? h * 0.26 : (isHappy ? h * 0.24 : h * 0.25)),
      Offset(cx + w * 0.17,
          isQuestion ? h * 0.24 : (isHappy ? h * 0.26 : h * 0.25)),
      browPaint,
    );

    // Bouche
    final smilePaint = Paint()
      ..color = const Color(0xFF1A0A00)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final mouthPath = Path();
    if (isHappy) {
      // Grand sourire
      mouthPath
        ..moveTo(cx - w * 0.1, h * 0.4)
        ..quadraticBezierTo(cx, h * 0.47, cx + w * 0.1, h * 0.4);
    } else if (isQuestion) {
      // Bouche neutre / légèrement ouverte
      mouthPath
        ..moveTo(cx - w * 0.07, h * 0.41)
        ..quadraticBezierTo(cx, h * 0.44, cx + w * 0.07, h * 0.41);
    } else {
      // Sourire standard
      mouthPath
        ..moveTo(cx - w * 0.08, h * 0.41)
        ..quadraticBezierTo(cx, h * 0.46, cx + w * 0.08, h * 0.41);
    }
    canvas.drawPath(mouthPath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant _FullAvatarPainter old) =>
      old.skinColor != skinColor ||
      old.isFemale != isFemale ||
      old.signId != signId;
}

// ---------------------------------------------------------------------------
// Widgets utilitaires
// ---------------------------------------------------------------------------

class _DotsAnimation extends StatefulWidget {
  @override
  State<_DotsAnimation> createState() => _DotsAnimationState();
}

class _DotsAnimationState extends State<_DotsAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
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
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (t - i * 0.2).clamp(0.0, 1.0);
            final opacity =
                (0.3 + 0.7 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2))
                    .clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF1D9E75).withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

/// Petit timer circulaire affiché sur la preview caméra quand un geste
/// est en attente d'être envoyé (countdown 1.2s).
class _GestureConfirmTimer extends StatefulWidget {
  @override
  State<_GestureConfirmTimer> createState() => _GestureConfirmTimerState();
}

class _GestureConfirmTimerState extends State<_GestureConfirmTimer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
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
      builder: (_, __) => SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          value: _ctrl.value,
          strokeWidth: 3,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Modèles de données locaux
// ---------------------------------------------------------------------------

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isGesture;

  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.isGesture = false,
  });
}

class _QuickIcon {
  final String label;
  final String emoji;
  final String message;

  const _QuickIcon(this.label, this.emoji, this.message);
}
