import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_desktop/core/constants/app_constants.dart';
import 'package:student_desktop/core/theme/app_spacing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashMinimumDuration, () {
      if (mounted) context.go('/login');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 64, color: colors.primary),
            const SizedBox(height: AppSpacing.lg),
            Text(AppConstants.appName, style: text.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text('v${AppConstants.appVersion}', style: text.bodySmall),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}