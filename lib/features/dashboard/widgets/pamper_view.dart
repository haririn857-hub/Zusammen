import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';
import 'comfort_coupons_widget.dart';

class PamperView extends StatefulWidget {
  final DashboardController controller;

  const PamperView({super.key, required this.controller});

  @override
  State<PamperView> createState() => _PamperViewState();
}

class _PamperViewState extends State<PamperView> {
  bool _isCookieCracked = false;
  String _currentFortune = '“Scientifically proven: Rintamol has the sweetest, most contagious laugh in Kerala.”';

  final List<String> _fortunes = [
    '“Scientifically proven: Rintamol has the sweetest, most contagious laugh in Kerala.”',
    '“Reminder: The future Mrs. Harikrishnan is looking breathtaking today.”',
    '“Even on your grumpiest, most stubborn days, you are still my favorite human on Earth.”',
    '“You are stronger than any family argument, and you are loved beyond measure.”',
    '“Counting down every second until we share our first hot chocolate in Munich.”',
  ];

  void _crackCookie() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isCookieCracked = true;
      _currentFortune = (_fortunes..shuffle()).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Verwöhnen (Pamper My Queen)',
            style: AppTypography.romanticHeadline(fontSize: 24, color: AppColors.roseQuartz),
          ),
          const SizedBox(height: 4),
          Text(
            'Everything to make Rintamol smile, laugh, and feel loved every single day.',
            style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // Compliment Fortune Cookie
          RomanticCard(
            padding: const EdgeInsetsDirectional.all(20),
            borderColor: AppColors.champagneGold.withValues(alpha: 0.4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Golden Fortune Cookie', style: AppTypography.romanticHeadline(fontSize: 17)),
                    Text('Tap to Crack', style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold)),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _crackCookie,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.champagneGold.withValues(alpha: 0.18),
                      border: Border.all(color: AppColors.champagneGold, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        _isCookieCracked ? '✨' : '🥠',
                        style: const TextStyle(fontSize: 38),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _currentFortune,
                  style: AppTypography.loveScript(fontSize: 18, color: AppColors.warmBlush),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _crackCookie,
                  child: const Text('Crack Another Cookie 🥠', style: TextStyle(fontSize: 12, color: AppColors.champagneGold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Balcony Flower Garden
          RomanticCard(
            padding: const EdgeInsetsDirectional.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('🌸', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text('Our Balcony Garden', style: AppTypography.romanticHeadline(fontSize: 17)),
                      ],
                    ),
                    Text(
                      '${widget.controller.flowersBloomed} Blooms',
                      style: AppTypography.numbers(fontSize: 13, color: AppColors.roseQuartz),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Every time we save money or send flowers, a new bloom opens in our future Munich balcony.',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 14),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('🌹\nRose', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                    Text('🌼\nJasmine', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                    Text('🌻\nSunflower', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                    Text('🌺\nEdelweiss', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      await widget.controller.waterGardenAndSendFlower();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('🌹 Sent a fresh morning bloom to Rintamol!'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.water_drop_rounded, size: 16, color: Colors.white),
                    label: const Text('Send Morning Bloom to Rintamol', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.roseQuartz,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Emergency "Hari, Hold My Hand" Button
          RomanticCard(
            padding: const EdgeInsetsDirectional.all(20),
            borderColor: Colors.redAccent.withValues(alpha: 0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🛡️', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text('The Courage Shield', style: AppTypography.romanticHeadline(fontSize: 17, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'When family arguments or religious tension feel too loud, tap this button.',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      widget.controller.triggerHeartPulse();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xFF2E1A29),
                          content: Text('🫂 “Hari is holding your hand right now. Breathe deeply, my love. We are going to make it.”'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite, size: 18, color: Colors.white),
                    label: const Text('Hari, Hold My Hand Right Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9E2A2B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Comfort Coupons List
          ComfortCouponsWidget(controller: widget.controller),
        ],
      ),
    );
  }
}
