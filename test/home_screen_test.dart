import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vpn/features/home/presentation/screens/home_screen.dart';

import 'helpers/design_harness.dart';

void expectRect(WidgetTester tester, Finder finder, Rect figma) {
  final rect = tester.getRect(finder);
  // ignore: avoid_print
  print('$finder → $rect  (figma $figma)');
  expect(rect.left, closeTo(figma.left, 1.5), reason: '$finder left');
  expect(rect.top, closeTo(figma.top, 1.5), reason: '$finder top');
  expect(rect.width, closeTo(figma.width, 1.5), reason: '$finder width');
  expect(rect.height, closeTo(figma.height, 1.5), reason: '$finder height');
}

void main() {
  setUpAll(loadInter);

  testWidgets('Home matches both Figma frames', (tester) async {
    useFigmaFrame(tester);
    await tester.pumpWidget(designApp(home: const HomeScreen()));
    // flutter_animate starts on a deferred timer and its first ticker frame
    // only records the start time: kick off, take that first tick, then run
    // the entry fades to completion.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);

    // 7:1243 — not connected.
    expectRect(
      tester,
      find.text('Not Connected'),
      const Rect.fromLTWH(110, 352, 170, 28),
    );
    expectRect(
      tester,
      find.text('Tap to connect'),
      const Rect.fromLTWH(152, 388, 86, 15),
    );
    expectRect(
      tester,
      find.text('Smart Location'),
      const Rect.fromLTWH(83, 454, 112, 18),
    );
    expectRect(
      tester,
      find.text('Connected time'),
      const Rect.fromLTWH(241, 612, 83, 13),
    );
    expectRect(
      tester,
      find.text('PRO'),
      const Rect.fromLTWH(335, 65.5, 23, 13),
    );
    expectRect(
      tester,
      find.text('Servers'),
      const Rect.fromLTWH(127.17, 781, 41, 13),
    );
    expect(find.text('Disconnect'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('home_power_button')));
    await tester.pump(const Duration(milliseconds: 50));

    // Entry fades are one-shot: connecting must not replay them. 'Download'
    // sits outside every state switcher, so its only FadeTransition is the
    // metrics card's entry fade.
    final entryFade = tester.widget<FadeTransition>(
      find
          .ancestor(
            of: find.text('Download'),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(entryFade.opacity.value, 1);

    await tester.pump(const Duration(milliseconds: 1200));

    // 7:1324 — connected.
    expectRect(
      tester,
      find.text('Connected'),
      const Rect.fromLTWH(132.5, 352, 125, 28),
    );
    expectRect(
      tester,
      find.text('Your connection is secure'),
      const Rect.fromLTWH(131.5, 388, 147, 15),
    );
    expectRect(
      tester,
      find.text('United States'),
      const Rect.fromLTWH(84, 454, 100, 18),
    );
    expectRect(
      tester,
      find.text('32.8 Mbps'),
      const Rect.fromLTWH(78, 540, 73, 17),
    );
    expectRect(
      tester,
      find.text('Disconnect'),
      const Rect.fromLTWH(153.5, 684, 83, 18),
    );

    await tester.tap(find.byKey(const ValueKey('home_disconnect_button')));
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('Not Connected'), findsOneWidget);

    // Flush animation and SVG-loading timers before teardown.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
