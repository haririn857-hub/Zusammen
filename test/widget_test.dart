import 'package:flutter_test/flutter_test.dart';
import 'package:zusammen/main.dart';

void main() {
  testWidgets('ZusammenApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZusammenApp());
    expect(find.text('Zusammen'), findsOneWidget);
  });
}
