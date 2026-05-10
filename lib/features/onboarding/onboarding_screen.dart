import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_profiles.dart';

// ─────────────────────────────────────────────
//  Palette OARA – Chaleureux & Inclusif
// ─────────────────────────────────────────────
class _OaraColors {
  static const background = Color(0xFFFDF8F2);
  static const darkGreen = Color(0xFF1B5E45);
  static const accent = Color(0xFFE07B39);

  // Card colours (mint, lavender, yellow, peach)
  static const cards = [
    Color(0xFFB8EDD8),
    Color(0xFFD4C5F9),
    Color(0xFFFFE9A0),
    Color(0xFFFFCFB8),
  ];

  // Arrow / icon colours
  static const arrows = [
    Color(0xFF3DB87A),
    Color(0xFF8B6FD4),
    Color(0xFFD4A017),
    Color(0xFFE07B39),
  ];

  // Blob decorations
  static const blobTop = Color(0xFFFFD5A8);
  static const blobRight = Color(0xFFB8EDD8);
  static const blobBottom = Color(0xFFD4C5F9);
}

// ─────────────────────────────────────────────
//  Profile data (mirrors AppProfile enum)
// ─────────────────────────────────────────────
class _ProfileData {
  final String label;
  final String subtitle;
  final String emoji; // placeholder for illustration
  final Color cardColor;
  final Color arrowColor;

  const _ProfileData({
    required this.label,
    required this.subtitle,
    required this.emoji,
    required this.cardColor,
    required this.arrowColor,
  });
}

const _profiles = [
  _ProfileData(
    label: 'Voyant',
    subtitle: 'Je suis une personne voyante.',
    emoji: '🙋',
    cardColor: Color(0xFFB8EDD8),
    arrowColor: Color(0xFF3DB87A),
  ),
  _ProfileData(
    label: 'Non-voyant',
    subtitle: 'Je suis une personne non-voyante.',
    emoji: '🦯',
    cardColor: Color(0xFFD4C5F9),
    arrowColor: Color(0xFF8B6FD4),
  ),
  _ProfileData(
    label: 'Sourd',
    subtitle: 'Je suis une personne sourde.',
    emoji: '👂',
    cardColor: Color(0xFFFFE9A0),
    arrowColor: Color(0xFFD4A017),
  ),
  _ProfileData(
    label: 'Muet',
    subtitle: 'Je suis une personne muette.',
    emoji: '🤟',
    cardColor: Color(0xFFFFCFB8),
    arrowColor: Color(0xFFE07B39),
  ),
];

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const _routes = {
    'Voyant': '/voyant',
    'Non-voyant': '/non-voyant',
    'Sourd': '/sourd',
    'Muet': '/muet',
  };

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _cardAnims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _cardAnims = List.generate(_profiles.length, (i) {
      final start = 0.15 * i;
      return CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, start + 0.55, curve: Curves.easeOutCubic),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _OaraColors.background,
      body: Stack(
        children: [
          // ── Decorative blobs ──────────────────────────────
          _Blob(color: _OaraColors.blobTop, top: -60, left: -40, size: 200),
          _Blob(color: _OaraColors.blobRight, top: 80, right: -50, size: 160),
          _Blob(
              color: _OaraColors.blobBottom, bottom: 40, left: -30, size: 180),
          _Blob(
              color: _OaraColors.blobTop.withOpacity(.5),
              bottom: -20,
              right: -20,
              size: 140),

          // ── Content ───────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 36),

                  // OARA title
                  FadeTransition(
                    opacity: CurvedAnimation(
                        parent: _ctrl,
                        curve: const Interval(0, .3, curve: Curves.easeOut)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OARA',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: _OaraColors.darkGreen,
                            letterSpacing: 2,
                            height: 1,
                          ),
                        ),
                        Text(
                          'Bienvenue !',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontStyle: FontStyle.italic,
                            fontSize: 26,
                            color: _OaraColors.accent,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF444444),
                                height: 1.4),
                            children: [
                              const TextSpan(
                                  text:
                                      'Choisis le profil qui te correspond\n'),
                              TextSpan(
                                text: 'pour une expérience personnalisée.',
                                style: TextStyle(
                                    color: _OaraColors.accent,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Profile cards
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _profiles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (ctx, i) {
                        final p = _profiles[i];
                        return AnimatedBuilder(
                          animation: _cardAnims[i],
                          builder: (_, child) => Transform.translate(
                            offset: Offset(0, 40 * (1 - _cardAnims[i].value)),
                            child: Opacity(
                              opacity: _cardAnims[i].value.clamp(0.0, 1.0),
                              child: child,
                            ),
                          ),
                          child: _ProfileCard(
                            data: p,
                            onTap: () => context.go(
                              OnboardingScreen._routes[p.label] ?? '/voyant',
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Profile card
// ─────────────────────────────────────────────
class _ProfileCard extends StatefulWidget {
  final _ProfileData data;
  final VoidCallback onTap;
  const _ProfileCard({required this.data, required this.onTap});

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: widget.data.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.data.cardColor.withOpacity(.55),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Emoji avatar circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.55),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.data.emoji,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.label,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _OaraColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.data.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow button
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.data.arrowColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.data.arrowColor.withOpacity(.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Decorative blob
// ─────────────────────────────────────────────
class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  final double? top, bottom, left, right;

  const _Blob({
    required this.color,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * .65),
            topRight: Radius.circular(size * .35),
            bottomLeft: Radius.circular(size * .40),
            bottomRight: Radius.circular(size * .70),
          ),
        ),
      ),
    );
  }
}
