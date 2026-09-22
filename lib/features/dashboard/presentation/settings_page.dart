import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_desktop/shared/widgets/app_text_field.dart';

import '../../../core/di/providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: text.headlineMedium),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
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
                        'Currently: ${themeMode.name}',
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
                  selected: {themeMode},
                  onSelectionChanged: (s) => notifier.set(s.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
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