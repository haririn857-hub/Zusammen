import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class CoinJarWidget extends StatelessWidget {
  final DashboardController controller;

  const CoinJarWidget({super.key, required this.controller});

  void _dropCoin(BuildContext context, double amount, String note) {
    HapticFeedback.mediumImpact();
    controller.dropSacrificeCoin(amount, note);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Text(
          '🪙 Clink! Added ₹${amount.toInt()} ($note) to our Germany fund!',
          style: AppTypography.body(color: AppColors.champagneGold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RomanticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('Our Germany Sacrifice Jar', style: AppTypography.romanticHeadline(fontSize: 18)),
                ],
              ),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.champagneGold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.coinsInJar} Coins Inside',
                  style: AppTypography.numbers(fontSize: 12, color: AppColors.champagneGold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Every tea or meal skipped at work brings us 10 km closer to Frankfurt.',
            style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),

          // Interactive Drop Buttons
          Row(
            children: [
              Expanded(
                child: _buildSacrificeButton(
                  context: context,
                  title: 'Skipped Tea',
                  amount: 50.0,
                  emoji: '☕',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSacrificeButton(
                  context: context,
                  title: 'Packed Lunch',
                  amount: 150.0,
                  emoji: '🍱',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSacrificeButton(
                  context: context,
                  title: 'Skipped Cab',
                  amount: 250.0,
                  emoji: '🚌',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSacrificeButton({required BuildContext context, required String title, required double amount, required String emoji}) {
    return InkWell(
      onTap: () => _dropCoin(context, amount, title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(title, style: AppTypography.body(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text('+₹${amount.toInt()}', style: AppTypography.numbers(fontSize: 13, color: AppColors.champagneGold)),
          ],
        ),
      ),
    );
  }
}
