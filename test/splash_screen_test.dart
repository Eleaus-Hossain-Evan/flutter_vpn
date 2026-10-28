import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vpn/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_vpn/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

import 'helpers/design_harness.dart';

void main() {
  setUpAll(loadInter);

  testWidgets('splash matches Figma geometry, then opens Home', (tester) async {
    useFigmaFrame(tester);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
        GoRoute(
          path: HomeScreen.route,
          builder: (_, _) => const Scaffold(body: Text('home')),
        ),
      ],
    );
    await tester.pumpWidget(designApp(router: router));
    await tester.pump(const Duration(milliseconds: 3900));
    expect(tester.takeException(), isNull);

    final brand = find.byType(RichText).first;
    final tagline = find.text('Fast. Secure. Unlimited.');
    final loading = find.text('Loading...');

    // Figma frame coordinates: 7:1234, 7:1235, 7:1239.
    expect(tester.getSize(brand).width, closeTo(183, 1.5));
    expect(tester.getSize(brand).height, closeTo(38, 1));
    expect(tester.getTopLeft(brand).dy, closeTo(423.74, 1));
    expect(tester.getSize(tagline).width, closeTo(147, 1));
    expect(tester.getTopLeft(tagline).dy, closeTo(471.74, 1));
    expect(tester.getTopLeft(loading).dy, closeTo(710, 1));

    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
  });
}
