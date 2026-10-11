import 'package:flutter/material.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/mixin/initializer.dart';

class DashboardController extends ChangeNotifier with Initializer {
  // Couple Stats
  String partnerBoy = AppConfig.partnerBoy;
  String partnerGirl = AppConfig.partnerGirl;
  String partnerGirlPetName = AppConfig.partnerGirlPetName;

  // Savings State
  double currentSavedInr = 48500.0;
  double targetSavingsInr = AppConfig.targetSavingsInr;
  int coinsInJar = 42;

  // Days Calculation
  int get daysRemaining {
    final now = DateTime.now();
    final difference = AppConfig.targetGermanyDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  double get savingsPercentage {
    if (targetSavingsInr == 0) return 0.0;
    return (currentSavedInr / targetSavingsInr).clamp(0.0, 1.0);
  }

  // Active Morning Note
  String morningNote = "Good morning Rintamol! Don't skip lunch today, stay strong against any outside noise, and remember: we are waking up together in Munich soon. ❤️ — Your Hari";

  // Rinta's Mood
  String currentMood = "Determined & Loving";
  String moodEmoji = "💖";

  // Flowers Bloomed on Balcony
  int flowersBloomed = 14;

  // Heartbeat Live Pulse
  bool isHeartBeating = false;

  // Coupons
  final List<Map<String, dynamic>> coupons = [
    {
      'id': '1',
      'title': 'Win Any Silly Argument Instantly',
      'description': 'Hari must surrender immediately with a smile & chocolate!',
      'isRedeemed': false,
      'emoji': '👑',
    },
    {
      'id': '2',
      'title': 'Midnight Maggi / Hot Chai',
      'description': 'Prepared lovingly by Hari whenever Rinta craves it.',
      'isRedeemed': true,
      'emoji': '🍜',
    },
    {
      'id': '3',
      'title': '30 Mins Hair Oiling & Head Massage',
      'description': 'Complete relaxation without complaints.',
      'isRedeemed': false,
      'emoji': '💆‍♀️',
    },
    {
      'id': '4',
      'title': 'Unlimited Venting Session',
      'description': 'Hari listens quietly with zero advice, just pure hugs.',
      'isRedeemed': false,
      'emoji': '🫂',
    },
  ];

  @override
  Future<void> onInitialize() async {
    // In production, syncs with Supabase & Drift
    notifyListeners();
  }

  // User Actions
  void dropSacrificeCoin(double amount, String note) {
    currentSavedInr += amount;
    coinsInJar += 1;
    flowersBloomed += 1;
    notifyListeners();
  }

  void redeemCoupon(String id) {
    final index = coupons.indexWhere((c) => c['id'] == id);
    if (index != -1) {
      coupons[index]['isRedeemed'] = true;
      notifyListeners();
    }
  }

  void updateMood(String newMood, String emoji) {
    currentMood = newMood;
    moodEmoji = emoji;
    notifyListeners();
  }

  void triggerHeartPulse() {
    isHeartBeating = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      isHeartBeating = false;
      notifyListeners();
    });
  }
}
