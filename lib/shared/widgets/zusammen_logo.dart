import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';

/// Luxury brand emblem widget for Zusammen
class ZusammenLogo extends StatelessWidget {
  final double size;
  final bool withGlow;
  final bool showBadge;

  const ZusammenLogo({
    super.key,
    this.size = 48,
    this.withGlow = true,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget emblem = Image.asset(
      'assets/logo/zusammen_emblem.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback vector luxury emblem in case asset is loading or missing
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF2B1220), Color(0xFF140912)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.champagneGold.withValues(alpha: 0.8),
              width: size * 0.03,
            ),
          ),
          child: Center(
            child: Text(
              'Z',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: size * 0.55,
                fontWeight: FontWeight.bold,
                color: AppColors.champagneGold,
              ),
            ),
          ),
        );
      },
    );

    if (!withGlow) return emblem;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.roseQuartz.withValues(alpha: 0.25),
            blurRadius: size * 0.35,
            spreadRadius: size * 0.05,
          ),
          BoxShadow(
            color: AppColors.champagneGold.withValues(alpha: 0.15),
            blurRadius: size * 0.2,
          ),
        ],
      ),
      child: emblem,
    );
  }
}
