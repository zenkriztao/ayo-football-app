import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ayo_football_app/Main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AyoFootballApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('AYO Football'), findsOneWidget);
  });
}
