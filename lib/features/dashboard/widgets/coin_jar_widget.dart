import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class CoinJarWidget extends StatelessWidget {
  final DashboardController controller;

  const CoinJarWidget({super.key, required this.controller});

  void _dropCoin(BuildContext context, double amount, String note) async {
    HapticFeedback.mediumImpact();
    await controller.addSavingLog(amount: amount, title: note);

    if (context.mounted) {
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
  }

  void _showCustomDepositDialog(BuildContext context) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Add to Germany Savings', style: AppTypography.romanticHeadline(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: AppTypography.numbers(color: AppColors.champagneGold),
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                labelStyle: AppTypography.body(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surfaceGlass,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              style: AppTypography.body(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Note (e.g. October Salary Savings)',
                labelStyle: AppTypography.body(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surfaceGlass,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.champagneGold, foregroundColor: Colors.black),
            onPressed: () async {
              final amount = double.tryParse(amountController.text.trim());
              if (amount != null && amount > 0) {
                HapticFeedback.mediumImpact();
                final note = noteController.text.trim().isNotEmpty ? noteController.text.trim() : 'Sacrifice savings';
                await controller.addSavingLog(amount: amount, title: note);
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('🎉 Deposited ₹${amount.toInt()} to our Germany fund!'),
                    ),
                  );
                }
              }
            },
            child: const Text('Save to Fund', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
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
            'Every rupee saved at work brings our flight to Munich closer.',
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
          const SizedBox(height: 14),

          // Custom Deposit Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showCustomDepositDialog(context),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.champagneGold),
              label: Text('Log Salary Deposit or Custom Amount', style: AppTypography.body(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.champagneGold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.champagneGold.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
              ),
            ),
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
