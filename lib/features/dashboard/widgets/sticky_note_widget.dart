import 'package:flutter/material.dart';
import '../../../core/themes/typography.dart';
import '../controllers/dashboard_controller.dart';

class StickyNoteWidget extends StatelessWidget {
  final DashboardController controller;

  const StickyNoteWidget({super.key, required this.controller});

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
              Text(
                'Today',
                style: AppTypography.body(
                  fontSize: 11,
                  color: const Color(0xFF8F7B00),
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
