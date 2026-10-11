import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';

class StardustBackground extends StatelessWidget {
  final Widget child;

  const StardustBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base Deep Gradient
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.romanticAura,
          ),
        ),

        // Glowing Rose Quartz Bokeh Aura (Top Left)
        PositionedDirectional(
          top: -size.height * 0.1,
          start: -size.width * 0.15,
          child: Container(
            width: size.width * 0.65,
            height: size.width * 0.65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.roseQuartz.withValues(alpha: 0.18),
            ),
          ),
        ),

        // Glowing Champagne Gold Aura (Center Right)
        PositionedDirectional(
          top: size.height * 0.35,
          end: -size.width * 0.2,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.champagneGold.withValues(alpha: 0.12),
            ),
          ),
        ),

        // Deep Lavender Midnight Aura (Bottom Left)
        PositionedDirectional(
          bottom: -size.height * 0.08,
          start: -size.width * 0.1,
          child: Container(
            width: size.width * 0.6,
            height: size.width * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.midnightLavender.withValues(alpha: 0.35),
            ),
          ),
        ),

        // Foreground Content
        child,
      ],
    );
  }
}
