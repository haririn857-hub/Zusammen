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
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Add to Deck', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditReasonDialog(BuildContext context, Map<String, dynamic> card) {
    final textController = TextEditingController(text: card['reason_text'] as String? ?? '');
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text('Edit Reason #${card['card_number']}', style: AppTypography.romanticHeadline(fontSize: 18)),
            content: TextField(
              controller: textController,
              maxLines: 3,
              style: AppTypography.body(color: Colors.white),
              decoration: InputDecoration(
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
                          await widget.controller.updateLoveCard(card['id'] as String, text);
                          if (ctx.mounted) Navigator.pop(ctx);
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddVoicePillDialog(BuildContext context) {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    final durationController = TextEditingController(text: '0:35');
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text('Record Voice Love Pill', style: AppTypography.romanticHeadline(fontSize: 18)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: AppTypography.body(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Pill Title (When to listen)',
                      labelStyle: const TextStyle(color: AppColors.champagneGold, fontSize: 13),
                      hintText: 'e.g. Listen when you feel sleepy studying German',
                      hintStyle: AppTypography.body(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surfaceGlass,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: durationController,
                    style: AppTypography.body(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Duration / Tag',
                      labelStyle: const TextStyle(color: AppColors.champagneGold, fontSize: 13),
                      hintText: 'e.g. 0:45 or 1:12',
                      hintStyle: AppTypography.body(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surfaceGlass,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    style: AppTypography.body(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Loving Message / Whisper',
                      labelStyle: const TextStyle(color: AppColors.champagneGold, fontSize: 13),
                      hintText: 'Harimon/Rinta whispering reassuring words with deep love...',
                      hintStyle: AppTypography.body(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surfaceGlass,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
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
                        final note = noteController.text.trim();
                        final dur = durationController.text.trim();
                        if (title.isNotEmpty) {
                          setDialogState(() => isSubmitting = true);
                          HapticFeedback.mediumImpact();
                          await widget.controller.addCourageVaultEntry(
                            title: title,
                            category: 'voice_love_pill',
                            content: note.isNotEmpty ? note : 'A voice whisper filled with love ❤️',
                            audioPath: dur.isNotEmpty ? dur : '0:30',
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('🎙️ Added voice love pill to our shelf!'),
                              ),
                            );
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Save Pill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddEnvelopeDialog(BuildContext context) {
    final titleController = TextEditingController();
    final letterController = TextEditingController();
    DateTime unlockDate = DateTime(2028, 10, 1);
    String selectedIcon = '💌';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final dateStr = '${unlockDate.year}-${unlockDate.month.toString().padLeft(2, '0')}-${unlockDate.day.toString().padLeft(2, '0')}';

          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text('Seal Time-Locked Wax Envelope', style: AppTypography.romanticHeadline(fontSize: 18)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    style: AppTypography.body(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Letter Occasion',
                      labelStyle: const TextStyle(color: AppColors.champagneGold, fontSize: 13),
                      hintText: 'e.g. Open on Our Flight to Frankfurt ✈️',
                      hintStyle: AppTypography.body(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surfaceGlass,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Unlocks on: $dateStr', style: AppTypography.body(color: AppColors.champagneGold, fontSize: 13)),
                    trailing: const Icon(Icons.calendar_month, color: AppColors.roseQuartz),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: unlockDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setDialogState(() => unlockDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('Pick Wax Seal:', style: AppTypography.body(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['💌', '🔐', '💍', '🏡', '✈️'].map((icon) {
                      final isSelected = selectedIcon == icon;
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedIcon = icon),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.roseQuartz.withValues(alpha: 0.3) : AppColors.surfaceGlass,
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? AppColors.roseQuartz : Colors.transparent, width: 1.5),
                          ),
                          child: Text(icon, style: const TextStyle(fontSize: 20)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: letterController,
                    maxLines: 3,
                    style: AppTypography.body(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Secret Letter for the Future',
                      labelStyle: const TextStyle(color: AppColors.champagneGold, fontSize: 13),
                      hintText: 'Words to read when this special day finally arrives...',
                      hintStyle: AppTypography.body(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surfaceGlass,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
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
                        final letter = letterController.text.trim();
                        if (title.isNotEmpty) {
                          setDialogState(() => isSubmitting = true);
                          HapticFeedback.mediumImpact();
                          await widget.controller.addCourageVaultEntry(
                            title: title,
                            category: 'time_locked_envelope',
                            content: letter.isNotEmpty ? letter : 'A secret love letter waiting for our future ❤️',
                            audioPath: selectedIcon,
                            unlockAt: unlockDate,
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('🔐 Wax seal placed! Letter is time-locked for our future.'),
                              ),
                            );
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Seal Envelope', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      style: AppTypography.romanticHeadline(fontSize: 22, color: AppColors.velvetPink),
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
                icon: const Icon(Icons.add_circle, color: AppColors.roseQuartz, size: 30),
                tooltip: 'Add new reason',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 100 Reasons Interactive Card
          if (activeReason != null)
            RomanticCard(
              padding: const EdgeInsetsDirectional.all(22),
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
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.champagneGold),
                            onPressed: () => _showEditReasonDialog(context, activeReason),
                            tooltip: 'Edit Reason',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.textTertiary),
                            onPressed: () => widget.controller.deleteLoveCard(activeReason['id'] as String),
                            tooltip: 'Delete Reason',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '“${activeReason['reason_text']}”',
                    style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '— Forever yours, ${widget.controller.hariName} ❤️',
                    style: AppTypography.loveScript(fontSize: 17, color: AppColors.warmBlush),
                  ),
                  const SizedBox(height: 20),

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

          // Voice Love Pills Shelf Header + Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice Love Pills (Audio Whispers)',
                      style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap a pill to hear ${widget.controller.partnerName}’s reassuring voice.',
                      style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showAddVoicePillDialog(context),
                icon: const Icon(Icons.add_circle, color: AppColors.roseQuartz, size: 26),
                tooltip: 'Add voice love pill',
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (widget.controller.voicePills.isNotEmpty)
            ...widget.controller.voicePills.map((pill) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildVoicePillCard(
                    id: pill['id'] as String,
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
                  'Tap the + icon to record or write a voice love pill for ${widget.controller.partnerName} 🎙️',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          const SizedBox(height: 28),

          // Time-Locked Envelopes Header + Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time-Locked Wax Envelopes',
                      style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Letters sealed until special milestones arrive.',
                      style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showAddEnvelopeDialog(context),
                icon: const Icon(Icons.add_circle, color: AppColors.champagneGold, size: 26),
                tooltip: 'Seal new envelope',
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (widget.controller.timeLockedEnvelopes.isNotEmpty)
            ...widget.controller.timeLockedEnvelopes.map((env) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildLockedEnvelope(
                    id: env['id'] as String,
                    title: env['title'] as String? ?? 'Time-Locked Letter',
                    lockDate: env['unlock_at'] != null ? env['unlock_at'].toString().split('T').first : 'Target Date',
                    icon: env['audio_storage_path'] as String? ?? '💌',
                    content: env['content_encrypted'] as String? ?? '',
                  ),
                ))
          else
            RomanticCard(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Tap the + icon to seal a romantic letter for a future milestone! 💌',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVoicePillCard({
    required String id,
    required String title,
    required String duration,
    required String emoji,
    required String subtext,
  }) {
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
            icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.champagneGold, size: 34),
            onPressed: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.surface,
                  content: Text('▶️ “$subtext” — Whispered with infinite love ❤️', style: AppTypography.body(color: AppColors.warmBlush)),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.textTertiary),
            onPressed: () => widget.controller.deleteCourageVaultEntry(id),
            tooltip: 'Delete Pill',
          ),
        ],
      ),
    );
  }

  Widget _buildLockedEnvelope({
    required String id,
    required String title,
    required String lockDate,
    required String icon,
    required String content,
  }) {
    final unlockDateTime = DateTime.tryParse(lockDate) ?? DateTime(2028, 10, 1);
    final isUnlocked = DateTime.now().isAfter(unlockDateTime);

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
                    Icon(isUnlocked ? Icons.lock_open_rounded : Icons.lock_rounded, size: 12, color: AppColors.champagneGold),
                    const SizedBox(width: 4),
                    Text(isUnlocked ? 'Unlocked for you!' : 'Unlocks on $lockDate', style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.roseQuartz.withValues(alpha: 0.25) : AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                if (isUnlocked) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      title: Text(title, style: AppTypography.romanticHeadline(fontSize: 18)),
                      content: Text(content, style: AppTypography.loveScript(fontSize: 18, color: AppColors.warmBlush)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('🔒 Sealed with wax! Will open on $lockDate when our journey arrives.'),
                    ),
                  );
                }
              },
              child: Text(isUnlocked ? 'Read 💌' : 'Sealed 🔒', style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.textTertiary),
            onPressed: () => widget.controller.deleteCourageVaultEntry(id),
            tooltip: 'Delete Envelope',
          ),
        ],
      ),
    );
  }
}
