import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/controllers/global_loader_controller.dart';
import '../../../../core/assets.dart';
import '../../../../core/environmet/env.dart';
import '../../../../core/router/app_routes.dart';
import '../state/login_cubit.dart';
import '../state/login_state.dart';
import '../widgets/social_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.createCubit});

  final LoginCubit Function() createCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => createCubit(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        GlobalLoaderController.instance.setLoading(
          state.isLoading,
          message:
              state.isLoading ? AppLocalizations.of(context)!.loggingIn : null,
        );

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<LoginCubit>().clearError();
        }

        if (state.logged) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
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
              const BodyWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key});

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

class BodyWidget extends StatelessWidget {
  const BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Padding(
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
                controller: cubit.emailController,
                decoration: InputDecoration(
                  hintText: l10n.emailAddress,
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cubit.passwordController,
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
                    onPressed: cubit.togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(l10n.forgotPassword),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: state.isLoading ? null : cubit.login,
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
              const SocialMedia(),
            ],
          ),
        );
      },
    );
  }
}
