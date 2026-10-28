import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

Widget designApp({Widget? home, RouterConfig<Object>? router}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, _) => router != null
        ? MaterialApp.router(routerConfig: router)
        : MaterialApp(home: home),
  );
}
