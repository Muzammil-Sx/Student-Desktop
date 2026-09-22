import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------- Desktop window ----------
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    size: Size(
      AppConstants.windowInitialWidth,
      AppConstants.windowInitialHeight,
    ),
    minimumSize: Size(
      AppConstants.windowMinWidth,
      AppConstants.windowMinHeight,
    ),
    center: true,
    title: AppConstants.appName,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // ---------- Service Locator ----------
  await setupServiceLocator();

  // ---------- Run ----------
  runApp(const StudentDesktopApp());
}