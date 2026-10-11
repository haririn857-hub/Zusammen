import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class LoveDeckView extends StatefulWidget {
  final DashboardController controller;

  const LoveDeckView({super.key, required this.controller});

  @override
  State<LoveDeckView> createState() => _LoveDeckViewState();
}

class _LoveDeckViewState extends State<LoveDeckView> {
  int _activeCardIndex = 0;

  void _showAddReasonDialog(BuildContext context) {
    final textController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text('Add a Reason Why I Choose You', style: AppTypography.romanticHeadline(fontSize: 18)),
            content: TextField(
              controller: textController,
              maxLines: 3,
              style: AppTypography.body(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Because…',
                hintStyle: AppTypography.body(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surfaceGlass,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
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
                        final text = textController.text.trim();
                        if (text.isNotEmpty) {
                          setDialogState(() => isSubmitting = true);
                          HapticFeedback.mediumImpact();
                          await widget.controller.addLoveCard(text);
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('💌 Added new reason to our sacred love deck!'),
                              ),
                            );
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Add to Deck', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.controller.loveCards;
    if (_activeCardIndex >= cards.length && cards.isNotEmpty) {
      _activeCardIndex = cards.length - 1;
    }

    final activeReason = cards.isNotEmpty ? cards[_activeCardIndex] : null;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Liebesbriefe & 100 Reasons',
                      style: AppTypography.romanticHeadline(fontSize: 24, color: AppColors.velvetPink),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A private testament of my love for you, ${widget.controller.rintaName}.',
                      style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showAddReasonDialog(context),
                icon: const Icon(Icons.add_circle, color: AppColors.roseQuartz, size: 32),
                tooltip: 'Add new reason',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 100 Reasons Interactive Card
          if (activeReason != null)
            RomanticCard(
              padding: const EdgeInsetsDirectional.all(24),
              borderColor: AppColors.roseQuartz.withValues(alpha: 0.5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.roseQuartz.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Reason #${activeReason['card_number']} of ${cards.length}',
                          style: AppTypography.numbers(fontSize: 12, color: AppColors.velvetPink),
                        ),
                      ),
                      Text(
                        'Forever In My Heart 💖',
                        style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '“${activeReason['reason_text']}”',
                    style: AppTypography.romanticHeadline(fontSize: 20, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '— Forever yours, ${widget.controller.hariName}',
                    style: AppTypography.loveScript(fontSize: 18, color: AppColors.warmBlush),
                  ),
                  const SizedBox(height: 24),

                  // Card Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded, size: 18, color: Colors.white70),
                        onPressed: _activeCardIndex > 0
                            ? () {
                                HapticFeedback.lightImpact();
                                setState(() => _activeCardIndex--);
                              }
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${_activeCardIndex + 1} / ${cards.length}',
                        style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white70),
                        onPressed: _activeCardIndex < cards.length - 1
                            ? () {
                                HapticFeedback.lightImpact();
                                setState(() => _activeCardIndex++);
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            RomanticCard(
              padding: const EdgeInsetsDirectional.all(24),
              child: Center(
                child: Column(
                  children: [
                    const Text('💌', style: TextStyle(fontSize: 32)),
                    const SizedBox(height: 10),
                    Text(
                      'Our Love Deck is Ready',
                      style: AppTypography.romanticHeadline(fontSize: 17, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap the + button above to write our first reason why we choose each other! ❤️',
                      style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 28),

          // Voice Love Pills Shelf (From Database)
          Text(
            'Voice Love Pills (Audio Capsules)',
            style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'When the world feels loud, tap a pill to hear ${widget.controller.partnerName}’s voice beside you.',
            style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),

          if (widget.controller.voicePills.isNotEmpty)
            ...widget.controller.voicePills.map((pill) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildVoicePillCard(
                    title: pill['title'] as String? ?? 'Voice Pill',
                    duration: pill['audio_storage_path'] as String? ?? '0:20',
                    emoji: '💊',
                    subtext: pill['content_encrypted'] as String? ?? '',
                  ),
                ))
          else
            RomanticCard(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Voice love pills will unlock when voice recordings are uploaded 🎙️',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                ),
              ),
            ),

          const SizedBox(height: 28),

          // Time-Locked Envelopes (From Database)
          Text(
            'Time-Locked Wax Envelopes',
            style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),

          if (widget.controller.timeLockedEnvelopes.isNotEmpty)
            ...widget.controller.timeLockedEnvelopes.map((env) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildLockedEnvelope(
                    title: env['title'] as String? ?? 'Time-Locked Letter',
                    lockDate: env['unlock_at'] != null ? env['unlock_at'].toString().split('T').first : 'Target Date',
                    icon: env['audio_storage_path'] as String? ?? '💌',
                  ),
                ))
          else
            RomanticCard(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Time-locked wax envelopes waiting to be written with love 💌',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVoicePillCard({required String title, required String duration, required String emoji, required String subtext}) {
    return RomanticCard(
      padding: const EdgeInsetsDirectional.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.roseQuartz.withValues(alpha: 0.15),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.body(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtext, style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.champagneGold, size: 36),
            onPressed: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('▶️ Playing Hari’s soothing voice pill…'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLockedEnvelope({required String title, required String lockDate, required String icon}) {
    return RomanticCard(
      padding: const EdgeInsetsDirectional.all(16),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.body(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.lock_rounded, size: 12, color: AppColors.champagneGold),
                    const SizedBox(width: 4),
                    Text('Unlocks on $lockDate', style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Sealed 🔒', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
