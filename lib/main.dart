import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'core/cache/cache_service.dart';
import 'core/connectivity/connectivity_service.dart';
import 'core/constants/app_constants.dart';
import 'core/database/app_database.dart';
import 'core/di/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------- Desktop window ----------
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    size: Size(AppConstants.windowInitialWidth, AppConstants.windowInitialHeight),
    minimumSize: Size(AppConstants.windowMinWidth, AppConstants.windowMinHeight),
    center: true,
    title: AppConstants.appName,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // ---------- Async infrastructure ----------
  final cache = await CacheService.init();

  final connectivity = ConnectivityService();
  await connectivity.start();

  final database = AppDatabase();

  // ---------- Run ----------
  runApp(
    ProviderScope(
      overrides: [
        cacheServiceProvider.overrideWithValue(cache),
        connectivityServiceProvider.overrideWithValue(connectivity),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const StudentDesktopApp(),
    ),
  );
}