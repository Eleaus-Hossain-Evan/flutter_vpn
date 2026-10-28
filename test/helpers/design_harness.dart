import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Loads the bundled Inter weights so text measures like the device.
Future<void> loadInter() async {
  final loader = FontLoader('Inter');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    loader.addFont(rootBundle.load('assets/fonts/Inter-$w.ttf'));
  }
  await loader.load();
}

/// Sizes the test view like the Figma frame: 390 × 844 with a 44 px status
/// bar and a 30 px home-indicator area, so widget rects equal frame coords.
void useFigmaFrame(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1
    ..padding = const FakeViewPadding(top: 44, bottom: 30);
  addTearDown(tester.view.reset);
  // rootBundle caches asset futures; a future from an earlier test's
  // fake-async zone never completes in the next one, which would leave
  // CountryLocalizations (and with it the whole app) unloaded.
  addTearDown(rootBundle.clear);
}

Widget designApp({Widget? home, RouterConfig<Object>? router}) {
  return ProviderScope(
    child: ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, _) => router != null
          ? MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: const [CountryLocalizations.delegate],
            )
          : MaterialApp(
              home: home,
              localizationsDelegates: const [CountryLocalizations.delegate],
            ),
    ),
  );
}

/// Asserts [finder]'s rect equals a Figma frame rect within 1.5 px.
void expectRect(WidgetTester tester, Finder finder, Rect figma) {
  final rect = tester.getRect(finder);
  expect(rect.left, closeTo(figma.left, 1.5), reason: '$finder left $rect');
  expect(rect.top, closeTo(figma.top, 1.5), reason: '$finder top $rect');
  expect(rect.width, closeTo(figma.width, 1.5), reason: '$finder width $rect');
  expect(
    rect.height,
    closeTo(figma.height, 1.5),
    reason: '$finder height $rect',
  );
}

/// Runs flutter_animate entry animations to the end. It starts on a deferred
/// timer and its first ticker frame only records the start time.
Future<void> settleEntry(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  await tester.pump(const Duration(seconds: 2));
}

/// Unmounts the app and flushes animation and SVG-loading timers.
Future<void> tearDownApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}
