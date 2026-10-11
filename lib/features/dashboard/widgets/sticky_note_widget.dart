import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../controllers/dashboard_controller.dart';

class StickyNoteWidget extends StatelessWidget {
  final DashboardController controller;

  const StickyNoteWidget({super.key, required this.controller});

  void _showEditNoteDialog(BuildContext context) {
    final textController = TextEditingController(text: controller.morningNote);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Leave a Note on the Fridge', style: AppTypography.romanticHeadline(fontSize: 18)),
        content: TextField(
          controller: textController,
          maxLines: 3,
          style: AppTypography.body(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Type your morning note for Rintamol…',
            hintStyle: AppTypography.body(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.surfaceGlass,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.roseQuartz),
            onPressed: () async {
              if (textController.text.trim().isNotEmpty) {
                HapticFeedback.mediumImpact();
                await controller.postStickyNote(textController.text.trim());
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('📌 Note pinned to our sacred fridge with love! ❤️'),
                    ),
                  );
                }
              }
            },
            child: const Text('Stick on Fridge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(18.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3B0).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(2, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('📌', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'Morning Note on Our Fridge',
                    style: AppTypography.body(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6B5900),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showEditNoteDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.edit_note_rounded, size: 16, color: Color(0xFF6B5900)),
                      const SizedBox(width: 2),
                      Text('Write', style: AppTypography.body(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF6B5900))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            controller.morningNote,
            style: AppTypography.loveScript(
              fontSize: 19,
              color: const Color(0xFF382D00),
            ),
          ),
        ],
      ),
    );
  }
}
