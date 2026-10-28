import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vpn/features/splash/presentation/screens/splash_screen.dart';

Future<void> _loadInter() async {
  final loader = FontLoader('Inter');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    loader.addFont(rootBundle.load('assets/fonts/Inter-$w.ttf'));
  }
  await loader.load();
}

void main() {
  setUpAll(_loadInter);

  testWidgets('splash matches Figma geometry after its 4 s timeline', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => const MaterialApp(home: SplashScreen()),
      ),
    );
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);

    final brand = find.byType(RichText).first;
    final tagline = find.text('Fast. Secure. Unlimited.');
    final loading = find.text('Loading...');

    // Figma frame coordinates (status bar included): 7:1234, 7:1235, 7:1239.
    expect(tester.getSize(brand).width, closeTo(183, 1.5));
    expect(tester.getSize(brand).height, closeTo(38, 1));
    expect(tester.getTopLeft(brand).dy, closeTo(423.74, 1));
    expect(tester.getSize(tagline).width, closeTo(147, 1));
    expect(tester.getTopLeft(tagline).dy, closeTo(471.74, 1));
    expect(tester.getTopLeft(loading).dy, closeTo(710, 1));
  });
}
