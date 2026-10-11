import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zusammen/features/dashboard/controllers/dashboard_controller.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';

class DualHorizonsWidget extends StatelessWidget {
  final DashboardController? controller;
  const DualHorizonsWidget({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final keralaTime = DateFormat('hh:mm a').format(now);
    // Germany is UTC+2 (CEST) or UTC+1 (CET), Kerala is UTC+5:30 (approx 3.5 hrs behind)
    final germanyTime = DateFormat(
      'hh:mm a',
    ).format(now.subtract(const Duration(hours: 3, minutes: 30)));

    final rintaMood =
        controller?.rintaMember?['current_mood']?.toString().replaceAll(
          '_',
          ' ',
        ) ??
        'peaceful';
    final hariMood =
        controller?.hariMember?['current_mood']?.toString().replaceAll(
          '_',
          ' ',
        ) ??
        'determined';
    final rintaName = controller?.rintaName ?? 'Rintamol';
    final hariName = controller?.hariName ?? 'Hari';

    return Row(
      children: [
        // Kerala Card
        Expanded(
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
                      'Kerala Now',
                      style: AppTypography.body(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  keralaTime,
                  style: AppTypography.numbers(
                    fontSize: 18,
                    color: AppColors.roseQuartz,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$rintaName: $rintaMood',
                  style: AppTypography.body(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Munich Germany Card
        Expanded(
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
                      'Munich Soon',
                      style: AppTypography.body(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  germanyTime,
                  style: AppTypography.numbers(
                    fontSize: 18,
                    color: AppColors.champagneGold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$hariName: $hariMood',
                  style: AppTypography.body(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
