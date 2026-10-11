import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class ComfortCouponsWidget extends StatelessWidget {
  final DashboardController controller;

  const ComfortCouponsWidget({super.key, required this.controller});

  void _showAddCouponDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedEmoji = '💆‍♀️';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text('Gift a Pamper Coupon', style: AppTypography.romanticHeadline(fontSize: 18)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a coupon that ${controller.partnerName} can redeem whenever she/he wants pampering.',
                    style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    style: AppTypography.body(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Coupon Title',
                      labelStyle: const TextStyle(color: AppColors.champagneGold, fontSize: 13),
                      hintText: 'e.g. 1 Free Head Massage & Hair Oiling',
                      hintStyle: AppTypography.body(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surfaceGlass,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    style: AppTypography.body(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Terms with Love',
                      labelStyle: const TextStyle(color: AppColors.champagneGold, fontSize: 13),
                      hintText: 'e.g. 30 minutes of gentle relaxation, no questions asked.',
                      hintStyle: AppTypography.body(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surfaceGlass,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Pick an Icon:', style: AppTypography.body(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['💆‍♀️', '🍦', '🕊️', '🫂', '☕', '🎬'].map((emoji) {
                      final isSelected = selectedEmoji == emoji;
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedEmoji = emoji),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.roseQuartz.withValues(alpha: 0.3) : AppColors.surfaceGlass,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.roseQuartz : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Text(emoji, style: const TextStyle(fontSize: 20)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.roseQuartz,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final title = titleController.text.trim();
                        final desc = descController.text.trim();
                        if (title.isNotEmpty) {
                          setDialogState(() => isSubmitting = true);
                          HapticFeedback.mediumImpact();
                          await controller.addComfortCoupon(
                            title: title,
                            description: desc.isNotEmpty ? desc : 'A promise from ${controller.myName} with all my heart ❤️',
                            rewardIcon: selectedEmoji,
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.surface,
                                behavior: SnackBarBehavior.floating,
                                content: Text('🎟️ Gifted new coupon to ${controller.partnerName}!'),
                              ),
                            );
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Gift Coupon', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coupons = controller.coupons;
    final isRinta = controller.isRinta;

    return RomanticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('🎟️', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isRinta
                            ? 'My Pamper Coupons (From ${controller.hariName})'
                            : 'Pamper Coupons for ${controller.rintaName}',
                        style: AppTypography.romanticHeadline(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showAddCouponDialog(context),
                icon: const Icon(Icons.add_circle, color: AppColors.roseQuartz, size: 26),
                tooltip: 'Gift new coupon',
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (coupons.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coupons.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                final isRedeemed = (coupon['is_redeemed'] as bool?) ?? false;
                final emoji = coupon['reward_icon'] as String? ?? '💖';

                return Container(
                  padding: const EdgeInsetsDirectional.all(12),
                  decoration: BoxDecoration(
                    color: isRedeemed ? AppColors.surface.withValues(alpha: 0.4) : AppColors.surfaceGlass,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isRedeemed ? Colors.transparent : AppColors.borderGlow,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon['title'] as String? ?? '',
                              style: AppTypography.body(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isRedeemed ? AppColors.textTertiary : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              coupon['description'] as String? ?? '',
                              style: AppTypography.body(
                                fontSize: 11,
                                color: isRedeemed ? AppColors.textTertiary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isRedeemed
                            ? null
                            : () async {
                                HapticFeedback.heavyImpact();
                                await controller.redeemCoupon(coupon['id'] as String);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.surface,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        isRinta
                                            ? '🎉 Coupon redeemed! ${controller.hariName} owes you: ${coupon['title']} ❤️'
                                            : '🎉 You honored this coupon for ${controller.rintaName}: ${coupon['title']} ❤️',
                                        style: AppTypography.body(color: AppColors.champagneGold),
                                      ),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRedeemed ? Colors.transparent : AppColors.roseQuartz,
                          foregroundColor: Colors.white,
                          elevation: isRedeemed ? 0 : 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 8),
                        ),
                        child: Text(
                          isRedeemed
                              ? (isRinta ? 'Claimed' : 'Redeemed')
                              : (isRinta ? 'Redeem' : 'Honor'),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.textTertiary),
                        onPressed: () {
                          controller.deleteComfortCoupon(coupon['id'] as String);
                        },
                        tooltip: 'Delete Coupon',
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No active coupons right now. Tap the + icon to surprise ${controller.partnerName} with a love coupon! 🎟️',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
