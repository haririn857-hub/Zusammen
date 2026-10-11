import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';

class LoveDeckView extends StatefulWidget {
  const LoveDeckView({super.key});

  @override
  State<LoveDeckView> createState() => _LoveDeckViewState();
}

class _LoveDeckViewState extends State<LoveDeckView> {
  int _activeCardIndex = 0;

  final List<Map<String, dynamic>> _reasons = [
    {
      'number': 1,
      'quote': 'Because when you laugh, all the fatigue of my work and low salary disappears into peace.',
      'category': 'My Sanctuary',
    },
    {
      'number': 2,
      'quote': 'Because you believed in our Germany dream when everyone else in society doubted us.',
      'category': 'My Courage',
    },
    {
      'number': 3,
      'quote': 'Because in your eyes, I see my home, my peace, and my forever wife.',
      'category': 'My Forever',
    },
    {
      'number': 4,
      'quote': 'Because even when our families oppose us, your hand in mine makes me feel invincible.',
      'category': 'Our Shield',
    },
    {
      'number': 5,
      'quote': 'Because no matter how hard life gets, waking up beside you in Munich is worth every battle.',
      'category': 'Our Future',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeReason = _reasons[_activeCardIndex];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Liebesbriefe & 100 Reasons',
            style: AppTypography.romanticHeadline(fontSize: 24, color: AppColors.velvetPink),
          ),
          const SizedBox(height: 4),
          Text(
            'A private testament of my love for you, Rintamol — unshakeable through every storm.',
            style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // 100 Reasons Interactive Card
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
                        'Reason #${activeReason['number']} of 100',
                        style: AppTypography.numbers(fontSize: 12, color: AppColors.velvetPink),
                      ),
                    ),
                    Text(
                      activeReason['category'] as String,
                      style: AppTypography.body(fontSize: 12, color: AppColors.champagneGold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  '“${activeReason['quote']}”',
                  style: AppTypography.romanticHeadline(fontSize: 20, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  '— Forever yours, Harikrishnan',
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
                      '${_activeCardIndex + 1} / ${_reasons.length}',
                      style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white70),
                      onPressed: _activeCardIndex < _reasons.length - 1
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
          ),

          const SizedBox(height: 28),

          // Voice Love Pills Shelf
          Text(
            'Voice Love Pills (Audio Capsules)',
            style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'When the world feels loud, tap a pill to hear Hari’s voice beside you.',
            style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),

          _buildVoicePillCard(
            title: 'Take when family pressure feels heavy',
            duration: '0:22',
            emoji: '💊',
            subtext: '“Rintamol, take a deep breath. In 2 years, we will wake up in Munich…”',
          ),
          const SizedBox(height: 10),
          _buildVoicePillCard(
            title: 'Take when you feel scared about our future',
            duration: '0:18',
            emoji: '🛡️',
            subtext: '“I will protect you with my life. No religion or obstacle will stop us.”',
          ),
          const SizedBox(height: 10),
          _buildVoicePillCard(
            title: 'Take when you just miss your Hari at night',
            duration: '0:25',
            emoji: '🌙',
            subtext: '“Goodnight, my future wife. Look at the moon; I am looking at it too.”',
          ),

          const SizedBox(height: 28),

          // Time-Locked Envelopes
          Text(
            'Time-Locked Wax Envelopes',
            style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),

          _buildLockedEnvelope(
            title: 'To Open at Kochi International Airport (Departure Gate)',
            lockDate: 'October 1, 2028',
            icon: '🛫',
          ),
          const SizedBox(height: 10),
          _buildLockedEnvelope(
            title: 'To Open on the Day We Sign Special Marriage Act Registry',
            lockDate: 'June 1, 2027',
            icon: '💍',
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
