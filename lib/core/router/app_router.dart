import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: SplashScreen.route,
  routes: [
    GoRoute(
      path: SplashScreen.route,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: HomeScreen.route,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
