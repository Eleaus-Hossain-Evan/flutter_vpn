import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: SplashScreen.route,
  routes: [
    GoRoute(
      path: SplashScreen.route,
      builder: (context, state) => const SplashScreen(),
    ),
  ],
);
