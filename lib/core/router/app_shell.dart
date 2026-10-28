import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/drawer/presentation/widgets/app_drawer.dart';
import '../../features/servers/presentation/screens/choose_server_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/app_bottom_nav.dart';

/// Frame for the tab screens: bottom navigation + navigation drawer.
///
/// Branches: 0 Home, 1 Features, 2 Profile. Servers is not a branch: it is
/// pushed over the shell with its own back button, as in Figma.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Bottom-nav index of each branch (nav index 1 is Servers).
  static const _navIndex = [0, 2, 3];

  /// Opens the drawer from inside a tab screen, which has its own Scaffold.
  static void openDrawer(BuildContext context) =>
      context.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer();

  void _goBranch(int branch) => navigationShell.goBranch(
    branch,
    initialLocation: branch == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final branch = navigationShell.currentIndex;

    return Scaffold(
      // Shows under the nav in the gesture area: the gradient's end colour.
      backgroundColor: AppColors.surfaceMuted,
      drawerScrimColor: AppColors.scrim,
      drawer: AppDrawer(
        selected: switch (branch) {
          0 => DrawerItem.home,
          1 => DrawerItem.features,
          _ => null,
        },
        onSelect: (item) {
          Navigator.of(context).pop();
          switch (item) {
            case DrawerItem.home:
              _goBranch(0);
            case DrawerItem.servers:
              context.push(ChooseServerScreen.route);
            case DrawerItem.features:
              _goBranch(1);
            // No screens for these in Figma yet.
            case DrawerItem.history ||
                DrawerItem.settings ||
                DrawerItem.share ||
                DrawerItem.help ||
                DrawerItem.about:
              break;
          }
        },
      ),
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex[branch],
        onTap: (index) {
          if (index == 1) {
            context.push(ChooseServerScreen.route);
          } else {
            _goBranch(_navIndex.indexOf(index));
          }
        },
      ),
    );
  }
}
