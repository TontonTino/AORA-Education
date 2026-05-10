import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Barre de navigation OARA — cohérente sur tous les écrans.
///
/// Usage minimal :
///   OaraNavBar(title: 'Mode Non-Voyant')
///
/// Avec bouton retour personnalisé :
///   OaraNavBar(title: 'Mode Muet', onBack: () => setState(...))
///
/// Avec TTS (mode non-voyant) :
///   OaraNavBar(title: 'Tuteur Vocal', speakOnTap: true, onSpeak: _tts.speak)
///
class OaraNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;

  /// Si null → context.go('/onboarding') par défaut
  final VoidCallback? onBack;

  /// Si true, un bouton 🏠 Accueil supplémentaire est affiché à droite
  final bool showHomeButton;

  /// Callback TTS — si fourni, les boutons annoncent leur action vocalement
  final void Function(String)? onSpeak;

  /// Couleur de fond de la barre
  final Color backgroundColor;

  /// Actions supplémentaires à droite (avant le bouton Accueil)
  final List<Widget> extraActions;

  const OaraNavBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.showHomeButton = true,
    this.onSpeak,
    this.backgroundColor = const Color(0xFF1D9E75),
    this.extraActions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 3);

  void _handleBack(BuildContext context) {
    HapticFeedback.lightImpact();
    onSpeak?.call('Retour');
    if (onBack != null) {
      onBack!();
    } else {
      context.go('/onboarding');
    }
  }

  void _handleHome(BuildContext context) {
    HapticFeedback.mediumImpact();
    onSpeak?.call('Accueil');
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
      leading: Semantics(
        label: 'Bouton retour',
        button: true,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          tooltip: 'Retour',
          onPressed: () => _handleBack(context),
        ),
      ),
      actions: [
        ...extraActions,
        if (showHomeButton)
          Semantics(
            label: 'Bouton accueil — retour au menu principal',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.home_rounded, size: 22),
              tooltip: 'Accueil',
              onPressed: () => _handleHome(context),
            ),
          ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(
          height: 3,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D9E75), Color(0xFFFF6B35), Color(0xFF1D9E75)],
            ),
          ),
        ),
      ),
    );
  }
}

/// Version sans AppBar standard — pour les écrans avec topBar custom (ex: SourdHome, NonVoyantHome dark)
/// Affiche une rangée compacte : [← Retour]  [Titre]  [🏠 Accueil]
class OaraTopRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final void Function(String)? onSpeak;
  final Color foregroundColor;
  final Color backgroundColor;
  final List<Widget> extraActions;

  const OaraTopRow({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.onSpeak,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.extraActions = const [],
  });

  void _handleBack(BuildContext context) {
    HapticFeedback.lightImpact();
    onSpeak?.call('Retour au menu principal');
    if (onBack != null) {
      onBack!();
    } else {
      context.go('/onboarding');
    }
  }

  void _handleHome(BuildContext context) {
    HapticFeedback.mediumImpact();
    onSpeak?.call('Accueil');
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // ← Retour
          Semantics(
            label: 'Retour',
            button: true,
            child: GestureDetector(
              onTap: () => _handleBack(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: foregroundColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new,
                        size: 14, color: foregroundColor),
                    const SizedBox(width: 4),
                    Text(
                      'Retour',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Titre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: foregroundColor.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Actions + 🏠 Accueil
          ...extraActions,
          Semantics(
            label: 'Accueil — retour au menu principal',
            button: true,
            child: GestureDetector(
              onTap: () => _handleHome(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: foregroundColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home_rounded, size: 16, color: foregroundColor),
                    const SizedBox(width: 4),
                    Text(
                      'Accueil',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
