import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/mixin/initializer.dart';
import '../../../services/supabase/service/supabase_service.dart';

class DashboardController extends ChangeNotifier with Initializer {
  bool isLoading = true;
  String? errorMessage;

  // Supabase Client
  SupabaseClient get _client => SupabaseService().client;

  // Couple Data
  Map<String, dynamic>? coupleData;
  double currentSavedInr = 0.0;
  double targetSavingsInr = AppConfig.targetSavingsInr;
  int flowersBloomed = 14;

  // Realtime Live Lists
  List<Map<String, dynamic>> savingsGoals = [];
  List<Map<String, dynamic>> savingsLogs = [];
  List<Map<String, dynamic>> milestones = [];
  List<Map<String, dynamic>> coupons = [];
  List<Map<String, dynamic>> dreamDates = [];
  List<Map<String, dynamic>> loveCards = [];
  String morningNote = 'Good morning Rintamol! Drink warm water, stay strong, and remember: today is one step closer to Munich! ❤️ — Your Hari';

  // Live Pulse State
  bool isHeartBeating = false;

  // Days Calculation
  int get daysRemaining {
    final targetDate = coupleData != null && coupleData!['target_germany_date'] != null
        ? DateTime.tryParse(coupleData!['target_germany_date'] as String) ?? AppConfig.targetGermanyDate
        : AppConfig.targetGermanyDate;
    final diff = targetDate.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  double get savingsPercentage {
    if (targetSavingsInr <= 0) return 0.0;
    return (currentSavedInr / targetSavingsInr).clamp(0.0, 1.0);
  }

  int get coinsInJar => savingsLogs.length;

  RealtimeChannel? _realtimeChannel;

  @override
  Future<void> onInitialize() async {
    await fetchAllData();
    _subscribeToRealtime();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // 1. Fetch Couple Info
      final coupleRes = await _client
          .from('couples')
          .select()
          .eq('id', AppConfig.coupleId)
          .maybeSingle();

      if (coupleRes != null) {
        coupleData = coupleRes;
        targetSavingsInr = (coupleRes['target_savings_inr'] as num?)?.toDouble() ?? AppConfig.targetSavingsInr;
        flowersBloomed = (coupleRes['flowers_bloomed'] as int?) ?? 14;
      }

      // 2. Fetch Savings Logs & Calculate Total
      final logsRes = await _client
          .from('savings_logs')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .order('created_at', ascending: false);
      savingsLogs = List<Map<String, dynamic>>.from(logsRes);

      double sum = 0.0;
      for (final log in savingsLogs) {
        sum += (log['amount'] as num?)?.toDouble() ?? 0.0;
      }
      currentSavedInr = sum;

      // 3. Fetch Savings Goals
      final goalsRes = await _client
          .from('savings_goals')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .order('priority', ascending: true);
      savingsGoals = List<Map<String, dynamic>>.from(goalsRes);

      // 4. Fetch Germany Milestones
      final milestonesRes = await _client
          .from('germany_milestones')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .order('order_index', ascending: true);
      milestones = List<Map<String, dynamic>>.from(milestonesRes);

      // 5. Fetch Comfort Coupons
      final couponsRes = await _client
          .from('comfort_coupons')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .order('created_at', ascending: true);
      coupons = List<Map<String, dynamic>>.from(couponsRes);

      // 6. Fetch Dream Dates
      final datesRes = await _client
          .from('germany_dream_dates')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .order('created_at', ascending: true);
      dreamDates = List<Map<String, dynamic>>.from(datesRes);

      // 7. Fetch Love Deck Cards
      final cardsRes = await _client
          .from('love_deck_cards')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .order('card_number', ascending: true);
      loveCards = List<Map<String, dynamic>>.from(cardsRes);

      // 8. Fetch Active Sticky Note
      final notesRes = await _client
          .from('sticky_notes')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1);

      if (notesRes.isNotEmpty) {
        morningNote = notesRes.first['note_text'] as String? ?? morningNote;
      }

      isLoading = false;
      notifyListeners();
    } catch (e, st) {
      debugPrint('Error fetching Supabase data: $e\n$st');
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void _subscribeToRealtime() {
    try {
      _realtimeChannel = _client.channel('zusammen_couple_realtime');

      // Listen for instant love touch broadcast
      _realtimeChannel?.onBroadcast(event: 'heartbeat_pulse', callback: (payload) {
        isHeartBeating = true;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          isHeartBeating = false;
          notifyListeners();
        });
      });

      _realtimeChannel?.subscribe();
    } catch (e) {
      debugPrint('Realtime subscription error: $e');
    }
  }

  // ==============================================================================
  // REAL ACTIONS (Writing directly to Supabase)
  // ==============================================================================

  /// Add a micro-saving or deposit
  Future<void> addSavingLog({required double amount, required String title, String? note}) async {
    try {
      final newLog = {
        'couple_id': AppConfig.coupleId,
        'amount': amount,
        'title': title,
        'note': note ?? 'Micro-sacrifice coin added with love',
        'currency': 'INR',
        'log_type': 'micro_sacrifice_coin',
      };

      await _client.from('savings_logs').insert(newLog);

      // Increment flower count in couple record
      flowersBloomed += 1;
      await _client.from('couples').update({'flowers_bloomed': flowersBloomed}).eq('id', AppConfig.coupleId);

      // Refresh data
      await fetchAllData();
    } catch (e) {
      debugPrint('Failed to add saving: $e');
      rethrow;
    }
  }

  /// Redeem one of Rintamol's comfort coupons
  Future<void> redeemCoupon(String couponId) async {
    try {
      await _client.from('comfort_coupons').update({
        'is_redeemed': true,
        'redeemed_at': DateTime.now().toIso8601String(),
      }).eq('id', couponId);

      // Local update for instant 0ms feedback
      final index = coupons.indexWhere((c) => c['id'] == couponId);
      if (index != -1) {
        coupons[index]['is_redeemed'] = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to redeem coupon: $e');
      rethrow;
    }
  }

  /// Toggle Germany Roadmap milestone
  Future<void> toggleMilestone(String milestoneId, bool isCompleted) async {
    try {
      await _client.from('germany_milestones').update({
        'is_completed': isCompleted,
        'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
      }).eq('id', milestoneId);

      final index = milestones.indexWhere((m) => m['id'] == milestoneId);
      if (index != -1) {
        milestones[index]['is_completed'] = isCompleted;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to toggle milestone: $e');
      rethrow;
    }
  }

  /// Post a new morning fridge note
  Future<void> postStickyNote(String newNote) async {
    try {
      // Deactivate old notes
      await _client.from('sticky_notes').update({'is_active': false}).eq('couple_id', AppConfig.coupleId);

      // Insert new note
      await _client.from('sticky_notes').insert({
        'couple_id': AppConfig.coupleId,
        'note_text': newNote,
        'color_hex': '#FFF3B0',
        'is_active': true,
      });

      morningNote = newNote;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to post sticky note: $e');
      rethrow;
    }
  }

  /// Add a reason to the 100 reasons love deck
  Future<void> addLoveCard(String reasonText) async {
    try {
      final newCardNumber = loveCards.length + 1;
      await _client.from('love_deck_cards').insert({
        'couple_id': AppConfig.coupleId,
        'card_number': newCardNumber,
        'reason_text': reasonText,
      });

      await fetchAllData();
    } catch (e) {
      debugPrint('Failed to add love card: $e');
      rethrow;
    }
  }

  /// Send a morning flower to Rinta's balcony
  Future<void> waterGardenAndSendFlower() async {
    try {
      flowersBloomed += 1;
      await _client.from('couples').update({'flowers_bloomed': flowersBloomed}).eq('id', AppConfig.coupleId);

      await _client.from('balcony_flowers').insert({
        'couple_id': AppConfig.coupleId,
        'flower_type': 'rose',
        'message': 'Watered with love by Hari',
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to water flower: $e');
      rethrow;
    }
  }

  /// Send live touch / heartbeat pulse
  void triggerHeartPulse() {
    isHeartBeating = true;
    notifyListeners();

    // Broadcast across Supabase Realtime channel
    _realtimeChannel?.sendBroadcastMessage(
      event: 'heartbeat_pulse',
      payload: {'sender': 'Hari', 'timestamp': DateTime.now().toIso8601String()},
    );

    Future.delayed(const Duration(seconds: 3), () {
      isHeartBeating = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}
