import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../app/presentation/controllers/global_loader_controller.dart';
import '../../../../app/presentation/views/home_tabs_view.dart';
import '../../../../core/assets.dart';
import '../../../../core/environmet/env.dart';
import '../providers/login_provider.dart';
import '../widgets/social_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (_) => LoginProvider(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            const BodyWidget(),
          ],
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
    final provider = Provider.of<LoginProvider>(context);

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
            controller: provider.emailController,
            decoration: InputDecoration(
              hintText: l10n.emailAddress,
              filled: true,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: provider.passwordController,
            obscureText: provider.obscurePassword,
            decoration: InputDecoration(
              hintText: l10n.password,
              filled: true,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  provider.obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  Provider.of<LoginProvider>(
                    context,
                    listen: false,
                  ).togglePasswordVisibility();
                },
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
            onPressed: () async {
              GlobalLoaderController.instance.setLoading(
                true,
                message: l10n.loggingIn,
              );

              await Future<void>.delayed(const Duration(seconds: 2));

              GlobalLoaderController.instance.setLoading(false);

              if (!context.mounted) {
                return;
              }

              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (_) => const HomeTabsView()),
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
          const SocialMedia(),
        ],
      ),
    );
  }
}
