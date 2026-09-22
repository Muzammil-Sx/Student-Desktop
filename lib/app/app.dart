import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_constants.dart';
import '../core/di/service_locator.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/bloc/theme_bloc.dart';
import '../core/theme/bloc/theme_event.dart';
import '../core/theme/bloc/theme_state.dart';
import 'router.dart';

class StudentDesktopApp extends StatelessWidget {
  const StudentDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (_) => serviceLocator<ThemeBloc>()..add(const LoadTheme()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.mode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}