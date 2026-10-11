import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class GermanyRoadmapView extends StatefulWidget {
  final DashboardController controller;

  const GermanyRoadmapView({super.key, required this.controller});

  @override
  State<GermanyRoadmapView> createState() => _GermanyRoadmapViewState();
}

class _GermanyRoadmapViewState extends State<GermanyRoadmapView> {
  @override
  Widget build(BuildContext context) {
    final milestones = widget.controller.milestones;
    final dreamDates = widget.controller.dreamDates;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Deutschland 24-Monate Fahrplan',
            style: AppTypography.romanticHeadline(fontSize: 24, color: AppColors.champagneGold),
          ),
          const SizedBox(height: 4),
          Text(
            'The step-by-step master roadmap to land together in Germany in October 2028.',
            style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Milestones Timeline
          if (milestones.isNotEmpty)
            ...milestones.asMap().entries.map((entry) {
              final index = entry.key;
              final m = entry.value;
              final isDone = (m['is_completed'] as bool?) ?? false;

              return Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Node
                    Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? Colors.greenAccent.withValues(alpha: 0.2) : AppColors.surfaceGlass,
                            border: Border.all(
                              color: isDone ? Colors.greenAccent : AppColors.champagneGold,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check, size: 18, color: Colors.greenAccent)
                                : Text('${index + 1}', style: AppTypography.numbers(fontSize: 13, color: AppColors.champagneGold)),
                          ),
                        ),
                        if (index < milestones.length - 1)
                          Container(
                            width: 2,
                            height: 60,
                            color: AppColors.borderGlass,
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Milestone Card
                    Expanded(
                      child: RomanticCard(
                        padding: const EdgeInsetsDirectional.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (m['category'] as String? ?? 'Milestone').toUpperCase(),
                                  style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold),
                                ),
                                Text(
                                  m['target_date'] as String? ?? '2028',
                                  style: AppTypography.numbers(fontSize: 12, color: AppColors.velvetPink),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              m['title'] as String? ?? '',
                              style: AppTypography.body(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              m['description'] as String? ?? '',
                              style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton.icon(
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  final newStatus = !isDone;
                                  await widget.controller.toggleMilestone(m['id'] as String, newStatus);
                                },
                                icon: Icon(
                                  isDone ? Icons.check_circle : Icons.circle_outlined,
                                  size: 16,
                                  color: isDone ? Colors.greenAccent : AppColors.textTertiary,
                                ),
                                label: Text(
                                  isDone ? 'Completed 🎉' : 'Mark Complete',
                                  style: TextStyle(fontSize: 11, color: isDone ? Colors.greenAccent : AppColors.textTertiary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
          else
            RomanticCard(
              padding: const EdgeInsetsDirectional.all(24),
              child: Center(child: Text('Loading Germany roadmap from Supabase…', style: AppTypography.body())),
            ),

          const SizedBox(height: 24),

          // Fairytale Dates in Germany
          Text(
            'Our Germany Fairytale Dates',
            style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Magical moments waiting for us once we land in Germany.',
            style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),

          ...dreamDates.map((d) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 10.0),
              child: RomanticCard(
                padding: const EdgeInsetsDirectional.all(14.0),
                child: Row(
                  children: [
                    const Text('🏰', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d['title'] as String? ?? '', style: AppTypography.body(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text(d['location'] as String? ?? 'Germany', style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold)),
                        ],
                      ),
                    ),
                    const Icon(Icons.favorite_rounded, size: 18, color: AppColors.roseQuartz),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
