import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';

class GermanyRoadmapView extends StatefulWidget {
  const GermanyRoadmapView({super.key});

  @override
  State<GermanyRoadmapView> createState() => _GermanyRoadmapViewState();
}

class _GermanyRoadmapViewState extends State<GermanyRoadmapView> {
  final List<Map<String, dynamic>> _milestones = [
    {
      'title': 'Goethe German A1 Certification',
      'desc': 'Complete first level German exam together with 80%+ score',
      'target': 'Jan 2027',
      'category': 'Language 🇩🇪',
      'isCompleted': false,
    },
    {
      'title': 'APS Certification (India)',
      'desc': 'Submit university transcripts & educational verification to APS India',
      'target': 'Apr 2027',
      'category': 'Education Verification',
      'isCompleted': false,
    },
    {
      'title': 'Special Marriage Act (SMA) Legal Locker',
      'desc': 'Compile 10th certificates, PAN, witness list & safe civil registrar file',
      'target': 'Jun 2027',
      'category': 'Legal Marriage Shield 💍',
      'isCompleted': false,
    },
    {
      'title': 'Goethe German B1 Certification',
      'desc': 'Reach conversational fluency for daily German work & life in Munich',
      'target': 'Sep 2027',
      'category': 'Language 🇩🇪',
      'isCompleted': false,
    },
    {
      'title': 'Sperrkonto Blocked Account Funded',
      'desc': 'Deposit mandatory €11,904 in Expatrio / Fintiba blocked account',
      'target': 'Mar 2028',
      'category': 'Finance 💶',
      'isCompleted': false,
    },
    {
      'title': 'German National Visa Appointment (VFS)',
      'desc': 'Submit passport and spouse/student visa application file',
      'target': 'Jun 2028',
      'category': 'Visa 🛂',
      'isCompleted': false,
    },
    {
      'title': 'Our Flight to Frankfurt / Munich!',
      'desc': 'Take off hand in hand — start our lifetime dream together!',
      'target': 'Oct 1, 2028',
      'category': 'Takeoff ✈️',
      'isCompleted': false,
    },
  ];

  final List<Map<String, dynamic>> _dreamDates = [
    {'title': 'Making our first snowman in the Bavarian snow', 'place': 'Bavarian Alps', 'emoji': '⛄'},
    {'title': 'Neuschwanstein Fairytale Castle hand in hand', 'place': 'Schwangau, Germany', 'emoji': '🏰'},
    {'title': 'Eating warm Apfelstrudel in a cozy wooden cafe', 'place': 'Munich Old Town', 'emoji': '☕'},
    {'title': 'Renting bicycles and riding through English Garden', 'place': 'Munich, Germany', 'emoji': '🚴'},
    {'title': 'Walking through Christmas Markets with spiced cider', 'place': 'Nuremberg / Munich', 'emoji': '🎄'},
  ];

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
          ..._milestones.asMap().entries.map((entry) {
            final index = entry.key;
            final m = entry.value;
            final isDone = m['isCompleted'] as bool;

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
                      if (index < _milestones.length - 1)
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
                              Text(m['category'] as String, style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold)),
                              Text(m['target'] as String, style: AppTypography.numbers(fontSize: 12, color: AppColors.velvetPink)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(m['title'] as String, style: AppTypography.body(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text(m['desc'] as String, style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary)),
                          const SizedBox(height: 10),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton.icon(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                setState(() => m['isCompleted'] = !isDone);
                              },
                              icon: Icon(isDone ? Icons.check_circle : Icons.circle_outlined, size: 16, color: isDone ? Colors.greenAccent : AppColors.textTertiary),
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
          }),

          const SizedBox(height: 24),

          // Fairytale Dates in Germany
          Text(
            'Our Germany Fairytale Dates',
            style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Magical moments waiting for us once we step onto German soil.',
            style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),

          ..._dreamDates.map((d) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 10.0),
              child: RomanticCard(
                padding: const EdgeInsetsDirectional.all(14.0),
                child: Row(
                  children: [
                    Text(d['emoji'] as String, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d['title'] as String, style: AppTypography.body(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text(d['place'] as String, style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold)),
                        ],
                      ),
                    ),
                    const Icon(Icons.favorite_border_rounded, size: 18, color: AppColors.roseQuartz),
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
