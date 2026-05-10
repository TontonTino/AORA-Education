import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticService {
  // Vibration courte — navigation réussie
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  // Vibration moyenne — action confirmée
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  // Vibration forte — erreur ou alerte
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  // Pattern — OARA prêt à écouter (3 vibrations courtes)
  static Future<void> readyToListen() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      await Vibration.vibrate(
        pattern: [0, 100, 100, 100, 100, 100],
        intensities: [0, 128, 0, 128, 0, 128],
      );
    }
  }

  // Pattern — IA répond (vibration longue)
  static Future<void> aiResponding() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      await Vibration.vibrate(duration: 300, amplitude: 200);
    }
  }

  // Pattern — erreur (2 vibrations fortes)
  static Future<void> error() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      await Vibration.vibrate(
        pattern: [0, 300, 150, 300],
        intensities: [0, 255, 0, 255],
      );
    }
  }
}
