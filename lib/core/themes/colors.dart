import 'package:flutter/material.dart';

class AppColors {
  // Deep Night Midnight Base (Starry Velvet Obsidian)
  static const Color background = Color(0xFF0C0A14);
  static const Color backgroundSecondary = Color(0xFF141122);
  static const Color surface = Color(0xFF1A162B);
  static const Color surfaceGlass = Color(0x1AFFFFFF);
  static const Color surfaceGlassCard = Color(0x24241E38);
  static const Color borderGlass = Color(0x28FFFFFF);
  static const Color borderGlow = Color(0x40E56B6F);

  // Romantic Velvet Accents
  static const Color roseQuartz = Color(0xFFE56B6F);
  static const Color velvetPink = Color(0xFFF28482);
  static const Color deepRose = Color(0xFFB54B5E);
  static const Color burgundy = Color(0xFF6B1D2F);
  static const Color warmBlush = Color(0xFFF7D6D0);

  // Warm Candlelight & Gold (Germany Dreams & Coins)
  static const Color champagneGold = Color(0xFFF6BD60);
  static const Color softAmber = Color(0xFFE0A96D);
  static const Color paleGold = Color(0xFFFCEADE);

  // Atmospheric Accents (Munich alpine pine & evening sky)
  static const Color alpinePine = Color(0xFF588157);
  static const Color midnightLavender = Color(0xFF352B4E);

  // Typography
  static const Color textPrimary = Color(0xFFFAF7F9);
  static const Color textSecondary = Color(0xFFB8B4C8);
  static const Color textTertiary = Color(0xFF827D96);

  // Gradients
  static const LinearGradient romanticAura = LinearGradient(
    colors: [Color(0xFF20132B), Color(0xFF0C0A14), Color(0xFF130D1C)],
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
  );

  static const LinearGradient flightGradient = LinearGradient(
    colors: [roseQuartz, champagneGold],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );

  static const LinearGradient goldCoinGradient = LinearGradient(
    colors: [Color(0xFFFFDF7A), Color(0xFFE5A638)],
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
  );
}
