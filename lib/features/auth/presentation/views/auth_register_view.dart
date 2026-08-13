import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/controllers/global_loader_controller.dart';
import '../../../../core/assets.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/auth_providers.dart';
import '../state/auth_state.dart';

class AuthRegisterView extends ConsumerStatefulWidget {
  const AuthRegisterView({super.key});

  @override
  ConsumerState<AuthRegisterView> createState() => _AuthRegisterViewState();
}

class _AuthRegisterViewState extends ConsumerState<AuthRegisterView> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      GlobalLoaderController.instance.setLoading(
        next.isLoading,
        message:
            next.isLoading
                ? AppLocalizations.of(context)!.creatingAccount
                : null,
      );

      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        ref.read(authNotifierProvider.notifier).clearError();
      }

      if (next.isSuccess && previous?.isSuccess != true) {
        context.goNamed(AppRoutes.homeName);
      }
    });

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(authNotifierProvider);
    final genderOptions = [
      l10n.genderFemale,
      l10n.genderMale,
      l10n.genderOther,
    ];

    return Scaffold(
      backgroundColor: colorScheme.surfaceBright,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Image.asset(Assets.logo, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.createAccount,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    decoration: InputDecoration(
                      hintText: l10n.fullName,
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      hintText: l10n.emailAddress,
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    items: genderOptions
                        .map(
                          (gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ),
                        )
                        .toList(growable: false),
                    onChanged:
                        state.isLoading
                            ? null
                            : (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                    decoration: InputDecoration(
                      hintText: l10n.gender,
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: state.obscurePassword,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
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
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed:
                        state.isLoading
                            ? null
                            : () {
                              ref
                                  .read(authNotifierProvider.notifier)
                                  .register(
                                    fullName: _fullNameController.text,
                                    email: _emailController.text,
                                    gender: _selectedGender ?? '',
                                    password: _passwordController.text,
                                    l10n: l10n,
                                  );
                            },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(l10n.createAccount.toUpperCase()),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${l10n.alreadyHaveAccount} '),
                      TextButton(
                        onPressed: () => context.goNamed(AppRoutes.loginName),
                        child: Text(
                          l10n.login,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
