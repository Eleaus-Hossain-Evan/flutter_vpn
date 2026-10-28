import 'package:go_router/go_router.dart';

import '../../features/features/presentation/screens/features_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/servers/presentation/screens/choose_server_screen.dart';
import '../../features/servers/presentation/screens/server_details_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_shell.dart';

final appRouter = createAppRouter();

/// Builds the app's router; tests start it at [initialLocation].
GoRouter createAppRouter({String initialLocation = SplashScreen.route}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: SplashScreen.route,
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomeScreen.route,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: FeaturesScreen.route,
                builder: (context, state) => const FeaturesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ProfileScreen.route,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: ChooseServerScreen.route,
        builder: (context, state) => const ChooseServerScreen(),
      ),
      GoRoute(
        path: ServerDetailsScreen.route,
        builder: (context, state) =>
            ServerDetailsScreen(serverId: state.pathParameters['id']!),
      ),
    ],
  );
}
