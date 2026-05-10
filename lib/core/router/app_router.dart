import 'package:go_router/go_router.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/voyant/voyant_home.dart';
import '../../features/non_voyant/non_voyant_home.dart';
import '../../features/sourd/sourd_home.dart'; // SourdEntry est dans ce fichier
import '../../features/muet/muet_home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/voyant',
      builder: (context, state) => const VoyantHome(),
    ),
    GoRoute(
      path: '/non-voyant',
      builder: (context, state) => const NonVoyantHome(),
    ),
    GoRoute(
      path: '/sourd',
      // SourdEntry gère d'abord la sélection d'avatar, puis SourdHome
      builder: (context, state) => const SourdEntry(),
    ),
    GoRoute(
      path: '/muet',
      builder: (context, state) => const MuetHome(),
    ),
  ],
);
