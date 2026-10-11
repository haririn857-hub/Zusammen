import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';

class LoveKissCelebrationDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String senderName;
  final bool isIncoming;
  final VoidCallback? onSendBack;

  const LoveKissCelebrationDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.senderName,
    this.isIncoming = false,
    this.onSendBack,
  });

  static bool isShowing = false;

  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String senderName,
    bool isIncoming = false,
    VoidCallback? onSendBack,
  }) {
    if (isShowing) return; // Prevent multiple annoying popups stacking on spam
    isShowing = true;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'LoveCelebration',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (ctx, anim1, anim2) {
        return LoveKissCelebrationDialog(
          title: title,
          subtitle: subtitle,
          senderName: senderName,
          isIncoming: isIncoming,
          onSendBack: onSendBack,
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    ).then((_) {
      isShowing = false;
    });

    // Auto dismiss celebration after 4 seconds
    Future.delayed(const Duration(milliseconds: 3800), () {
      if (isShowing && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF261223), Color(0xFF140A12)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.champagneGold.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.roseQuartz.withValues(alpha: 0.45),
                blurRadius: 40,
                spreadRadius: 6,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sparkles & Floating Emojis Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('✨', style: TextStyle(fontSize: 22))
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 600.ms),
                  const SizedBox(width: 8),
                  Text(
                    'ZUSAMMEN TOUCH',
                    style: AppTypography.caption(
                      color: AppColors.champagneGold,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('✨', style: TextStyle(fontSize: 22))
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(1.2, 1.2), end: const Offset(0.8, 0.8), duration: 600.ms),
                ],
              ),
              const SizedBox(height: 20),

              // Glowing Animated Heart Centerpiece
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow Halo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.burgundy.withValues(alpha: 0.35),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.25, 1.25), duration: 700.ms),

                  // Middle Ring
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.flightGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.roseQuartz.withValues(alpha: 0.6),
                          blurRadius: 25,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isIncoming ? '💋' : '❤️',
                        style: const TextStyle(fontSize: 46),
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.18, 1.18), duration: 400.ms)
                      .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.4)),
                ],
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                title,
                style: AppTypography.romanticHeadline(
                  fontSize: 22,
                  color: AppColors.champagneGold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Subtitle / Romantic Message
              Text(
                subtitle,
                style: AppTypography.loveScript(
                  fontSize: 18,
                  color: AppColors.warmBlush,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 26),

              // Action Buttons
              if (isIncoming && onSendBack != null)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    onSendBack?.call();
                  },
                  icon: const Icon(Icons.favorite, color: Colors.white, size: 20),
                  label: const Text('Send Kiss Back 💋', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.roseQuartz,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                )
              else
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.champagneGold.withValues(alpha: 0.6)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  ),
                  child: Text(
                    'Forever Yours ❤️',
                    style: AppTypography.body(color: AppColors.champagneGold, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
