import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';
import '../../core/themes/typography.dart';

class RomanticButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isSecondary;
  final Gradient? gradient;

  const RomanticButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isSecondary = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isSecondary ? null : (gradient ?? AppColors.flightGradient),
            color: isSecondary ? AppColors.surfaceGlass : null,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSecondary ? AppColors.borderGlass : AppColors.champagneGold.withValues(alpha: 0.5),
              width: 1.2,
            ),
            boxShadow: isSecondary
                ? null
                : [
                    BoxShadow(
                      color: AppColors.roseQuartz.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTypography.body(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
