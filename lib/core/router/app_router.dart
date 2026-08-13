import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/presentation/views/home_tabs_view.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/views/auth_login_view.dart';
import '../../features/auth/presentation/views/auth_register_view.dart';
import '../../features/history/presentation/views/account_history_view.dart';
import '../../features/settings/presentation/views/profile_view.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final session = ref.read(authNotifierProvider).session;
      final isOnLogin = state.matchedLocation == AppRoutes.login;
      final isOnRegister = state.matchedLocation == AppRoutes.register;
      final isOnAuthRoute = isOnLogin || isOnRegister;

      if (session == null && !isOnAuthRoute) return AppRoutes.login;
      if (session != null && isOnAuthRoute) {
        return AppRoutes.home; // redirect usa path, no name
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const AuthLoginView(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        builder: (context, state) => const AuthRegisterView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomeTabsView(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileName,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.accountHistory,
        name: AppRoutes.accountHistoryName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return AccountHistoryView(
            accountId: extra['accountId'] as String,
            accountName: extra['accountName'] as String,
          );
        },
      ),
    ],
  );

  // Refresca el router cuando el estado de auth cambia (ej: forceLogout)
  ref.listen(authNotifierProvider, (_, __) => router.refresh());

  return router;
});
