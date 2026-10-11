import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/mixin/initializer.dart';
import '../../../core/utils/vibration_helper.dart';
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

  bool isSubmitting = false;
  String? incomingAlertMessage;
  String? incomingKissSender;

  void clearIncomingAlert() {
    incomingAlertMessage = null;
  }

  void clearIncomingKiss() {
    incomingKissSender = null;
  }

  // Realtime Live Lists
  List<Map<String, dynamic>> coupleMembers = [];
  List<Map<String, dynamic>> savingsGoals = [];
  List<Map<String, dynamic>> savingsLogs = [];
  List<Map<String, dynamic>> milestones = [];
  List<Map<String, dynamic>> coupons = [];
  List<Map<String, dynamic>> dreamDates = [];
  List<Map<String, dynamic>> loveCards = [];
  List<Map<String, dynamic>> courageVaultEntries = [];
  List<Map<String, dynamic>> stickyNotes = [];

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
  String get myUserId => isHari ? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c' : '83c2770e-d03d-4985-ba3a-1f7ca5c0b05d';

  // Partner Sticky Notes
  Map<String, dynamic>? get latestNoteFromHari {
    try {
      return stickyNotes.firstWhere((n) => n['author_id'] == '29ed297a-c70a-41ae-b3a8-ff25c1ec562c');
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? get latestNoteFromRinta {
    try {
      return stickyNotes.firstWhere((n) => n['author_id'] == '83c2770e-d03d-4985-ba3a-1f7ca5c0b05d');
    } catch (_) {
      return null;
    }
  }

  /// Note written by the partner to the current user
  String? get partnerNoteToMe {
    final note = isHari ? latestNoteFromRinta : latestNoteFromHari;
    return note?['note_text'] as String?;
  }

  /// Note written by the current user to their partner
  String? get myNoteToPartner {
    final note = isHari ? latestNoteFromHari : latestNoteFromRinta;
    return note?['note_text'] as String?;
  }

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

      // 8. Fetch Active Sticky Notes for both partners
      final notesRes = await _client
          .from('sticky_notes')
          .select()
          .eq('couple_id', AppConfig.coupleId)
          .eq('is_active', true)
          .order('created_at', ascending: false);
      stickyNotes = List<Map<String, dynamic>>.from(notesRes);


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
      _realtimeChannel = _client.channel(
        'couple_realtime_${AppConfig.coupleId}',
        opts: const RealtimeChannelConfig(ack: true),
      );

      _realtimeChannel
          ?.onBroadcast(event: 'heartbeat_pulse', callback: (payload) {
            final sender = (payload['sender'] as String?) ?? partnerName;
            debugPrint('Received heartbeat pulse from partner: $payload');
            isHeartBeating = true;
            incomingKissSender = sender;
            notifyListeners();
            VibrationHelper.vibrateHeartbeat();

            Future.delayed(const Duration(seconds: 4), () {
              isHeartBeating = false;
              notifyListeners();
            });
          })
          .onBroadcast(event: 'note_updated', callback: (payload) {
            final sender = (payload['sender'] as String?) ?? partnerName;
            debugPrint('Partner updated sticky note. Syncing...');
            incomingAlertMessage = '📌 $sender pinned a new love note for your eyes! ❤️';
            fetchAllData(silent: true);
            VibrationHelper.vibrateHeartbeat();
            notifyListeners();
          })
          .onBroadcast(event: 'mood_updated', callback: (payload) {
            debugPrint('Partner updated mood. Syncing...');
            fetchAllData(silent: true);
          })
          .onBroadcast(event: 'savings_updated', callback: (payload) {
            final sender = (payload['sender'] as String?) ?? partnerName;
            debugPrint('Partner updated savings. Syncing...');
            if (payload['amount'] != null) {
              incomingAlertMessage = '🪙 $sender dropped ₹${(payload['amount'] as num).toInt()} in our Germany fund!';
              VibrationHelper.vibrateGentle();
            } else if (payload['new_target'] != null) {
              incomingAlertMessage = '🎯 $sender updated our Sperrkonto Target to ₹${(payload['new_target'] as num).toInt()}!';
              VibrationHelper.vibrateGentle();
            }
            fetchAllData(silent: true);
            notifyListeners();
          })
          .onBroadcast(event: 'flower_watered', callback: (payload) {
            final sender = (payload['sender'] as String?) ?? partnerName;
            debugPrint('Partner watered the balcony garden. Syncing...');
            incomingAlertMessage = '🌸 $sender watered our balcony blooms!';
            fetchAllData(silent: true);
            VibrationHelper.vibrateGentle();
            notifyListeners();
          })
          .subscribe((status, error) {
            debugPrint('Realtime channel status: $status, error: $error');
          });
    } catch (e) {
      debugPrint('Realtime subscription error: $e');
    }
  }

  // ==============================================================================
  // OPTIMISTIC ACTIONS (0ms Instant Local Update + Silent Background DB Sync)
  // ==============================================================================

  Future<void> addSavingLog({required double amount, required String title, String? note}) async {
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();

    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? (isHari ? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c' : '83c2770e-d03d-4985-ba3a-1f7ca5c0b05d');
      final newLog = {
        'couple_id': AppConfig.coupleId,
        'user_id': userId,
        'amount': amount,
        'title': title,
        'note': note ?? 'Micro-sacrifice coin added with love',
        'currency': 'INR',
        'log_type': 'micro_sacrifice_coin',
      };

      final inserted = await _client.from('savings_logs').insert(newLog).select().single();
      savingsLogs.insert(0, inserted);
      currentSavedInr += amount;
      flowersBloomed += 1;

      await _client.from('couples').update({'flowers_bloomed': flowersBloomed}).eq('id', AppConfig.coupleId);

      _realtimeChannel?.sendBroadcastMessage(
        event: 'savings_updated',
        payload: {'sender': myName, 'amount': amount},
      );
    } catch (e) {
      debugPrint('Error on addSavingLog: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> updateTargetGermanyDate(DateTime newDate) async {
    final dateStr = '${newDate.year.toString().padLeft(4, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';
    coupleData ??= {};
    coupleData!['target_germany_date'] = dateStr;
    notifyListeners();

    try {
      await _ensureAuth();
      await _client.from('couples').update({'target_germany_date': dateStr}).eq('id', AppConfig.coupleId);
    } catch (e) {
      debugPrint('Failed to update target date: $e');
    }
  }

  Future<void> updatePartnerMood(String partnerRole, String newMood) async {
    final index = coupleMembers.indexWhere((m) => m['partner_role'] == partnerRole);
    if (index != -1) {
      coupleMembers[index]['current_mood'] = newMood;
      notifyListeners();
    }

    try {
      await _ensureAuth();
      await _client.from('couple_members').update({
        'current_mood': newMood,
        'last_active': DateTime.now().toIso8601String(),
      }).eq('couple_id', AppConfig.coupleId).eq('partner_role', partnerRole);

      _realtimeChannel?.sendBroadcastMessage(
        event: 'mood_updated',
        payload: {'sender': myName, 'role': partnerRole, 'mood': newMood},
      );
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
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();

    try {
      await _ensureAuth();
      final inserted = await _client.from('savings_goals').insert({
        'couple_id': AppConfig.coupleId,
        'title': title,
        'target_amount': targetAmount,
        'currency': currency,
        'category': category,
        'priority': savingsGoals.length + 1,
      }).select().single();

      savingsGoals.add(inserted);
    } catch (e) {
      debugPrint('Failed to add savings goal: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> addDreamDate({
    required String title,
    String? description,
    required String location,
    String? season,
  }) async {
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();

    try {
      await _ensureAuth();
      final inserted = await _client.from('germany_dream_dates').insert({
        'couple_id': AppConfig.coupleId,
        'title': title,
        'location': location,
        'is_achieved': false,
      }).select().single();

      dreamDates.add(inserted);
    } catch (e) {
      debugPrint('Failed to add dream date: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> redeemCoupon(String couponId) async {
    final index = coupons.indexWhere((c) => c['id'] == couponId);
    if (index != -1) {
      coupons[index]['is_redeemed'] = true;
      notifyListeners();
    }

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
    final index = milestones.indexWhere((m) => m['id'] == milestoneId);
    if (index != -1) {
      milestones[index]['is_completed'] = isCompleted;
      notifyListeners();
    }

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
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();

    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? (isHari ? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c' : '83c2770e-d03d-4985-ba3a-1f7ca5c0b05d');

      // Archive only the active note from this author so partner's note is never overwritten
      await _client.from('sticky_notes').update({'is_active': false}).eq('couple_id', AppConfig.coupleId).eq('author_id', userId);

      final inserted = await _client.from('sticky_notes').insert({
        'couple_id': AppConfig.coupleId,
        'author_id': userId,
        'note_text': noteText,
        'color_hex': isHari ? '#FFE4E6' : '#FFF3B0',
        'is_active': true,
      }).select().single();

      stickyNotes.removeWhere((n) => n['author_id'] == userId);
      stickyNotes.insert(0, inserted);

      _realtimeChannel?.sendBroadcastMessage(
        event: 'note_updated',
        payload: {'sender': myName, 'timestamp': DateTime.now().toIso8601String()},
      );
    } catch (e) {
      debugPrint('Failed to post note: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> addLoveCard(String reasonText) async {
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();

    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? (isHari ? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c' : '83c2770e-d03d-4985-ba3a-1f7ca5c0b05d');
      final newCardNumber = loveCards.length + 1;

      final inserted = await _client.from('love_deck_cards').insert({
        'couple_id': AppConfig.coupleId,
        'author_id': userId,
        'card_number': newCardNumber,
        'reason_text': reasonText,
      }).select().single();

      loveCards.add(inserted);
    } catch (e) {
      debugPrint('Failed to add love card: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }



  Future<void> updateLoveCard(String cardId, String reasonText) async {
    final index = loveCards.indexWhere((c) => c['id'] == cardId);
    if (index != -1) {
      loveCards[index]['reason_text'] = reasonText;
      notifyListeners();
    }
    try {
      await _ensureAuth();
      await _client.from('love_deck_cards').update({'reason_text': reasonText}).eq('id', cardId);
    } catch (e) {
      debugPrint('Failed to update love card: $e');
    }
  }

  Future<void> deleteLoveCard(String cardId) async {
    loveCards.removeWhere((c) => c['id'] == cardId);
    notifyListeners();
    try {
      await _ensureAuth();
      await _client.from('love_deck_cards').delete().eq('id', cardId);
    } catch (e) {
      debugPrint('Failed to delete love card: $e');
    }
  }

  Future<void> addCourageVaultEntry({
    required String title,
    required String category,
    required String content,
    String? audioPath,
    DateTime? unlockAt,
  }) async {
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();
    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? (isHari ? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c' : '83c2770e-d03d-4985-ba3a-1f7ca5c0b05d');
      final inserted = await _client.from('courage_vault_entries').insert({
        'couple_id': AppConfig.coupleId,
        'author_id': userId,
        'category': category,
        'title': title,
        'content_encrypted': content,
        'audio_storage_path': audioPath,
        'unlock_at': unlockAt?.toIso8601String(),
      }).select().single();
      courageVaultEntries.add(inserted);
    } catch (e) {
      debugPrint('Failed to add vault entry: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> deleteCourageVaultEntry(String entryId) async {
    courageVaultEntries.removeWhere((e) => e['id'] == entryId);
    notifyListeners();
    try {
      await _ensureAuth();
      await _client.from('courage_vault_entries').delete().eq('id', entryId);
    } catch (e) {
      debugPrint('Failed to delete vault entry: $e');
    }
  }

  Future<void> addGermanyMilestone({
    required String title,
    required String description,
    required String category,
    required String targetDate,
  }) async {
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();
    try {
      await _ensureAuth();
      final inserted = await _client.from('germany_milestones').insert({
        'couple_id': AppConfig.coupleId,
        'title': title,
        'description': description,
        'category': category,
        'target_date': targetDate,
        'order_index': milestones.length + 1,
        'is_completed': false,
      }).select().single();
      milestones.add(inserted);
    } catch (e) {
      debugPrint('Failed to add milestone: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> deleteGermanyMilestone(String milestoneId) async {
    milestones.removeWhere((m) => m['id'] == milestoneId);
    notifyListeners();
    try {
      await _ensureAuth();
      await _client.from('germany_milestones').delete().eq('id', milestoneId);
    } catch (e) {
      debugPrint('Failed to delete milestone: $e');
    }
  }

  Future<void> deleteDreamDate(String dateId) async {
    dreamDates.removeWhere((d) => d['id'] == dateId);
    notifyListeners();
    try {
      await _ensureAuth();
      await _client.from('germany_dream_dates').delete().eq('id', dateId);
    } catch (e) {
      debugPrint('Failed to delete dream date: $e');
    }
  }

  Future<void> addComfortCoupon({
    required String title,
    required String description,
    required String rewardIcon,
  }) async {
    if (isSubmitting) return;
    isSubmitting = true;
    notifyListeners();
    try {
      await _ensureAuth();
      final inserted = await _client.from('comfort_coupons').insert({
        'couple_id': AppConfig.coupleId,
        'title': title,
        'description': description,
        'icon_name': rewardIcon,
        'is_redeemed': false,
      }).select().single();
      coupons.add(inserted);
    } catch (e) {
      debugPrint('Failed to add coupon: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> deleteComfortCoupon(String couponId) async {
    coupons.removeWhere((c) => c['id'] == couponId);
    notifyListeners();
    try {
      await _ensureAuth();
      await _client.from('comfort_coupons').delete().eq('id', couponId);
    } catch (e) {
      debugPrint('Failed to delete coupon: $e');
    }
  }

  Future<void> deleteSavingsGoal(String goalId) async {
    savingsGoals.removeWhere((g) => g['id'] == goalId);
    notifyListeners();
    try {
      await _ensureAuth();
      await _client.from('savings_goals').delete().eq('id', goalId);
    } catch (e) {
      debugPrint('Failed to delete goal: $e');
    }
  }

  Future<void> deleteSavingLog(String logId) async {
    final index = savingsLogs.indexWhere((l) => l['id'] == logId);
    if (index != -1) {
      final amount = (savingsLogs[index]['amount'] as num?)?.toDouble() ?? 0.0;
      currentSavedInr -= amount;
      savingsLogs.removeAt(index);
      notifyListeners();
    }
    try {
      await _ensureAuth();
      await _client.from('savings_logs').delete().eq('id', logId);
    } catch (e) {
      debugPrint('Failed to delete savings log: $e');
    }
  }

  Future<void> deleteStickyNote(String noteId) async {
    stickyNotes.removeWhere((n) => n['id'] == noteId);
    notifyListeners();
    try {
      await _ensureAuth();
      await _client.from('sticky_notes').delete().eq('id', noteId);
      _realtimeChannel?.sendBroadcastMessage(
        event: 'note_updated',
        payload: {'sender': myName},
      );
    } catch (e) {
      debugPrint('Failed to delete note: $e');
    }
  }

  Future<void> waterGardenAndSendFlower() async {
    try {
      await _ensureAuth();
      final userId = _client.auth.currentUser?.id ?? (isHari ? '29ed297a-c70a-41ae-b3a8-ff25c1ec562c' : '83c2770e-d03d-4985-ba3a-1f7ca5c0b05d');

      flowersBloomed += 1;
      await _client.from('couples').update({'flowers_bloomed': flowersBloomed}).eq('id', AppConfig.coupleId);

      await _client.from('balcony_flowers').insert({
        'couple_id': AppConfig.coupleId,
        'sender_id': userId,
        'flower_type': 'rose',
        'message': 'Watered with love by $myName',
      });

      _realtimeChannel?.sendBroadcastMessage(
        event: 'flower_watered',
        payload: {'sender': myName},
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to water flower: $e');
      rethrow;
    }
  }

  void triggerHeartPulse() {
    isHeartBeating = true;
    notifyListeners();
    VibrationHelper.vibrateHeartbeat();

    _realtimeChannel?.sendBroadcastMessage(
      event: 'heartbeat_pulse',
      payload: {'sender': myName, 'timestamp': DateTime.now().toIso8601String()},
    );

    Future.delayed(const Duration(seconds: 4), () {
      isHeartBeating = false;
      notifyListeners();
    });
  }

  /// Updates Sperrkonto savings target (e.g. 1350000)
  Future<void> updateTargetSavingsInr(double newTarget) async {
    try {
      targetSavingsInr = newTarget;
      notifyListeners();

      await _ensureAuth();
      await _client.from('couples').update({
        'target_savings_inr': newTarget,
      }).eq('id', AppConfig.coupleId);

      _realtimeChannel?.sendBroadcastMessage(
        event: 'savings_updated',
        payload: {'sender': myName, 'new_target': newTarget},
      );
    } catch (e) {
      debugPrint('Failed to update target savings: $e');
    }
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
