import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/pages/sanctuary_auth_page.dart';
import 'features/dashboard/pages/dashboard_page.dart';
import 'services/supabase/service/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService().initialize();
  runApp(const ZusammenApp());
}

class ZusammenApp extends StatelessWidget {
  const ZusammenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = SupabaseService().isAuthenticated;

    return MaterialApp(
      title: 'Zusammen — Hari & Rintamol',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.romanticDarkTheme,
      home: isAuthenticated ? const DashboardPage() : const SanctuaryAuthPage(),
    );
  }
}

