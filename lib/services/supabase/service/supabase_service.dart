import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/mixin/initializer.dart';

class SupabaseService with Initializer {
  static SupabaseService? _instance;
  factory SupabaseService() => _instance ??= SupabaseService._internal();
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  @override
  Future<void> onInitialize() async {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        publishableKey: AppConfig.supabaseAnonKey,
      );

      // Guarantee an active authenticated session for Hari or Rinta
      await ensureAuthenticated();
      debugPrint('Supabase initialized successfully for ${AppConfig.appName}');
    } catch (e) {
      debugPrint('Supabase initialization error: $e');
      rethrow;
    }
  }

  /// Ensures an active valid session exists for Hari or Rinta so RLS never rejects calls
  Future<void> ensureAuthenticated() async {
    try {
      final currentEmail = client.auth.currentUser?.email;
      final session = client.auth.currentSession;
      final isSessionValid = session != null && !session.isExpired;

      if (!isSessionValid || (currentEmail != 'hari@zusammen.love' && currentEmail != 'rinta@zusammen.love')) {
        debugPrint('Refreshing/Authenticating session as Hari...');
        await client.auth.signInWithPassword(
          email: 'hari@zusammen.love',
          password: 'HariAndRintamol2028!',
        );
        debugPrint('Authenticated as Hari successfully');
      }
    } catch (authError) {
      debugPrint('Auth validation warning: $authError');
    }
  }

  /// Switch active identity between Hari and Rinta
  Future<void> switchPartner({required bool isHari}) async {
    final email = isHari ? 'hari@zusammen.love' : 'rinta@zusammen.love';
    await client.auth.signInWithPassword(
      email: email,
      password: 'HariAndRintamol2028!',
    );
  }
}
