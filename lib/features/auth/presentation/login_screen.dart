import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_desktop/shared/widgets/app_card.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    // UI-only for Day 1 — real API comes later.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    context.showSnack('Login successful (UI only)');
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.school_outlined, size: 56, color: colors.primary),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: text.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sign in to continue to ${AppConstants.appName}',
                    textAlign: TextAlign.center,
                    style: text.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  AppTextField(
                    controller: _emailCtrl,
                    focusNode: _emailFocus,
                    label: 'Email',
                    hint: 'you@example.com',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.combine([
                      (v) => Validators.required(v, message: 'Email is required'),
                      Validators.email,
                    ]),
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _passwordCtrl,
                    focusNode: _passwordFocus,
                    label: 'Password',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (v) => Validators.combine([
                      (v) => Validators.required(v, message: 'Password is required'),
                      (v) => Validators.minLength(v, 6),
                    ])(v),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Sign In',
                    isFullWidth: true,
                    size: AppButtonSize.lg,
                    isLoading: _isSubmitting,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'UI only — API integration coming next.',
                    textAlign: TextAlign.center,
                    style: text.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}