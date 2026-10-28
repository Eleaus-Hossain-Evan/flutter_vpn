import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vpn/core/router/app_router.dart';
import 'package:flutter_vpn/features/servers/presentation/screens/server_details_screen.dart';

import 'helpers/design_harness.dart';

void main() {
  setUpAll(loadInter);

  testWidgets('Server details matches Figma 7:1631 and connects', (
    tester,
  ) async {
    useFigmaFrame(tester);
    await tester.pumpWidget(
      designApp(
        router: createAppRouter(
          initialLocation: ServerDetailsScreen.location('us-ny'),
        ),
      ),
    );
    await settleEntry(tester);
    expect(tester.takeException(), isNull);

    // Figma frame coordinates: header 7:1638, overview 7:1644 at y 100.
    expectRect(
      tester,
      find.text('Server Details'),
      const Rect.fromLTWH(129.5, 60.5, 131, 23),
    );
    expectRect(
      tester,
      find.text('United States'),
      const Rect.fromLTWH(128.5, 198, 133, 24),
    );
    expectRect(
      tester,
      find.text('New York'),
      const Rect.fromLTWH(165.5, 227, 59, 16),
    );
    expectRect(
      tester,
      find.text('Optimal'),
      const Rect.fromLTWH(183.5, 260, 42, 13),
    );
    expectRect(
      tester,
      find.text('28 ms'),
      const Rect.fromLTWH(53.83, 373, 45, 18),
    );
    expectRect(
      tester,
      find.text('32.8 Mbps'),
      const Rect.fromLTWH(156, 373, 78, 18),
    );
    expectRect(
      tester,
      find.text('Connect'),
      const Rect.fromLTWH(178, 452, 62, 18),
    );
    expectRect(
      tester,
      find.text('Other Servers in United States'),
      const Rect.fromLTWH(20, 508, 223, 18),
    );
    expectRect(
      tester,
      find.text('Los Angeles'),
      const Rect.fromLTWH(74, 560.5, 179, 16),
    );
    expectRect(
      tester,
      find.text('48 ms'),
      const Rect.fromLTWH(291, 562.5, 37, 12),
    );
    expectRect(
      tester,
      find.text('Miami'),
      const Rect.fromLTWH(74, 731.5, 179, 16),
    );

    // Connect selects the server and lands on Home, connected.
    await tester.tap(find.byKey(const ValueKey('details_connect')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Connected'), findsOneWidget);
    expect(find.text('New York'), findsOneWidget);

    await tearDownApp(tester);
  });

  testWidgets('Another city opens its own details', (tester) async {
    useFigmaFrame(tester);
    await tester.pumpWidget(
      designApp(
        router: createAppRouter(
          initialLocation: ServerDetailsScreen.location('us-ny'),
        ),
      ),
    );
    await settleEntry(tester);

    await tester.tap(find.byKey(const ValueKey('details_other_us-mia')));
    await settleEntry(tester);
    expect(find.text('Miami'), findsOneWidget);
    expect(find.text('62 ms'), findsOneWidget);
    expect(find.text('New York'), findsOneWidget); // now in the other list

    await tearDownApp(tester);
  });
}
