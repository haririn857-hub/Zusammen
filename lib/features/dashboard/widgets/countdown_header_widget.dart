import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class CountdownHeaderWidget extends StatelessWidget {
  final DashboardController controller;

  const CountdownHeaderWidget({super.key, required this.controller});

  void _pickCustomFlightDate(BuildContext context) async {
    final currentTarget = controller.coupleData?['target_germany_date'] != null
        ? DateTime.tryParse(controller.coupleData!['target_germany_date']) ?? DateTime(2028, 10, 1)
        : DateTime(2028, 10, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: currentTarget,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035, 12, 31),
      helpText: 'CHOOSE OUR DEPARTURE DATE TO GERMANY',
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.champagneGold,
              onPrimary: Colors.black,
              surface: Color(0xFF1E172F),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await controller.updateTargetGermanyDate(picked);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.surface,
            content: Text(
              '✈️ Germany flight target updated to ${DateFormat('MMMM d, yyyy').format(picked)}! Countdown synced.',
              style: AppTypography.body(color: AppColors.champagneGold),
            ),
          ),
        );
      }
    }
  }

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
                controller.hariName,
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
                controller.rintaName,
                style: AppTypography.romanticHeadline(fontSize: 26, color: AppColors.velvetPink),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '“Zwei Herzen, Ein Weg” — Welcome home, ${controller.myName} ${controller.isHari ? "🤴" : "👸"}',
            style: AppTypography.loveScript(fontSize: 18, color: AppColors.warmBlush),
          ),
          const SizedBox(height: 24),

          // Glowing Days Countdown Display (Tap to Customize Date)
          InkWell(
            onTap: () => _pickCustomFlightDate(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'until our flight',
                        style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Text(
                        'Tap to edit ✎',
                        style: AppTypography.body(fontSize: 10, color: AppColors.champagneGold),
                      ),
                    ],
                  ),
                ],
              ),
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
              InkWell(
                onTap: () => _showEditTargetDialog(context),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Sperrkonto Target', style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary)),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit_outlined, size: 12, color: AppColors.champagneGold),
                        ],
                      ),
                      Text(
                        currencyFormatter.format(controller.targetSavingsInr),
                        style: AppTypography.numbers(fontSize: 17, color: AppColors.champagneGold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditTargetDialog(BuildContext context) {
    final textController = TextEditingController(
      text: controller.targetSavingsInr > 0 ? controller.targetSavingsInr.toInt().toString() : '1350000',
    );
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text('Edit Target Fund', style: AppTypography.romanticHeadline(fontSize: 18)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set our combined target amount in INR needed for blocked account & visas:',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  style: AppTypography.body(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    prefixStyle: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: AppColors.surfaceGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _quickTargetChip('₹13.5 Lakhs', 1350000, textController),
                    _quickTargetChip('₹15 Lakhs', 1500000, textController),
                    _quickTargetChip('₹18 Lakhs', 1800000, textController),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.champagneGold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final val = double.tryParse(textController.text.trim().replaceAll(',', ''));
                        if (val != null && val > 0) {
                          setDialogState(() => isSubmitting = true);
                          HapticFeedback.mediumImpact();
                          await controller.updateTargetSavingsInr(val);
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('🎯 Target updated to ₹${val.toInt()}!'),
                              ),
                            );
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Text('Save Target', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _quickTargetChip(String label, int amount, TextEditingController textController) {
    return InkWell(
      onTap: () => textController.text = amount.toString(),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Text(label, style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold)),
      ),
    );
  }
}
