import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zusammen/features/dashboard/controllers/dashboard_controller.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';

class DualHorizonsWidget extends StatelessWidget {
  final DashboardController? controller;
  const DualHorizonsWidget({super.key, this.controller});

  void _showMoodSelector(BuildContext context, String partnerRole, String partnerName) {
    if (controller == null) return;

    final moods = [
      {'key': 'peaceful', 'label': '🕊️ Peaceful & Content'},
      {'key': 'missing_love', 'label': '❤️ Missing You Deeply'},
      {'key': 'determined', 'label': '🇩🇪 Determined for Germany'},
      {'key': 'craving_sweets', 'label': '🍫 Craving Chocolate & Treats'},
      {'key': 'studying_german', 'label': '📚 Studying German B2'},
      {'key': 'need_hugs', 'label': '🫂 Need Tight Hugs'},
      {'key': 'super_happy', 'label': '✨ Radiating Joy'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B1629),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How is $partnerName feeling right now?', style: AppTypography.romanticHeadline(fontSize: 18)),
            const SizedBox(height: 6),
            Text('Tap to update mood across both our phones instantly:', style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: moods.map((m) {
                return ActionChip(
                  backgroundColor: AppColors.surfaceGlass,
                  side: BorderSide(color: AppColors.roseQuartz.withValues(alpha: 0.4)),
                  label: Text(m['label']!, style: AppTypography.body(fontSize: 12, color: Colors.white)),
                  onPressed: () {
                    controller!.updatePartnerMood(partnerRole, m['key']!);
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final keralaTime = DateFormat('hh:mm a').format(now);
    // Germany is UTC+2 (CEST) or UTC+1 (CET), Kerala is UTC+5:30 (approx 3.5 hrs behind)
    final germanyTime = DateFormat('hh:mm a').format(now.subtract(const Duration(hours: 3, minutes: 30)));

    final isHari = controller?.isHari ?? true;
    final rintaMood = controller?.rintaMember?['current_mood']?.toString().replaceAll('_', ' ') ?? 'peaceful';
    final hariMood = controller?.hariMember?['current_mood']?.toString().replaceAll('_', ' ') ?? 'determined';
    final rintaName = controller?.rintaName ?? 'Rintamol';
    final hariName = controller?.hariName ?? 'Harimon';

    return Row(
      children: [
        // Kerala Card
        Expanded(
          child: InkWell(
            onTap: () => _showMoodSelector(context, 'rinta', rintaName),
            borderRadius: BorderRadius.circular(20),
            child: RomanticCard(
              padding: const EdgeInsetsDirectional.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🌴', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        isHari ? '$rintaName’s Heart' : 'My Heart (Kerala)',
                        style: AppTypography.body(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(keralaTime, style: AppTypography.numbers(fontSize: 18, color: AppColors.roseQuartz)),
                  const SizedBox(height: 4),
                  Text(
                    isHari ? '$rintaName: $rintaMood' : 'Mood: $rintaMood ✎',
                    style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Munich Germany Card
        Expanded(
          child: InkWell(
            onTap: () => _showMoodSelector(context, 'hari', hariName),
            borderRadius: BorderRadius.circular(20),
            child: RomanticCard(
              padding: const EdgeInsetsDirectional.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🍁', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        isHari ? 'My Heart (Munich)' : '$hariName’s Heart',
                        style: AppTypography.body(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(germanyTime, style: AppTypography.numbers(fontSize: 18, color: AppColors.champagneGold)),
                  const SizedBox(height: 4),
                  Text(
                    isHari ? 'Mood: $hariMood ✎' : '$hariName: $hariMood',
                    style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
