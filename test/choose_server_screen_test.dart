import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vpn/features/servers/presentation/screens/choose_server_screen.dart';

import 'helpers/design_harness.dart';

void main() {
  setUpAll(loadInter);

  testWidgets('Choose server matches Figma 7:1427 and filters favourites', (
    tester,
  ) async {
    useFigmaFrame(tester);
    await tester.pumpWidget(designApp(home: const ChooseServerScreen()));
    await settleEntry(tester);
    expect(tester.takeException(), isNull);

    // Figma frame coordinates: header 7:1437, tab 7:1443, rows under 7:1450
    // (list at y 166, rows 62 tall).
    expectRect(
      tester,
      find.text('Choose Server'),
      const Rect.fromLTWH(126, 60.5, 138, 23),
    );
    expectRect(
      tester,
      find.text('All'),
      const Rect.fromLTWH(55.625, 123.5, 14, 13),
    );
    expectRect(
      tester,
      find.text('United States').first,
      const Rect.fromLTWH(74, 180.5, 87, 16),
    );
    expectRect(
      tester,
      find.text('New York'),
      const Rect.fromLTWH(74, 200.5, 50, 13),
    );
    expectRect(
      tester,
      find.text('28 ms'),
      const Rect.fromLTWH(291, 191, 38, 12),
    );
    expectRect(
      tester,
      find.text('Mumbai'),
      const Rect.fromLTWH(74, 758.5, 42, 13),
    );

    // English names via country_code_picker localisations (base names are native).
    for (final name in [
      'United Kingdom',
      'Germany',
      'Netherlands',
      'Japan',
      'India',
    ]) {
      expect(find.text(name), findsOneWidget, reason: name);
    }

    // Favourite Los Angeles, then filter: New York (default) + Los Angeles.
    await tester.tap(find.byKey(const ValueKey('server_star_us-la')));
    await tester.tap(find.byKey(const ValueKey('servers_tab_1')));
    await settleEntry(tester);
    expect(find.text('New York'), findsOneWidget);
    expect(find.text('Los Angeles'), findsOneWidget);
    expect(find.text('London'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
