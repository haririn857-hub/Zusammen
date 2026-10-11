import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';
import 'love_kiss_celebration_dialog.dart';

class ThumbprintKissWidget extends StatelessWidget {
  final DashboardController controller;

  const ThumbprintKissWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RomanticCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Live Love Touch', style: AppTypography.romanticHeadline(fontSize: 18)),
              Row(
                children: [
                  const Text('🌸', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text('${controller.flowersBloomed} Balcony Blooms', style: AppTypography.numbers(fontSize: 12, color: AppColors.champagneGold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Central Glowing Heart Pulse
          GestureDetector(
            onTap: () {
              controller.triggerHeartPulse();
              LoveKissCelebrationDialog.show(
                context: context,
                title: 'Kiss Sent Across Distance! 💋',
                subtitle: '“Holding your hand right now across the miles… feel my warmth, ${controller.partnerName}”',
                senderName: controller.myName,
                isIncoming: false,
              );
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.flightGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.roseQuartz.withValues(alpha: controller.isHeartBeating ? 0.7 : 0.35),
                    blurRadius: controller.isHeartBeating ? 35 : 20,
                    spreadRadius: controller.isHeartBeating ? 8 : 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 46,
              ),
            ).animate(
              target: controller.isHeartBeating ? 1 : 0,
              onPlay: (c) => c.repeat(reverse: true),
            ).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.15, 1.15),
              duration: 400.ms,
            ),
          ),

          const SizedBox(height: 14),
          Text(
            controller.isHeartBeating ? '“Holding your hand right now across the distance…”' : 'Tap to send an instant Heartbeat & Kiss to ${controller.partnerName}',
            style: AppTypography.loveScript(fontSize: 18, color: AppColors.warmBlush),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
