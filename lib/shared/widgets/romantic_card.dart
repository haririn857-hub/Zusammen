import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';

class RomanticCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  const RomanticCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(20.0),
    this.onTap,
    this.borderRadius = 24.0,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: AppColors.roseQuartz.withOpacity(0.12),
            highlightColor: AppColors.champagneGold.withOpacity(0.06),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.surfaceGlassCard,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor ?? AppColors.borderGlass,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
