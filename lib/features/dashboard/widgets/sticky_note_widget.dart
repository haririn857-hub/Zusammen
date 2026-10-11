import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class StickyNoteWidget extends StatelessWidget {
  final DashboardController controller;

  const StickyNoteWidget({super.key, required this.controller});

  void _showEditNoteDialog(BuildContext context) {
    final textController = TextEditingController(text: controller.myNoteToPartner ?? '');
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(
              'Leave a Note for ${controller.partnerName}',
              style: AppTypography.romanticHeadline(fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This note will appear only on ${controller.partnerName}’s screen when she/he opens our sanctuary.',
                  style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: textController,
                  maxLines: 4,
                  style: AppTypography.body(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Write something romantic, comforting, or funny for ${controller.partnerName}… ❤️',
                    hintStyle: AppTypography.body(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.surfaceGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
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
                  backgroundColor: AppColors.roseQuartz,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final text = textController.text.trim();
                        if (text.isNotEmpty) {
                          setDialogState(() => isSubmitting = true);
                          HapticFeedback.mediumImpact();
                          await controller.postStickyNote(text);
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.surface,
                                content: Text(
                                  '📌 Note pinned for ${controller.partnerName}’s eyes with love! ❤️',
                                  style: AppTypography.body(color: AppColors.champagneGold),
                                ),
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
                    : const Text(
                        'Pin Note',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteFromPartner = controller.partnerNoteToMe;
    final partnerName = controller.partnerName;
    final myNote = controller.myNoteToPartner;

    return RomanticCard(
      padding: const EdgeInsetsDirectional.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('📌', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Note from $partnerName for You',
                        style: AppTypography.romanticHeadline(fontSize: 16, color: AppColors.champagneGold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showEditNoteDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.roseQuartz.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.roseQuartz.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined, size: 13, color: AppColors.roseQuartz),
                      const SizedBox(width: 4),
                      Text(
                        'Write to $partnerName',
                        style: AppTypography.body(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.roseQuartz,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Partner Note Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: noteFromPartner != null ? AppColors.borderGlow.withValues(alpha: 0.4) : AppColors.borderGlass,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (noteFromPartner != null && noteFromPartner.isNotEmpty) ...[
                  Text(
                    '“$noteFromPartner”',
                    style: AppTypography.loveScript(
                      fontSize: 20,
                      color: AppColors.warmBlush,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      '— Forever yours, $partnerName ❤️',
                      style: AppTypography.body(
                        fontSize: 12,
                        color: AppColors.champagneGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      const Icon(Icons.hourglass_empty_rounded, size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$partnerName hasn’t pinned a note for you today yet… tap “Write to $partnerName” to leave her a sweet morning note! ❤️',
                          style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Footer: My Outgoing Note to Partner Preview
          if (myNote != null && myNote.isNotEmpty) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _showEditNoteDialog(context),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.send_rounded, size: 12, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Your note to $partnerName: “$myNote” (tap to edit)',
                        style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
