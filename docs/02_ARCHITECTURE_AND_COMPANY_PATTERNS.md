# 02. Architecture & Company Pattern Breakdown
## Mirroring the Exact `zeldin-flutter-hari` & `zeldin-supabase-hari` Structure

To ensure you write production-grade, familiar code that matches your company's architecture exactly, this app follows the identical structural conventions established in `zeldin-flutter-hari`.

---

## 1. Directory Structure Blueprint

```
lib/
â”œâ”€â”€ app/
â”‚   â”œâ”€â”€ app.dart                       # Root App Widget (MaterialApp.router, Theme setup)
â”‚   â”œâ”€â”€ router/
â”‚   â”‚   â”œâ”€â”€ app_router.dart            # GoRouter definition with Auth guards & Web paths
â”‚   â”‚   â””â”€â”€ routes.dart                # Route name constants
â”‚   â””â”€â”€ export.dart
â”œâ”€â”€ core/
â”‚   â”œâ”€â”€ config/
â”‚   â”‚   â”œâ”€â”€ app_config.dart            # Supabase URLs, keys, environment configs
â”‚   â”‚   â””â”€â”€ services.dart              # Global service locator shortcuts
â”‚   â”œâ”€â”€ constants/
â”‚   â”‚   â”œâ”€â”€ app_constants.dart
â”‚   â”‚   â””â”€â”€ asset_paths.dart
â”‚   â”œâ”€â”€ themes/
â”‚   â”‚   â”œâ”€â”€ app_theme.dart             # Dark/Light theme orchestration
â”‚   â”‚   â”œâ”€â”€ colors.dart                # Palette (Velvet Obsidian, Rose Quartz, Champagne Gold)
â”‚   â”‚   â”œâ”€â”€ typography.dart            # Outfit / Playfair Google Fonts
â”‚   â”‚   â””â”€â”€ spacing.dart               # Spacing constants (padding4, padding8, padding16...)
â”‚   â”œâ”€â”€ utils/
â”‚   â”‚   â”œâ”€â”€ logger.dart                # AppLogger wrapper
â”‚   â”‚   â”œâ”€â”€ error_handler.dart         # Safe error capture
â”‚   â”‚   â”œâ”€â”€ network_utils.dart         # Connectivity listener
â”‚   â”‚   â””â”€â”€ mixin/
â”‚   â”‚       â”œâ”€â”€ initializer.dart       # Completer-based safe async initialization
â”‚   â”‚       â”œâ”€â”€ reset.dart             # Cache reset on state changes
â”‚   â”‚       â””â”€â”€ wipe.dart              # Hard cleanup on logout
â”‚   â””â”€â”€ export.dart
â”œâ”€â”€ features/                         # Self-contained domain modules
â”‚   â”œâ”€â”€ auth/                          # Login / Couple linking PIN
â”‚   â”œâ”€â”€ savings/                       # Germany Sperrkonto & Savings Radar
â”‚   â”œâ”€â”€ roadmap/                       # 2-Year Germany Timeline & Language Milestone
â”‚   â”œâ”€â”€ courage_vault/                 # Encrypted Vows, Audio Notes, SMA Legal Guide
â”‚   â”œâ”€â”€ daily_capsule/                 # Daily Questions, Memory Scrapbook, Heartbeat Touch
â”‚   â”œâ”€â”€ settings/                      # Couple profile, notifications, lock screen
â”‚   â””â”€â”€ splash/                        # Animated romantic launch screen
â”œâ”€â”€ services/                         # Global singleton lifecycle services
â”‚   â”œâ”€â”€ app/
â”‚   â”‚   â””â”€â”€ service/app_service.dart   # Priority-based Service Registry (0..4)
â”‚   â”œâ”€â”€ database/                      # Drift SQLite local-first database
â”‚   â”‚   â”œâ”€â”€ core/app_database.dart
â”‚   â”‚   â””â”€â”€ tables/                    # Drift Table definitions
â”‚   â”œâ”€â”€ supabase/
â”‚   â”‚   â”œâ”€â”€ service/supabase_service.dart
â”‚   â”‚   â”œâ”€â”€ repositories/              # Layered repositories
â”‚   â”‚   â”‚   â”œâ”€â”€ couple_repo/
â”‚   â”‚   â”‚   â”œâ”€â”€ savings_repo/
â”‚   â”‚   â”‚   â”œâ”€â”€ roadmap_repo/
â”‚   â”‚   â”‚   â””â”€â”€ vault_repo/
â”‚   â”‚   â””â”€â”€ models/                    # Freezed/JSON data models
â”‚   â”œâ”€â”€ session/                       # SessionService (Current User & Partner ID)
â”‚   â””â”€â”€ router/                        # RouterService singleton
â”œâ”€â”€ shared/                           # Reusable UI widgets across all features
â”‚   â”œâ”€â”€ widgets/
â”‚   â”‚   â”œâ”€â”€ romantic_card.dart         # Glassmorphism container
â”‚   â”‚   â”œâ”€â”€ primary_button.dart
â”‚   â”‚   â”œâ”€â”€ heartbeat_indicator.dart
â”‚   â”‚   â””â”€â”€ currency_input_field.dart
â”‚   â””â”€â”€ export.dart
â””â”€â”€ main.dart
```

