import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:riverpod_devtools/riverpod_devtools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  // Release builds must not expose a remote-control surface, so Marionette is
  // left out of them entirely.
  if (!kDebugMode) {
    WidgetsFlutterBinding.ensureInitialized();
    await _bootstrap();
    return;
  }

  // Marionette drives the running app over the VM service so screens can be
  // exercised live during development.
  //
  // Its log store is opt-in: without a collector, `get_logs` has nothing to
  // return. A zone that mirrors every `print` into the collector fills it —
  // `debugPrint` routes through `print` too, so framework and app logs both
  // land there. The binding has to be initialized inside that same zone as
  // `runApp`, or Flutter asserts on the mismatch.
  final logCollector = PrintLogCollector();
  await runZoned(
    () async {
      MarionetteBinding.ensureInitialized(
        MarionetteConfiguration(logCollector: logCollector),
      );
      await _bootstrap();
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        parent.print(zone, line);
        logCollector.addLog(line);
      },
    ),
  );
}

/// Loads what the app needs before its first frame, then starts it.
Future<void> _bootstrap() async {
  await loadStaticDependenciesForRiverpodDevTools();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      observers: [RiverpodDevToolsObserver(), TalkerRiverpodObserver()],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, _) => MaterialApp.router(
        title: 'RedbullVPN',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}

Future<void> loadStaticDependenciesForRiverpodDevTools() async {
  // Load static dependencies (required for dependency graph)
  try {
    final jsonString = await rootBundle.loadString(
      'lib/riverpod_dependencies.json',
    );
    RiverpodDevToolsRegistry.instance.loadFromJson(jsonString);
  } catch (e) {
    // The asset is missing or unreadable. Log the reason instead of
    // swallowing it silently — otherwise the dependency graph is just
    // empty with no hint as to why.
    debugPrint('riverpod_devtools: could not load dependency data: $e');
  }
}
