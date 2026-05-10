import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_language_service.dart';

/// Écran de sélection de l'avatar avant d'entrer dans le module sourd.
/// L'élève choisit : genre (masculin/féminin) + couleur de peau.
class AvatarSelectionScreen extends StatefulWidget {
  final void Function(AvatarProfile profile) onConfirm;

  const AvatarSelectionScreen({super.key, required this.onConfirm});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen>
    with TickerProviderStateMixin {
  AvatarGender _gender = AvatarGender.female;
  SkinTone _skin = SkinTone.dark;

  late final AnimationController _pulseCtrl;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _pulse;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _pulse = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _onGenderTap(AvatarGender g) {
    HapticFeedback.lightImpact();
    setState(() => _gender = g);
    _fadeCtrl.forward(from: 0);
  }

  void _onSkinTap(SkinTone s) {
    HapticFeedback.lightImpact();
    setState(() => _skin = s);
  }

  void _confirm() {
    HapticFeedback.mediumImpact();
    widget.onConfirm(AvatarProfile(gender: _gender, skinTone: _skin));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1D9E75).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1D9E75), width: 1),
            ),
            child: const Text(
              'MODE SOURD  •  OARA',
              style: TextStyle(
                color: Color(0xFF1D9E75),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Choisis\nton avatar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Il communiquera avec toi en langue des signes',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Prévisualisation avatar
          _buildAvatarPreview(),
          const SizedBox(height: 32),

          // Sélection genre
          _buildSectionLabel('Genre'),
          const SizedBox(height: 12),
          _buildGenderSelector(),
          const SizedBox(height: 28),

          // Sélection couleur de peau
          _buildSectionLabel('Couleur de peau'),
          const SizedBox(height: 12),
          _buildSkinSelector(),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _pulse,
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF1D9E75).withOpacity(0.25),
                const Color(0xFF0D1B2A),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF1D9E75).withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D9E75).withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: _AvatarPlaceholder(
              gender: _gender,
              skinTone: _skin,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: _GenderCard(
            label: 'Féminin',
            icon: '👩',
            name: 'Mentora',
            selected: _gender == AvatarGender.female,
            onTap: () => _onGenderTap(AvatarGender.female),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GenderCard(
            label: 'Masculin',
            icon: '👨',
            name: 'Mentor',
            selected: _gender == AvatarGender.male,
            onTap: () => _onGenderTap(AvatarGender.male),
          ),
        ),
      ],
    );
  }

  Widget _buildSkinSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SkinToneChip(
          tone: SkinTone.light,
          color: const Color(0xFFF5D5A0),
          label: 'Clair',
          selected: _skin == SkinTone.light,
          onTap: () => _onSkinTap(SkinTone.light),
        ),
        _SkinToneChip(
          tone: SkinTone.medium,
          color: const Color(0xFFC68A4A),
          label: 'Métissé',
          selected: _skin == SkinTone.medium,
          onTap: () => _onSkinTap(SkinTone.medium),
        ),
        _SkinToneChip(
          tone: SkinTone.dark,
          color: const Color(0xFF6B3A2A),
          label: 'Foncé',
          selected: _skin == SkinTone.dark,
          onTap: () => _onSkinTap(SkinTone.dark),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    final name = _gender == AvatarGender.female ? 'Mentora' : 'Mentor';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _confirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D9E75),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            'Commencer avec $name  →',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets internes
// ---------------------------------------------------------------------------

class _GenderCard extends StatelessWidget {
  final String label;
  final String icon;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1D9E75).withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF1D9E75)
                : Colors.white.withOpacity(0.1),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF1D9E75) : Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkinToneChip extends StatelessWidget {
  final SkinTone tone;
  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SkinToneChip({
    required this.tone,
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 28)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white38,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder SVG-like avatar rendu avec Canvas (pas de dépendance externe)
class _AvatarPlaceholder extends StatelessWidget {
  final AvatarGender gender;
  final SkinTone skinTone;

  const _AvatarPlaceholder({required this.gender, required this.skinTone});

  Color get _skinColor {
    switch (skinTone) {
      case SkinTone.light:
        return const Color(0xFFF5D5A0);
      case SkinTone.medium:
        return const Color(0xFFC68A4A);
      case SkinTone.dark:
        return const Color(0xFF6B3A2A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AvatarPainter(
        skinColor: _skinColor,
        isFemale: gender == AvatarGender.female,
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final Color skinColor;
  final bool isFemale;

  _AvatarPainter({required this.skinColor, required this.isFemale});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // 1. Fond
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF1A2B3C),
    );

    // 2. Corps / épaules
    final shoulderPath = Path()
      ..moveTo(cx - w * 0.38, h)
      ..quadraticBezierTo(cx - w * 0.3, h * 0.74, cx - w * 0.17, h * 0.69)
      ..lineTo(cx + w * 0.17, h * 0.69)
      ..quadraticBezierTo(cx + w * 0.3, h * 0.74, cx + w * 0.38, h)
      ..close();
    canvas.drawPath(shoulderPath, Paint()..color = const Color(0xFF1D9E75));

    // 3. Cou
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - w * 0.07, h * 0.57, w * 0.14, h * 0.13),
        const Radius.circular(4),
      ),
      Paint()..color = skinColor,
    );

    // 4. Tête (dessinée AVANT les cheveux pour que les cheveux soient par-dessus)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, h * 0.38),
        width: w * 0.54,
        height: h * 0.50,
      ),
      Paint()..color = skinColor,
    );

    // 5. Cheveux (par-dessus la tête — ordre correct)
    final hairColor =
        isFemale ? const Color(0xFF1A0A00) : const Color(0xFF120700);
    final hairPaint = Paint()..color = hairColor;

    if (isFemale) {
      // Calotte du dessus (couvre le sommet de la tête)
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, h * 0.20), // centré HAUT de la tête
          width: w * 0.58,
          height: h * 0.28,
        ),
        hairPaint,
      );
      // Prolongement arrière pour couvrir les côtés jusqu'aux épaules
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - w * 0.265, h * 0.38),
          width: w * 0.11,
          height: h * 0.38,
        ),
        hairPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + w * 0.265, h * 0.38),
          width: w * 0.11,
          height: h * 0.38,
        ),
        hairPaint,
      );
    } else {
      // Cheveux courts masculins — calotte serrée sur le haut
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, h * 0.19),
          width: w * 0.56,
          height: h * 0.22,
        ),
        hairPaint,
      );
      // Tempes légères
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - w * 0.26, h * 0.28),
          width: w * 0.10,
          height: h * 0.12,
        ),
        hairPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + w * 0.26, h * 0.28),
          width: w * 0.10,
          height: h * 0.12,
        ),
        hairPaint,
      );
    }

    // 6. Yeux (par-dessus les cheveux si chevauchement)
    final eyePaint = Paint()..color = const Color(0xFF0A0500);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - w * 0.10, h * 0.37), width: 11, height: 7),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + w * 0.10, h * 0.37), width: 11, height: 7),
      eyePaint,
    );
    // Reflets
    canvas.drawCircle(
        Offset(cx - w * 0.085, h * 0.355), 2, Paint()..color = Colors.white54);
    canvas.drawCircle(
        Offset(cx + w * 0.115, h * 0.355), 2, Paint()..color = Colors.white54);

    // 7. Sourire
    final smilePath = Path()
      ..moveTo(cx - w * 0.09, h * 0.445)
      ..quadraticBezierTo(cx, h * 0.50, cx + w * 0.09, h * 0.445);
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF0A0500)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter old) =>
      old.skinColor != skinColor || old.isFemale != isFemale;
}
