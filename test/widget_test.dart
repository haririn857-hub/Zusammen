import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zusammen/features/auth/pages/sanctuary_auth_page.dart';

void main() {
  testWidgets('SanctuaryAuthPage smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SanctuaryAuthPage(),
      ),
    );
    expect(find.text('Zusammen'), findsOneWidget);
    expect(find.text('Hari'), findsOneWidget);
    expect(find.text('Rintamol'), findsOneWidget);
  });
}
