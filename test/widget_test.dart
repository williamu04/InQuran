import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inquran/screens/splash.dart';

void main() {
  testWidgets('SplashScreen renders the app title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/splash',
          routes: [
            GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
            GoRoute(path: '/', builder: (_, _) => const SizedBox()),
          ],
        ),
      ),
    );

    await tester.pump();

    expect(find.text('InQuran'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
