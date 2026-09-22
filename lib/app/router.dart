import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_desktop/app/theme/splash_screen.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_shell.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Global router instance.
/// Constructed once — never rebuilt.
final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardShell(),
    ),
  ],
);