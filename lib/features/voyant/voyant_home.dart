import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/oara_nav_bar.dart';

class VoyantHome extends StatelessWidget {
  const VoyantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OaraNavBar(
        title: '🙋 Mode Voyant',
        onBack: () => context.go('/onboarding'),
      ),
      body: const Center(
        child: Text(
          'Profil Voyant — bientôt',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
