import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class VibrationHelper {
  /// Rhythmic "Lub-Dub... Lub-Dub" Heartbeat Vibration
  static Future<void> vibrateHeartbeat() async {
    try {
      // First beat (Lub)
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 140));

      // Second beat (Dub)
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 400));

      // Second cycle (Lub)
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 140));

      // Second cycle (Dub)
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
  }

  /// Gentle touch vibration
  static Future<void> vibrateGentle() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }
}
