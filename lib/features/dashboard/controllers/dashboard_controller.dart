import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/mixin/initializer.dart';
import '../../../services/supabase/service/supabase_service.dart';

class DashboardController extends ChangeNotifier with Initializer {
  bool isLoading = true;
  String? errorMessage;

  SupabaseClient get _client => SupabaseService().client;

  // Couple Data
  Map<String, dynamic>? coupleData;
  double currentSavedInr = 0.0;
  double targetSavingsInr = AppConfig.targetSavingsInr;
  int flowersBloomed = 14;

  // Realtime Live Lists
  List<Map<String, dynamic>> coupleMembers = [];
  List<Map<String, dynamic>> savingsGoals = [];
  List<Map<String, dynamic>> savingsLogs = [];
  List<Map<String, dynamic>> milestones = [];
  List<Map<String, dynamic>> coupons = [];
  List<Map<String, dynamic>> dreamDates = [];
  List<Map<String, dynamic>> loveCards = [];
  List<Map<String, dynamic>> courageVaultEntries = [];
  String morningNote = 'Good morning Rintamol! Drink warm water, stay strong, and remember: today is one step closer to Munich! ❤️ — Your Hari';

  // Live Partner Details
  Map<String, dynamic>? get hariMember =>
      coupleMembers.firstWhere((m) => m['partner_role'] == 'hari', orElse: () => <String, dynamic>{});
  Map<String, dynamic>? get rintaMember =>
      coupleMembers.firstWhere((m) => m['partner_role'] == 'rinta', orElse: () => <String, dynamic>{});

  String get hariName => (hariMember?['pet_name'] as String?) ?? (coupleData?['couple_name']?.toString().split('&').first.trim() ?? 'Hari');
  String get rintaName => (rintaMember?['pet_name'] as String?) ?? (coupleData?['couple_name']?.toString().split('&').last.trim() ?? 'Rintamol');
  String get coupleTitle => (coupleData?['couple_name'] as String?) ?? '$hariName & $rintaName';

  // Dynamic Perspective based on authenticated partner
  bool get isHari => SupabaseService().isCurrentHari;
  bool get isRinta => SupabaseService().isCurrentRinta;
  String get myName => isRinta ? rintaName : hariName;
  String get partnerName => isRinta ? hariName : rintaName;
  String get myRole => isRinta ? 'rinta' : 'hari';
  String get partnerRole => isRinta ? 'hari' : 'rinta';
  Map<String, dynamic>? get myMember => isRinta ? rintaMember : hariMember;
  Map<String, dynamic>? get partnerMember => isRinta ? hariMember : rintaMember;

