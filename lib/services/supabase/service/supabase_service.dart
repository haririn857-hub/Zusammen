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
      debugPrint('Supabase initialized successfully for ${AppConfig.appName}');
    } catch (e) {
      debugPrint('Supabase initialization error: $e');
      rethrow;
    }
  }
}