---

## 2. The Service Registry & Lifecycle (`AppService`)

As modeled in Zeldin's `AppService`, all services implement `with Initializer, Reset, Wipe`. Services are initialized strictly by prioritized order:

```dart
static final List<(int, Object Function())> _serviceRegistry = [
  // Priority 0: Essential infrastructure (runs before runApp)
  (0, RouterService.new),

  // Priority 1: Core persistence & backend
  (1, DatabaseService.new),    // Drift SQLite local database
  (1, SupabaseService.new),    // Supabase auth and PostgREST client

  // Priority 2: User identity & relationship session
  (2, SessionService.new),     // Manages Hari & Rintamol active pairing

  // Priority 3: Couple data engines
  (3, SavingsService.new),
  (3, RoadmapService.new),
  (3, VaultService.new),
  (3, DailyCapsuleService.new),

  // Priority 4: Device features (lazy loaded)
  (4, NotificationService.new), // Heartbeat vibrations & reminders
];
```

### The `Initializer` Mixin Pattern
Guarantees thread-safe, single-execution asynchronous startup with complete error handling:
```dart
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
      _initCompleter!.complete();
    } catch (e) {
      _initCompleter!.completeError(e);
      _initCompleter = null;
      rethrow;
    }
  }

  bool get isInitialized => _initCompleter?.isCompleted ?? false;
}
```

---

## 3. The Local-First Layered Repository Pattern

This is the crowning jewel of Zeldin's architecture. **The app never stutters or shows a blank loading spinner when you open it.**

### Data Flow
1. **Local DAO (`local/`)**: Reads cached data instantly from Drift (SQLite on device or IndexedDB on Web).
2. **Remote API (`remote/`)**: Talks directly to Supabase via PostgREST / Realtime.
3. **Orchestrator Repository**:
   - `getAll()` â†’ Returns local data **immediately**.
   - Triggers `unawaited(sync())` in the background.
   - When Supabase returns fresh data, local Drift tables are updated, and UI is notified via `onSynced` callback or Stream.

```dart
Future<List<SavingsItem>> getSavings({Function(List<SavingsItem>)? onSynced}) async {
  final localData = await _dao.getAllSavings();
  if (localData.isNotEmpty) {
    // Return immediately to screen: 0ms delay!
    unawaited(syncWithRemote().then((_) async {
      final freshData = await _dao.getAllSavings();
      if (onSynced != null) onSynced(freshData);
    }));
    return localData;
  }
  // If first install and no local data, wait for remote
  await syncWithRemote();
  return await _dao.getAllSavings();
}
```

---

## 4. State Management (Zero-BLoC / Pure Notifier Rule)

Per the company's guidelines:
- **No BLoC / No Cubit**.
- Use **`ChangeNotifier`** or **`ValueNotifier`** with `with Initializer`.
- Feature controllers hold state and call `notifyListeners()`.
- Screens consume with `ListenableBuilder` or `AnimatedBuilder`.

---

## 5. Non-Negotiable Styling & Platform Rules

1. **RTL Directional Widgets**:
   - Always use `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`, `start`, and `end`.
2. **Platform Parity (Android + iOS + Web)**:
   - Web handles mouse hover and responsive desktop max-width constraints (`maxWidth: 600` on web for mobile preview or responsive dashboard).
   - iOS respects safe areas (`CupertinoIcons` / Apple haptic feedback).
   - Android leverages device back gestures and system vibrator.
