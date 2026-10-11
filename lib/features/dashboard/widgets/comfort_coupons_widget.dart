import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class ComfortCouponsWidget extends StatelessWidget {
  final DashboardController controller;

  const ComfortCouponsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final coupons = controller.coupons;

    return RomanticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🎟️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('${controller.rintaName}’s Pamper Coupons', style: AppTypography.romanticHeadline(fontSize: 18)),
                ],
              ),
              Text(
                'Redeem Anytime',
                style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold),
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
                      const Text('💖', style: TextStyle(fontSize: 22)),
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
                                        '🎉 Coupon redeemed! ${controller.hariName} owes you: ${coupon['title']}',
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
                          isRedeemed ? 'Claimed' : 'Redeem',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('Loading loving coupons…', style: AppTypography.body())),
            ),
        ],
      ),
    );
  }
}
