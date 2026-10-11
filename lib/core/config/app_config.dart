class AppConfig {
  static const String appName = 'Zusammen';
  static const String tagline = 'Zwei Herzen, Ein Weg';
  static const String partnerBoy = 'Harikrishnan';
  static const String partnerGirl = 'Rinta Maria';
  static const String partnerGirlPetName = 'Rintamol';
  static const String partnerBoyPetName = 'Hari';

  // Couple ID
  static const String coupleId = '11111111-1111-1111-1111-111111111111';

  // Germany Relocation Target
  static final DateTime targetGermanyDate = DateTime(2028, 10, 1);
  static const double targetSperrkontoEur = 11904.0;
  static const double targetSavingsInr = 1350000.0;

  // Supabase Credentials (Safe for Web Client - configurable via --dart-define)
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://cjlllzklugpsvfbeewlv.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_whLYeS9aDRqBrZxXrzsZBg_gpT7vtNq',
  );
}
