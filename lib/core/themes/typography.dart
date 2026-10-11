import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  // Romantic Headline (Playfair Display)
  static TextStyle romanticHeadline({double fontSize = 28, FontWeight fontWeight = FontWeight.w600, Color color = AppColors.textPrimary}) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: -0.5,
      height: 1.2,
    );
  }

  // Handwritten Love Signature (Dancing Script)
  static TextStyle loveScript({double fontSize = 22, Color color = AppColors.warmBlush}) {
    return GoogleFonts.dancingScript(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.5,
    );
  }

  // Modern Clean Body (Outfit)
  static TextStyle body({double fontSize = 14, FontWeight fontWeight = FontWeight.normal, Color color = AppColors.textSecondary}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.4,
    );
  }

  // Numbers & Currency Stats
  static TextStyle numbers({double fontSize = 20, FontWeight fontWeight = FontWeight.w700, Color color = AppColors.champagneGold}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.5,
    );
  }

  // Small Captions & Letterspaced Badges
  static TextStyle caption({double fontSize = 12, FontWeight fontWeight = FontWeight.w600, Color color = AppColors.textTertiary, double letterSpacing = 0.0}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
