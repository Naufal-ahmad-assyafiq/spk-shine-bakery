import 'package:flutter_test/flutter_test.dart';
import 'package:spk_shine_bakery/main.dart';

void main() {
  testWidgets('Dashboard renders successfully smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title 'SPK Shine Bakery' is shown on the dashboard.
    expect(find.text('SPK Shine Bakery'), findsOneWidget);
  });
}
