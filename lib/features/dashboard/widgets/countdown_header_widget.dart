import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class CountdownHeaderWidget extends StatelessWidget {
  final DashboardController controller;

  const CountdownHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return RomanticCard(
      padding: const EdgeInsetsDirectional.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Couple Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hari',
                style: AppTypography.romanticHeadline(fontSize: 26, color: AppColors.champagneGold),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.favorite_rounded,
                  color: AppColors.roseQuartz,
                  size: 20,
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.25, 1.25),
                      duration: 900.ms,
                    ),
              ),
              Text(
                'Rintamol',
                style: AppTypography.romanticHeadline(fontSize: 26, color: AppColors.velvetPink),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '“Zwei Herzen, Ein Weg” — Hand in Hand to Germany',
            style: AppTypography.loveScript(fontSize: 20, color: AppColors.warmBlush),
          ),
          const SizedBox(height: 24),

          // Glowing Days Countdown Display
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderGlow, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.roseQuartz.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flight_takeoff_rounded, color: AppColors.champagneGold, size: 24),
                const SizedBox(width: 12),
                Text(
                  '${controller.daysRemaining} Days',
                  style: AppTypography.romanticHeadline(fontSize: 30, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 8),
                Text(
                  'until our flight',
                  style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 28),

          // Flight Path Trajectory Bar (Kerala to Germany)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.roseQuartz, size: 16),
                  const SizedBox(width: 4),
                  Text('Kochi, India', style: AppTypography.body(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              Text(
                '${(controller.savingsPercentage * 100).toStringAsFixed(1)}% Ready',
                style: AppTypography.numbers(fontSize: 14, color: AppColors.champagneGold),
              ),
              Row(
                children: [
                  const Icon(Icons.pin_drop_rounded, color: AppColors.champagneGold, size: 16),
                  const SizedBox(width: 4),
                  Text('Munich, Germany', style: AppTypography.body(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Visual Progress Arc
          Stack(
            children: [
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceGlass,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                widthFactor: controller.savingsPercentage,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: AppColors.flightGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.roseQuartz.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Financial Goal Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Together Saved', style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary)),
                  Text(
                    currencyFormatter.format(controller.currentSavedInr),
                    style: AppTypography.numbers(fontSize: 17, color: AppColors.champagneGold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Sperrkonto Target', style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary)),
                  Text(
                    currencyFormatter.format(controller.targetSavingsInr),
                    style: AppTypography.numbers(fontSize: 17, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
