import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

class DailyCapsuleWidget extends StatefulWidget {
  final DashboardController controller;

  const DailyCapsuleWidget({super.key, required this.controller});

  @override
  State<DailyCapsuleWidget> createState() => _DailyCapsuleWidgetState();
}

class _DailyCapsuleWidgetState extends State<DailyCapsuleWidget> {
  final TextEditingController _answerController = TextEditingController();
  bool _isAnswered = false;
  String? _mySubmittedAnswer;

  final String _todayQuestion = '“What is the very first German meal we will cook together in our kitchen?”';

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_answerController.text.trim().isEmpty) return;
    HapticFeedback.heavyImpact();

    setState(() {
      _isAnswered = true;
      _mySubmittedAnswer = _answerController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('💌 Locked your answer in today’s sacred capsule!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hariName = widget.controller.hariName;
    final rintaName = widget.controller.rintaName;

    return RomanticCard(
      padding: const EdgeInsetsDirectional.all(20),
      borderColor: AppColors.velvetPink.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('✨', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('Daily Love Capsule', style: AppTypography.romanticHeadline(fontSize: 17, color: AppColors.warmBlush)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.roseQuartz.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Today’s Prompt', style: AppTypography.body(fontSize: 10, color: AppColors.velvetPink)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _todayQuestion,
            style: AppTypography.loveScript(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 16),

          if (!_isAnswered) ...[
            TextField(
              controller: _answerController,
              maxLines: 2,
              style: AppTypography.body(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Write your private answer for $rintaName…',
                hintStyle: AppTypography.body(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surfaceGlass,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitAnswer,
                icon: const Icon(Icons.lock_rounded, size: 16, color: Colors.white),
                label: const Text('Lock in Our Capsule', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.roseQuartz,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlass,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGlow),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🔒', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text('$hariName’s Answer Locked:', style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('“$_mySubmittedAnswer”', style: AppTypography.body(fontSize: 13, color: Colors.white)),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Row(
                    children: [
                      const Text('💌', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text('Waiting for $rintaName’s answer to unlock together…', style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
