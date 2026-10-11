import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'features/dashboard/pages/dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZusammenApp());
}

class ZusammenApp extends StatelessWidget {
  const ZusammenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zusammen — Hari & Rintamol',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.romanticDarkTheme,
      home: const DashboardPage(),
    );
  }
}
