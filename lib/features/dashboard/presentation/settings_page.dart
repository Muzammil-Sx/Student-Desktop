import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_desktop/shared/widgets/app_text_field.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../../core/theme/bloc/theme_event.dart';
import '../../../core/theme/bloc/theme_state.dart';
import '../../../shared/widgets/app_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: text.headlineMedium),
          const SizedBox(height: AppSpacing.xl),

          // ---------- Theme ----------
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.brightness_6_outlined),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Theme', style: text.titleMedium),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Currently: ${state.mode.name}',
                            style: text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined),
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto_outlined),
                          label: Text('Auto'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined),
                          label: Text('Dark'),
                        ),
                      ],
                      selected: {state.mode},
                      onSelectionChanged: (selection) {
                        context
                            .read<ThemeBloc>()
                            .add(SetThemeMode(selection.first));
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // ---------- Sign out ----------
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.logout),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sign out', style: text.titleMedium),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        'Return to login screen.',
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                ),
                AppButton(
                  label: 'Sign out',
                  variant: AppButtonVariant.outline,
                  onPressed: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}