import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vpn/core/router/app_router.dart';
import 'package:flutter_vpn/features/features/presentation/screens/features_screen.dart';
import 'package:flutter_vpn/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_vpn/features/profile/presentation/screens/profile_screen.dart';

import 'helpers/design_harness.dart';

Finder inDrawer(String text) =>
    find.descendant(of: find.byType(Drawer), matching: find.text(text));

void main() {
  setUpAll(loadInter);

  testWidgets('Features matches Figma 7:1817 and toggles', (tester) async {
    useFigmaFrame(tester);
    await tester.pumpWidget(
      designApp(router: createAppRouter(initialLocation: FeaturesScreen.route)),
    );
    await settleEntry(tester);
    expect(tester.takeException(), isNull);

    // Cards start at y 118 (7:1828 padding 18); rows 179 tall, 16 apart.
    expectRect(
      tester,
      find.text('Features').first,
      const Rect.fromLTWH(154, 60.5, 82, 23),
    );
    expectRect(
      tester,
      find.text('Kill Switch'),
      const Rect.fromLTWH(35, 183, 138, 17),
    );
    expectRect(
      tester,
      find.text('Block internet if VPN disconnects'),
      const Rect.fromLTWH(35, 206, 138, 34),
    );
    expectRect(
      tester,
      find.text('Split Tunneling'),
      const Rect.fromLTWH(217, 183, 138, 17),
    );
    expectRect(
      tester,
      find.text('DNS Leak Protection'),
      const Rect.fromLTWH(217, 378, 138, 15),
    );
    expectRect(
      tester,
      find.text('Auto Connect'),
      const Rect.fromLTWH(35, 573, 138, 17),
    );
    expectRect(
      tester,
      find.text('Auto (Recommended)'),
      const Rect.fromLTWH(217, 632.5, 116, 11),
    );
    final autoSwitch = find.byKey(
      const ValueKey('feature_auto_connect_switch'),
    );
    final track = find.descendant(
      of: autoSwitch,
      matching: find.byType(AnimatedContainer),
    );
    expectRect(tester, track, const Rect.fromLTWH(128, 625, 45, 26));

    // Off → on: thumb slides to the right edge.
    await tester.tap(track);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final thumb = tester.getRect(
      find.descendant(of: autoSwitch, matching: find.byType(Container)).last,
    );
    expect(thumb.left, closeTo(150, 1.5));

    await tearDownApp(tester);
  });

  testWidgets('Profile matches Figma 7:1901', (tester) async {
    useFigmaFrame(tester);
    await tester.pumpWidget(
      designApp(router: createAppRouter(initialLocation: ProfileScreen.route)),
    );
    await settleEntry(tester);
    expect(tester.takeException(), isNull);

    expectRect(
      tester,
      find.text('Profile').first,
      const Rect.fromLTWH(164.5, 60.5, 61, 23),
    );
    expectRect(
      tester,
      find.text('RedbullVPN Pro'),
      const Rect.fromLTWH(88, 140.5, 124, 19),
    );
    expectRect(
      tester,
      find.text('Unlock all servers and premium features'),
      const Rect.fromLTWH(88, 166.5, 235, 15),
    );
    expectRect(
      tester,
      find.text('Account'),
      const Rect.fromLTWH(71, 247, 253, 18),
    );
    expectRect(
      tester,
      find.text('About'),
      const Rect.fromLTWH(71, 517, 253, 18),
    );
    expectRect(
      tester,
      find.text('Log Out'),
      const Rect.fromLTWH(166, 594, 58, 18),
    );
    // Active tab: Profile, bold primary label in the nav.
    expectRect(
      tester,
      find.text('Profile').last,
      const Rect.fromLTWH(320, 781, 34, 13),
    );

    await tearDownApp(tester);
  });

  testWidgets('Navigation drawer matches Figma 7:1969 and navigates', (
    tester,
  ) async {
    useFigmaFrame(tester);
    await tester.pumpWidget(
      designApp(router: createAppRouter(initialLocation: HomeScreen.route)),
    );
    await settleEntry(tester);

    await tester.tap(find.byKey(const ValueKey('home_menu_button')));
    await settleEntry(tester);
    expect(tester.takeException(), isNull);

    expectRect(
      tester,
      find.byKey(const ValueKey('drawer_close')),
      const Rect.fromLTWH(280, 60.5, 22, 22),
    );
    expectRect(
      tester,
      inDrawer('Upgrade to Pro'),
      const Rect.fromLTWH(73, 140.5, 110, 18),
    );
    expectRect(tester, inDrawer('Home'), const Rect.fromLTWH(69, 259, 219, 18));
    expectRect(
      tester,
      inDrawer('About'),
      const Rect.fromLTWH(69, 658, 219, 18),
    );
    expect(tester.getRect(find.byType(Drawer)).width, closeTo(320, 0.5));

    // Features in the drawer switches tab and closes the drawer.
    await tester.tap(find.byKey(const ValueKey('drawer_features')));
    await settleEntry(tester);
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Kill Switch'), findsOneWidget);

    await tearDownApp(tester);
  });
}
