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
              child: Center(child: Text('Loading our sacred Germany roadmap…', style: AppTypography.body())),
            ),

          const SizedBox(height: 24),

          // Fairytale Dates in Germany Header + Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Germany Fairytale Dates',
                      style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Magical moments waiting for us once we land.',
                      style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showAddDreamDateDialog(context),
                icon: const Icon(Icons.add_circle_outline, color: AppColors.champagneGold, size: 28),
                tooltip: 'Add our own dream date',
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Interactive Golden Scratch-Off Card
          _buildScratchOffCard(context),
          const SizedBox(height: 14),

          if (dreamDates.isNotEmpty)
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
                            Text('${d['location'] ?? 'Germany'} • ${d['season'] ?? 'All Seasons'}', style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold)),
                          ],
                        ),
                      ),
                      const Icon(Icons.favorite_rounded, size: 18, color: AppColors.roseQuartz),
                    ],
                  ),
                ),
              );
            })
          else
            RomanticCard(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const Text('🏰', style: TextStyle(fontSize: 28)),
                    const SizedBox(height: 8),
                    Text(
                      'No Dream Dates Added Yet',
                      style: AppTypography.romanticHeadline(fontSize: 16, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap the + button above to plan our first romantic spot in Munich or the Black Forest! 🍁',
                      style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isDateScratched = false;

  Widget _buildScratchOffCard(BuildContext context) {
    return RomanticCard(
      padding: const EdgeInsetsDirectional.all(18),
      borderColor: AppColors.champagneGold.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('✨ Mystery Date Scratch Card', style: AppTypography.romanticHeadline(fontSize: 16, color: AppColors.champagneGold)),
              Text(_isDateScratched ? 'Revealed 💖' : 'Tap to Scratch', style: AppTypography.body(fontSize: 11, color: AppColors.roseQuartz)),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              HapticFeedback.heavyImpact();
              setState(() => _isDateScratched = !_isDateScratched);
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _isDateScratched
                    ? const LinearGradient(colors: [Color(0xFF2C1625), Color(0xFF1E1428)])
                    : const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFAA7C11)]),
                boxShadow: [
                  BoxShadow(
                    color: (_isDateScratched ? AppColors.roseQuartz : AppColors.champagneGold).withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _isDateScratched ? '🎄 Munich Christmas Glühwein Walk' : '🎁 SECRET DATE SURPRISE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isDateScratched ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isDateScratched
                        ? 'Holding hands in Marienplatz under snowy fairy lights, sipping hot cinnamon cocoa with your forever love.'
                        : 'Tap to scratch off golden foil & reveal our secret date',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isDateScratched ? AppColors.warmBlush : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDreamDateDialog(BuildContext context) {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final seasonController = TextEditingController(text: 'Winter');
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text('Add a Dream Date in Germany', style: AppTypography.romanticHeadline(fontSize: 18)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: AppTypography.body(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Date Idea (e.g. Picnic at Englischer Garten)',
                    labelStyle: AppTypography.body(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.surfaceGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  style: AppTypography.body(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Location in Germany (e.g. Munich, Berlin, Black Forest)',
                    labelStyle: AppTypography.body(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.surfaceGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
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
                        final title = titleController.text.trim();
                        if (title.isNotEmpty) {
                          setDialogState(() => isSubmitting = true);
                          HapticFeedback.mediumImpact();
                          await widget.controller.addDreamDate(
                            title: title,
                            description: 'A magical moment together in Germany',
                            location: locationController.text.trim().isNotEmpty ? locationController.text.trim() : 'Munich',
                            season: seasonController.text.trim(),
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('🏰 Added new fairytale date to our Germany bucket list!'),
                              ),
                            );
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text('Add to Bucket List', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }
}
