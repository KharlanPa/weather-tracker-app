import 'package:flutter_test/flutter_test.dart';

import 'package:weather_tracker/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Verify that the app loads
    expect(find.text('WeatherTracker'), findsOneWidget);
  });
}