  List<Map<String, dynamic>> get voicePills =>
      courageVaultEntries.where((e) => e['category'] == 'voice_love_pill').toList();
  List<Map<String, dynamic>> get timeLockedEnvelopes =>
      courageVaultEntries.where((e) => e['category'] == 'time_locked_envelope').toList();
  List<Map<String, dynamic>> get fortuneCompliments =>
      courageVaultEntries.where((e) => e['category'] == 'crisis_support').toList();

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
    await _ensureAuth();
    await fetchAllData();
    _subscribeToRealtime();
  }

  Future<void> _ensureAuth() async {
    await SupabaseService().ensureAuthenticated();
  }

  Future<void> fetchAllData({bool silent = false}) async {
    try {
      if (!silent && coupleData == null) {
        isLoading = true;
        errorMessage = null;
        notifyListeners();
      }

      await _ensureAuth();

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

      // 9. Fetch Live Couple Members
      final membersRes = await _client
          .from('couple_members')
          .select()
          .eq('couple_id', AppConfig.coupleId);
      coupleMembers = List<Map<String, dynamic>>.from(membersRes);

      // 10. Fetch Courage Vault & Voice Pills & Envelopes
      final vaultRes = await _client
          .from('courage_vault_entries')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .order('created_at', ascending: true);
      courageVaultEntries = List<Map<String, dynamic>>.from(vaultRes);

      isLoading = false;
      notifyListeners();
    } catch (e, st) {
      debugPrint('Error fetching data: $e\n$st');
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void _subscribeToRealtime() {
    try {
      _realtimeChannel = _client.channel('zusammen_couple_realtime');

      _realtimeChannel?.onBroadcast(event: 'heartbeat_pulse', callback: (payload) {
        isHeartBeating = true;
        notifyListeners();

        Future.delayed(const Duration(seconds: 4), () {
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
  // OPTIMISTIC ACTIONS (0ms Instant Local Update + Silent Background DB Sync)
  // ==============================================================================

  Future<void> addSavingLog({required double amount, required String title, String? note}) async {
    // 1. Instant Local State Update (0ms lag, zero loading spinner)
    final tempId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
    final optimisticLog = {
      'id': tempId,
      'couple_id': AppConfig.coupleId,
      'amount': amount,
      'title': title,
      'note': note ?? 'Micro-sacrifice coin added with love',
      'currency': 'INR',
      'log_type': 'micro_sacrifice_coin',
      'created_at': DateTime.now().toIso8601String(),
    };
    savingsLogs.insert(0, optimisticLog);
    currentSavedInr += amount;
    flowersBloomed += 1;
    notifyListeners();

    // 2. Silent Background Database Synchronization
    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c';
      final newLog = {
        'couple_id': AppConfig.coupleId,
        'user_id': userId,
        'amount': amount,
        'title': title,
        'note': note ?? 'Micro-sacrifice coin added with love',
        'currency': 'INR',
        'log_type': 'micro_sacrifice_coin',
      };

      await _client.from('savings_logs').insert(newLog);
      await _client.from('couples').update({'flowers_bloomed': flowersBloomed}).eq('id', AppConfig.coupleId);

      // Silent sync in background without showing loading indicator
      await fetchAllData(silent: true);
    } catch (e) {
      debugPrint('Silent sync error on addSavingLog: $e');
    }
  }

  Future<void> updateTargetGermanyDate(DateTime newDate) async {
    // 1. Instant Local Update
    final dateStr = '${newDate.year.toString().padLeft(4, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';
    coupleData ??= {};
    coupleData!['target_germany_date'] = dateStr;
    notifyListeners();

    // 2. Background Sync
    try {
      await _ensureAuth();
      await _client.from('couples').update({'target_germany_date': dateStr}).eq('id', AppConfig.coupleId);
      await fetchAllData(silent: true);
    } catch (e) {
      debugPrint('Failed to update target date: $e');
    }
  }

  Future<void> updatePartnerMood(String partnerRole, String newMood) async {
    // 1. Instant Local Update
    final index = coupleMembers.indexWhere((m) => m['partner_role'] == partnerRole);
    if (index != -1) {
      coupleMembers[index]['current_mood'] = newMood;
      notifyListeners();
    }

    // 2. Background Sync
    try {
      await _ensureAuth();
      await _client.from('couple_members').update({
        'current_mood': newMood,
        'last_active': DateTime.now().toIso8601String(),
      }).eq('couple_id', AppConfig.coupleId).eq('partner_role', partnerRole);
    } catch (e) {
      debugPrint('Failed to update partner mood: $e');
    }
  }

  Future<void> addSavingsGoal({
    required String title,
    required double targetAmount,
    required String currency,
    required String category,
  }) async {
    // 1. Instant Local Update
    final tempGoal = {
      'id': 'temp-${DateTime.now().millisecondsSinceEpoch}',
      'couple_id': AppConfig.coupleId,
      'title': title,
      'target_amount': targetAmount,
      'currency': currency,
      'category': category,
      'priority': savingsGoals.length + 1,
      'is_completed': false,
    };
    savingsGoals.add(tempGoal);
    notifyListeners();

    // 2. Background Sync
    try {
      await _ensureAuth();
      await _client.from('savings_goals').insert({
        'couple_id': AppConfig.coupleId,
        'title': title,
        'target_amount': targetAmount,
        'currency': currency,
        'category': category,
        'priority': savingsGoals.length,
      });
      await fetchAllData(silent: true);
    } catch (e) {
      debugPrint('Failed to add savings goal: $e');
    }
  }

  Future<void> addDreamDate({
    required String title,
    required String description,
    required String location,
    required String season,
  }) async {
    // 1. Instant Local Update
    final tempDate = {
      'id': 'temp-${DateTime.now().millisecondsSinceEpoch}',
      'couple_id': AppConfig.coupleId,
      'title': title,
      'description': description,
      'location': location,
      'season': season,
      'is_completed': false,
    };
    dreamDates.add(tempDate);
    notifyListeners();

    // 2. Background Sync
    try {
      await _ensureAuth();
      await _client.from('germany_dream_dates').insert({
        'couple_id': AppConfig.coupleId,
        'title': title,
        'description': description,
        'location': location,
        'season': season,
      });
      await fetchAllData(silent: true);
    } catch (e) {
      debugPrint('Failed to add dream date: $e');
    }
  }

  Future<void> redeemCoupon(String couponId) async {
    // 1. Instant Local Update
    final index = coupons.indexWhere((c) => c['id'] == couponId);
    if (index != -1) {
      coupons[index]['is_redeemed'] = true;
      notifyListeners();
    }

    // 2. Background Sync
    try {
      await _ensureAuth();
      await _client.from('comfort_coupons').update({
        'is_redeemed': true,
        'redeemed_at': DateTime.now().toIso8601String(),
      }).eq('id', couponId);
    } catch (e) {
      debugPrint('Failed to redeem coupon: $e');
    }
  }

  Future<void> toggleMilestone(String milestoneId, bool isCompleted) async {
    // 1. Instant Local Update
    final index = milestones.indexWhere((m) => m['id'] == milestoneId);
    if (index != -1) {
      milestones[index]['is_completed'] = isCompleted;
      notifyListeners();
    }

    // 2. Background Sync
    try {
      await _ensureAuth();
      await _client.from('germany_milestones').update({
        'is_completed': isCompleted,
        'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
      }).eq('id', milestoneId);
    } catch (e) {
      debugPrint('Failed to toggle milestone: $e');
    }
  }

  Future<void> postStickyNote(String noteText) async {
    // 1. Instant Local Update
    morningNote = noteText;
    notifyListeners();

    // 2. Background Sync
    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c';
      await _client.from('sticky_notes').update({'is_active': false}).eq('couple_id', AppConfig.coupleId);

      await _client.from('sticky_notes').insert({
        'couple_id': AppConfig.coupleId,
        'author_id': userId,
        'note_text': noteText,
        'color_hex': '#FFE4E6',
        'is_active': true,
      });
    } catch (e) {
      debugPrint('Failed to post note: $e');
    }
  }

  Future<void> addLoveCard(String reasonText) async {
    // 1. Instant Local Update
    final newCardNumber = loveCards.length + 1;
    final tempCard = {
      'id': 'temp-${DateTime.now().millisecondsSinceEpoch}',
      'couple_id': AppConfig.coupleId,
      'card_number': newCardNumber,
      'reason_text': reasonText,
      'created_at': DateTime.now().toIso8601String(),
    };
    loveCards.add(tempCard);
    notifyListeners();

    // 2. Background Sync
    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c';
      await _client.from('love_deck_cards').insert({
        'couple_id': AppConfig.coupleId,
        'author_id': userId,
        'card_number': newCardNumber,
        'reason_text': reasonText,
      });
    } catch (e) {
      debugPrint('Failed to add love card: $e');
    }
  }

  Future<void> waterGardenAndSendFlower() async {
    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c';

      flowersBloomed += 1;
      await _client.from('couples').update({'flowers_bloomed': flowersBloomed}).eq('id', AppConfig.coupleId);

      await _client.from('balcony_flowers').insert({
        'couple_id': AppConfig.coupleId,
        'sender_id': userId,
        'flower_type': 'rose',
        'message': 'Watered with love by $myName',
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to water flower: $e');
      rethrow;
    }
  }

  void triggerHeartPulse() {
    isHeartBeating = true;
    notifyListeners();

    _realtimeChannel?.sendBroadcastMessage(
      event: 'heartbeat_pulse',
      payload: {'sender': myName, 'timestamp': DateTime.now().toIso8601String()},
    );

    Future.delayed(const Duration(seconds: 3), () {
      isHeartBeating = false;
      notifyListeners();
    });
  }

  /// Locks sanctuary and resets local state
  Future<void> signOut() async {
    await SupabaseService().signOut();
    coupleData = null;
    coupleMembers = [];
    savingsGoals = [];
    savingsLogs = [];
    milestones = [];
    coupons = [];
    dreamDates = [];
    loveCards = [];
    courageVaultEntries = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}
