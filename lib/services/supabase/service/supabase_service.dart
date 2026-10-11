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

  bool get isAuthenticated {
    final session = client.auth.currentSession;
    return session != null && !session.isExpired;
  }

  bool get isCurrentHari => client.auth.currentUser?.email == 'hari@zusammen.love';
  bool get isCurrentRinta => client.auth.currentUser?.email == 'rinta@zusammen.love';
  String? get currentEmail => client.auth.currentUser?.email;

  @override
  Future<void> onInitialize() async {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        publishableKey: AppConfig.supabaseAnonKey,
      );

      // Session is automatically persisted by Supabase client across app reloads.
      if (isAuthenticated) {
        debugPrint('Supabase initialized with active session for: ${client.auth.currentUser?.email}');
      } else {
        debugPrint('Supabase initialized. No active session (Sanctuary locked).');
      }
      debugPrint('Supabase initialized successfully for ${AppConfig.appName}');
    } catch (e) {
      debugPrint('Supabase initialization error: $e');
      rethrow;
    }
  }

  /// Ensures an active valid session exists for Hari or Rinta
  Future<void> ensureAuthenticated() async {
    try {
      final currentEmail = client.auth.currentUser?.email;
      final session = client.auth.currentSession;
      final isSessionValid = session != null && !session.isExpired;

      if (!isSessionValid || (currentEmail != 'hari@zusammen.love' && currentEmail != 'rinta@zusammen.love')) {
        debugPrint('Authenticating fallback session as Hari...');
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

  /// Sign in explicitly as Hari or Rinta
  Future<AuthResponse> signInPartner({required bool isHari, required String password}) async {
    final email = isHari ? 'hari@zusammen.love' : 'rinta@zusammen.love';
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out to lock the sanctuary
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      debugPrint('Sign out warning: $e');
    }
  }
}
