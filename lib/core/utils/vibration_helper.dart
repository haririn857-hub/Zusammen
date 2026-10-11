import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class VibrationHelper {
  /// Rhythmic "Lub-Dub... Lub-Dub" Heartbeat Vibration
  static Future<void> vibrateHeartbeat() async {
    try {
      // First beat (Lub) - invoke hardware vibration motor
      await HapticFeedback.vibrate();
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 130));

      // Second beat (Dub)
      await HapticFeedback.vibrate();
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 350));

      // Second cycle (Lub)
      await HapticFeedback.vibrate();
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 130));

      // Second cycle (Dub)
      await HapticFeedback.vibrate();
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
  }

  /// Gentle touch vibration
  static Future<void> vibrateGentle() async {
    try {
      await HapticFeedback.vibrate();
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }
}
