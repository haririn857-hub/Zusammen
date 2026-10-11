# 04. Flutter Project Skeleton Guide
## Concrete Implementation Code Matching `zeldin-flutter-hari`

This guide provides the foundational code implementations structured precisely after your company's repository.

---

## 1. `pubspec.yaml` (Multiplatform: Android, iOS, Web)

```yaml
name: germany_dream_app
description: "Hari & Rintamol's private life planner and Germany countdown."
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.4.0 <4.0.0"
  flutter: ">=3.22.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_web_plugins:
    sdk: flutter

  # Backend & Realtime
  supabase_flutter: ^2.12.0

  # Local-First Database (Drift SQLite)
  drift: ^2.29.0
  drift_flutter: ^0.3.0

  # Routing
  go_router: ^17.0.0

  # UI, Fonts & Polish
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.2
  vibration: ^3.1.5
  intl: any
  uuid: ^4.5.1
  cached_network_image: ^3.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  drift_dev: ^2.29.0
  build_runner: ^2.4.15
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

---

## 2. Core Mixins (`lib/core/utils/mixin/initializer.dart`)

```dart
import 'dart:async';
import 'package:flutter/foundation.dart';

mixin Initializer {
  Completer<void>? _initCompleter;

  Future<void> onInitialize();

  Future<void> initialize() async {
    if (_initCompleter != null) {
      if (_initCompleter!.isCompleted) return;
      return _initCompleter!.future;
    }
    _initCompleter = Completer<void>();
    try {
      await onInitialize();
      debugPrint('$runtimeType: Initialized successfully');
      _initCompleter!.complete();
    } catch (e, st) {
      debugPrint('$runtimeType: Initialization failed: $e\n$st');
      _initCompleter!.completeError(e, st);
      _initCompleter = null;
      rethrow;
    }
  }

  bool get isInitialized => _initCompleter?.isCompleted ?? false;
}
```

---

## 3. Romantic Theme System (`lib/core/themes/colors.dart`)

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Deep Night Obsidian Base (Sleek dark mode)
  static const Color background = Color(0xFF0F0E17);
  static const Color surface = Color(0xFF1E1D2A);
  static const Color surfaceGlass = Color(0x22FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Romantic Accents
  static const Color roseQuartz = Color(0xFFE56B6F);
  static const Color champagneGold = Color(0xFFE0A96D);
  static const Color alpinePine = Color(0xFF588157);
  static const Color textPrimary = Color(0xFFFFFFFE);
  static const Color textSecondary = Color(0xFFA7A9BE);

  // Gradient for Germany Flight Progress
  static const LinearGradient flightGradient = LinearGradient(
    colors: [roseQuartz, champagneGold],
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
  );
}
```

---

## 4. AppService Priority Registry (`lib/services/app/service/app_service.dart`)

```dart
import 'dart:async';
import '../../../core/utils/mixin/initializer.dart';
import '../../supabase/service/supabase_service.dart';
import '../../database/service/database_service.dart';
import '../../session/service/session_service.dart';
import '../../router/service/router_service.dart';

class AppService with Initializer {
  static AppService? _instance;
  factory AppService() => _instance ??= AppService._internal();
  AppService._internal();

  static final List<(int, Object Function())> _serviceRegistry = [
    // Priority 0: Essential router
    (0, RouterService.new),

    // Priority 1: Core infrastructure
    (1, DatabaseService.new),
    (1, SupabaseService.new),

    // Priority 2: Couple authentication & session
    (2, SessionService.new),
  ];

  @override
  Future<void> onInitialize() async {
    // Run Priority 1 services in parallel
    await Future.wait([
      SupabaseService().initialize(),
      DatabaseService().initialize(),
    ]);

    // Priority 2
    await SessionService().initialize();
  }
}
```

---

## 5. Supabase Service (`lib/services/supabase/service/supabase_service.dart`)

```dart
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/mixin/initializer.dart';

class SupabaseService with Initializer {
  static SupabaseService? _instance;
  factory SupabaseService() => _instance ??= SupabaseService._internal();
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;
  GoTrueClient get auth => client.auth;

  @override
  Future<void> onInitialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }
}
```

---

## 6. Layered Repository Pattern Example: Savings Radar

### `savings_repository.dart` (Orchestrator)
```dart
import 'dart:async' show unawaited;
import 'models/savings_log_model.dart';
import 'local/savings_dao.dart';
import 'remote/savings_remote.dart';

class SavingsRepository {
  final SavingsDao _dao;
  final SavingsRemote _remote;

  SavingsRepository()
      : _dao = SavingsDao(),
        _remote = SavingsRemote();

  /// Local-First fetch: returns instantly from Drift, then syncs with Supabase in background
  Future<List<SavingsLogModel>> getLogs({Function(List<SavingsLogModel>)? onSynced}) async {
    final localLogs = await _dao.getAll();
    if (localLogs.isNotEmpty) {
      unawaited(_sync().then((_) async {
        final fresh = await _dao.getAll();
        if (onSynced != null) onSynced(fresh);
      }));
      return localLogs;
    }

    // No local data yet: wait for remote
    await _sync();
    return await _dao.getAll();
  }

  Future<void> addSaving(SavingsLogModel item) async {
    // Save to remote first
    final remoteItem = await _remote.create(item);
    // Upsert into local Drift SQLite
    await _dao.insert(remoteItem);
  }

  Future<void> _sync() async {
    try {
      final remoteLogs = await _remote.fetchAll();
      await _dao.replaceAll(remoteLogs);
    } catch (e) {
      // Offline fallback: keep local data uninterrupted
    }
  }
}
```

---

## 7. Romantic Glassmorphic Widget (`lib/shared/widgets/romantic_card.dart`)

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/themes/colors.dart';

class RomanticCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const RomanticCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(20.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: AppColors.glassBorder, width: 1.2),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
```
