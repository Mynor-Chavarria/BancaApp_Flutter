import 'package:flutter/material.dart';
import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/controllers/global_loader_controller.dart';
import '../../../../core/assets.dart';
import '../../../../core/environmet/env.dart';
import '../../../../core/router/app_routes.dart';
import '../../../login/presentation/widgets/social_widget.dart';
import '../providers/auth_providers.dart';
import '../state/auth_state.dart';

class AuthLoginView extends ConsumerStatefulWidget {
  const AuthLoginView({super.key});

  @override
  ConsumerState<AuthLoginView> createState() => _AuthLoginViewState();
}

class _AuthLoginViewState extends ConsumerState<AuthLoginView> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      GlobalLoaderController.instance.setLoading(
        next.isLoading,
        message: next.isLoading ? AppLocalizations.of(context)!.loggingIn : null,
      );

      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        ref.read(authNotifierProvider.notifier).clearError();
      }

      if (next.isSuccess && previous?.isSuccess != true) {
        context.go(AppRoutes.home);
      }
    });

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceBright,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.asset(Assets.logo, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Env.appName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: l10n.username,
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: state.obscurePassword,
                    decoration: InputDecoration(
                      hintText: l10n.password,
                      filled: true,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed:
                            ref
                                .read(authNotifierProvider.notifier)
                                .togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: () {}, child: Text(l10n.forgotPassword)),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed:
                        state.isLoading
                            ? null
                            : () {
                              ref.read(authNotifierProvider.notifier).login(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              );
                            },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(l10n.login),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${l10n.notMember} '),
                      TextButton(
                        onPressed: () {
                          debugPrint('Navigate to Sign Up');
                        },
                        child: Text(
                          l10n.registerNow,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text(
                    l10n.orContinueWith,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  const _SocialMedia(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialMedia extends StatelessWidget {
  const _SocialMedia();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialWidget.google(),
        const SizedBox(width: 16),
        SocialWidget.apple(),
        const SizedBox(width: 16),
        SocialWidget.facebook(),
      ],
    );
  }
}
