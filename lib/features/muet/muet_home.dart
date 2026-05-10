import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'hand_detector_service.dart';
import '../non_voyant/tts_service.dart';
import '../non_voyant/stt_service.dart';
import '../../core/services/gemini_service.dart';
import 'package:oara/shared/widgets/oara_nav_bar.dart';

enum MuetProfil { muet, sourdMuet }

enum LsfEtape {
  attente,
  proposeLecon,
  choixMatiere,
  choixActivite,
  enCours,
}

// ── Couleurs globales ──────────────────────────────────────────────
const _vert = Color(0xFF1D9E75);
const _vertClair = Color(0xFFE8F5EF);
const _vertFonce = Color(0xFF146B50);
const _orange = Color(0xFFFF6B35);
const _fond = Color(0xFFF7FAF9);

class MuetHome extends StatefulWidget {
  const MuetHome({super.key});

  @override
  State<MuetHome> createState() => _MuetHomeState();
}

class _MuetHomeState extends State<MuetHome>
    with SingleTickerProviderStateMixin {
  final GeminiService _gemini = GeminiService();
  final TtsService _tts = TtsService();
  final SttService _stt = SttService();
  final HandDetectorService _detector = HandDetectorService();
  CameraController? _cameraController;

  MuetProfil? _profil;
  bool _isThinking = false;
  String _lastResponse = '';
  String _userInput = '';

  LsfEtape _lsfEtape = LsfEtape.attente;
  bool _isCameraInitialized = false;
  bool _hasCamera = false;

  final TextEditingController _textController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _tts.init();
    _stt.init();
    _tts.addListener(() => setState(() {}));
    _stt.addListener(() {
      if (mounted) setState(() {});
    });
    _detector.addListener(() {
      if (mounted) setState(() {});
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _hasCamera = false);
        return;
      }
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await _cameraController!.initialize();
      await _detector.init();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
        _hasCamera = true;
      });
      await _cameraController!.startImageStream((image) {
        _detector.processImage(
            image, _cameraController!.description.sensorOrientation);
      });
    } catch (_) {
      setState(() => _hasCamera = false);
    }
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _detector.dispose();
    _tts.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (_isThinking || message.trim().isEmpty) return;
    setState(() {
      _isThinking = true;
      _userInput = message;
      _lastResponse = '';
    });
    final reponse = await _gemini.sendMessage(message);
    setState(() {
      _isThinking = false;
      _lastResponse = reponse;
    });
  }

  Future<void> _onGeste(String geste) async {
    if (_isThinking) return;
    switch (_lsfEtape) {
      case LsfEtape.attente:
        if (geste == 'Bonjour') {
          setState(() => _lsfEtape = LsfEtape.proposeLecon);
          await _sendMessage(
              'L\'élève te dit bonjour en langue des signes. Réponds-lui chaleureusement et demande-lui s\'il veut faire une leçon. Réponse courte, en français simple.');
        }
        break;
      case LsfEtape.proposeLecon:
        if (geste == 'Oui') {
          setState(() => _lsfEtape = LsfEtape.choixMatiere);
          await _sendMessage(
              'L\'élève veut faire une leçon. Propose-lui de choisir entre Maths, Français et Histoire. Présente les 3 options clairement.');
        } else if (geste == 'Non') {
          setState(() => _lsfEtape = LsfEtape.choixActivite);
          await _sendMessage(
              'L\'élève ne veut pas de leçon. Propose-lui 3 alternatives : faire un Exercice, jouer à un Jeu éducatif, ou poser une Question libre. Sois encourageant.');
        }
        break;
      case LsfEtape.choixMatiere:
        if (['Maths', 'Français', 'Histoire'].contains(geste)) {
          setState(() => _lsfEtape = LsfEtape.enCours);
          await _sendMessage(
              'L\'élève choisit $geste. Commence une leçon courte et simple sur $geste, adaptée à un élève du primaire au Burkina Faso.');
        }
        break;
      case LsfEtape.choixActivite:
        if (geste == 'Exercice') {
          setState(() => _lsfEtape = LsfEtape.enCours);
          await _sendMessage(
              'L\'élève veut faire un exercice. Donne-lui un exercice simple de maths ou français, adapté au niveau primaire.');
        } else if (geste == 'Aide') {
          await _sendMessage(
              'L\'élève demande de l\'aide. Explique-lui comment utiliser cette application et ce qu\'il peut apprendre avec toi.');
        }
        break;
      case LsfEtape.enCours:
        if (geste == 'Oui') {
          await _sendMessage(
              'L\'élève répond oui. Continue la leçon ou valide sa réponse.');
        } else if (geste == 'Non') {
          await _sendMessage('L\'élève répond non. Réexplique autrement.');
        } else if (geste == 'Aide') {
          await _sendMessage(
              'L\'élève a besoin d\'aide. Donne un indice simple.');
        } else if (geste == 'Au revoir') {
          setState(() => _lsfEtape = LsfEtape.attente);
          await _sendMessage(
              'L\'élève dit au revoir. Félicite-le pour sa session et encourage-le à revenir.');
        }
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ← AJOUTE CECI
      backgroundColor: _fond,
      appBar: _buildAppBar(),
      body: _profil == null ? _buildChoixProfil() : _buildInterface(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return OaraNavBar(
      title: _profil == null
          ? 'Communication'
          : _profil == MuetProfil.muet
              ? '✍️  Mode Muet'
              : '🤟  Mode Sourd-Muet',
      subtitle: _profil != null ? 'Tap pour envoyer' : null,
      backgroundColor: _vert,
      onBack: () {
        if (_profil == null) {
          context.go('/onboarding');
        } else {
          setState(() {
            _profil = null;
            _lastResponse = '';
            _userInput = '';
            _lsfEtape = LsfEtape.attente;
          });
        }
      },
      // Bouton Accueil toujours visible — retour direct onboarding
      showHomeButton: true,
    );
  }

  // ── Écran choix profil ────────────────────────────────────────────
  Widget _buildChoixProfil() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo OARA
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_vert, _vertFonce],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _vert.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 36),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quel est ton profil ?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0D3D2E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'Choisis le mode qui correspond à ta situation',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          _profilCard(
            icon: Icons.edit_rounded,
            titre: 'Muet',
            description:
                'Tu peux entendre mais pas parler.\nÉcris ta demande, je te réponds par écrit.',
            couleur: _orange,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF4F0), Color(0xFFFFEDE6)],
            ),
            onTap: () {
              _gemini.init(mode: ConversationMode.muet);
              setState(() => _profil = MuetProfil.muet);
            },
          ),
          const SizedBox(height: 16),
          _profilCard(
            icon: Icons.sign_language_rounded,
            titre: 'Sourd-Muet',
            description:
                'Tu communiques par gestes.\nUtilise la caméra pour interagir.',
            couleur: Colors.deepPurple,
            gradient: const LinearGradient(
              colors: [Color(0xFFF5F0FF), Color(0xFFEDE6FF)],
            ),
            onTap: () {
              _gemini.init(mode: ConversationMode.sourd);
              setState(() => _profil = MuetProfil.sourdMuet);
              _initCamera();
            },
          ),
        ],
      ),
    );
  }

  Widget _profilCard({
    required IconData icon,
    required String titre,
    required String description,
    required Color couleur,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: couleur.withValues(alpha: 0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: couleur.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 34, color: couleur),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titre,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: couleur)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54, height: 1.4)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: couleur),
            ),
          ],
        ),
      ),
    );
  }

  // ── Interface principale ──────────────────────────────────────────
  Widget _buildInterface() {
    return Column(
      children: [
        if (_profil == MuetProfil.sourdMuet) _buildCamera(),

        // Zone réponse — GRANDE et centrale
        Expanded(
          child: _profil == MuetProfil.sourdMuet
              ? _buildReponseAvecGestes()
              : _buildReponseTexte(),
        ),
      ],
    );
  }

  // ── Caméra ────────────────────────────────────────────────────────
  Widget _buildCamera() {
    if (!_isCameraInitialized) {
      return Container(
        height: 200,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          SizedBox(
              width: double.infinity, child: CameraPreview(_cameraController!)),
          // Overlay gradient bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 12,
            right: 12,
            child: Text(
              _detector.statusMessage,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ── Zone réponse + gestes (sourd-muet) ───────────────────────────
  Widget _buildReponseAvecGestes() {
    return Column(
      children: [
        // Bulle réponse OARA — grande
        Expanded(
          flex: 3,
          child: _buildBulleReponse(),
        ),
        // Gestes en bas
        _buildGestes(),
      ],
    );
  }

  // ── Zone réponse + saisie (muet) ─────────────────────────────────
  Widget _buildReponseTexte() {
    return Column(
      children: [
        // Bulle réponse OARA — prend tout l'espace central
        Expanded(
          child: _buildBulleReponse(),
        ),
        // Saisie en bas — compacte
        _buildSaisieTexte(),
      ],
    );
  }

  // ── BULLE RÉPONSE — cœur de l'interface ──────────────────────────
  Widget _buildBulleReponse() {
    final aContenu =
        _userInput.isNotEmpty || _isThinking || _lastResponse.isNotEmpty;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: aContenu ? _buildBulleAvecContenu() : _buildBulleVide(),
    );
  }

  Widget _buildBulleVide() {
    return Center(
      key: const ValueKey('vide'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ← CRITIQUE : min pas max
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _pulseAnim,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Color(0xFF2ECC9A), _vert],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _vert.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.school_rounded,
                    color: Colors.white, size: 32),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'OARA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: _vertFonce,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Écris ta question ci-dessous.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulleAvecContenu() {
    return SingleChildScrollView(
      key: const ValueKey('contenu'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Message de l'élève
          if (_userInput.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _vert,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _vert.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      _userInput,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _vert.withValues(alpha: 0.15),
                  child: const Icon(Icons.person, size: 18, color: _vert),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Réponse OARA
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar OARA
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2ECC9A), _vertFonce],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),

              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label OARA
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 4),
                      child: Text(
                        'OARA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _vert,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    // Bulle réponse
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: _vert.withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                      child: _isThinking
                          ? _buildTypingIndicator()
                          : SelectableText(
                              _lastResponse,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1A2E26),
                                height: 1.65,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Indicateur de frappe ──────────────────────────────────────────
  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (_, __) {
            final delay = i * 0.3;
            final t = (_pulseController.value + delay) % 1.0;
            final scale = 0.6 + 0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.only(right: 5),
              width: 10 * scale,
              height: 10 * scale,
              decoration: BoxDecoration(
                color: _vert.withValues(alpha: 0.4 + 0.6 * scale),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }

  // ── Saisie texte (muet) — compacte en bas ────────────────────────
  Widget _buildSaisieTexte() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding:
          const EdgeInsets.fromLTRB(16, 12, 16, 12), // ← plus de viewInsets
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: _fond,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: _vert.withValues(alpha: 0.2), width: 1.5),
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: 4,
                    minLines: 1,
                    style:
                        const TextStyle(fontSize: 15, color: Color(0xFF1A2E26)),
                    decoration: const InputDecoration(
                      hintText: 'Écris ta question ici…',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _isThinking
                    ? null
                    : () {
                        final texte = _textController.text.trim();
                        if (texte.isNotEmpty) {
                          _sendMessage(texte);
                          _textController.clear();
                        }
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: _isThinking
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.grey])
                        : const LinearGradient(
                            colors: [Color(0xFF2ECC9A), _vert],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    shape: BoxShape.circle,
                    boxShadow: _isThinking
                        ? []
                        : [
                            BoxShadow(
                              color: _vert.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: _isThinking
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_rounded,
                          color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              _gemini.resetChat();
              setState(() {
                _lastResponse = '';
                _userInput = '';
              });
            },
            child: const Text(
              '↺  Nouvelle conversation',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ── Gestes LSF/LSB ────────────────────────────────────────────────
  Widget _buildGestes() {
    final Map<LsfEtape, List<Map<String, dynamic>>> gestesParEtape = {
      LsfEtape.attente: [
        {
          'icon': Icons.waving_hand_rounded,
          'label': 'Bonjour',
          'color': Colors.blue
        },
      ],
      LsfEtape.proposeLecon: [
        {'icon': Icons.thumb_up_rounded, 'label': 'Oui', 'color': Colors.green},
        {'icon': Icons.thumb_down_rounded, 'label': 'Non', 'color': Colors.red},
      ],
      LsfEtape.choixMatiere: [
        {
          'icon': Icons.calculate_rounded,
          'label': 'Maths',
          'color': Colors.blue
        },
        {
          'icon': Icons.menu_book_rounded,
          'label': 'Français',
          'color': _orange
        },
        {
          'icon': Icons.public_rounded,
          'label': 'Histoire',
          'color': Colors.brown
        },
      ],
      LsfEtape.choixActivite: [
        {'icon': Icons.edit_rounded, 'label': 'Exercice', 'color': Colors.teal},
        {'icon': Icons.help_outline_rounded, 'label': 'Aide', 'color': _orange},
        {
          'icon': Icons.question_mark_rounded,
          'label': 'Question',
          'color': Colors.deepPurple
        },
      ],
      LsfEtape.enCours: [
        {'icon': Icons.thumb_up_rounded, 'label': 'Oui', 'color': Colors.green},
        {'icon': Icons.thumb_down_rounded, 'label': 'Non', 'color': Colors.red},
        {'icon': Icons.help_outline_rounded, 'label': 'Aide', 'color': _orange},
        {
          'icon': Icons.waving_hand_rounded,
          'label': 'Au revoir',
          'color': Colors.blue
        },
      ],
    };

    final etapeLabel = {
      LsfEtape.attente: 'Fais le signe  👋  pour commencer',
      LsfEtape.proposeLecon: 'Veux-tu faire une leçon ?',
      LsfEtape.choixMatiere: 'Choisis ta matière',
      LsfEtape.choixActivite: 'Que veux-tu faire ?',
      LsfEtape.enCours: 'Continue la conversation',
    };

    final gestes = gestesParEtape[_lsfEtape] ?? [];
    final count = gestes.length;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 12, offset: Offset(0, -3)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicateur drag
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Label étape
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              etapeLabel[_lsfEtape] ?? '',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          // Boutons gestes
          Row(
            children: gestes.map((g) {
              final color = g['color'] as Color;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => _onGeste(g['label'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.symmetric(
                        vertical: count <= 2 ? 18 : 14,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: color.withValues(alpha: 0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(g['icon'] as IconData,
                              size: count <= 2 ? 36 : 28, color: color),
                          const SizedBox(height: 6),
                          Text(
                            g['label'] as String,
                            style: TextStyle(
                              fontSize: count <= 2 ? 13 : 11,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
