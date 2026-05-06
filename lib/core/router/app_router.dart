import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/presentation/views/home_tabs_view.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/views/auth_login_view.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final session = ref.read(authNotifierProvider).session;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (session == null && !isOnLogin) return AppRoutes.login;
      if (session != null && isOnLogin) return AppRoutes.home; // redirect usa path, no name
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const AuthLoginView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeTabsView(),
      ),
    ],
  );

  // Refresca el router cuando el estado de auth cambia (ej: forceLogout)
  ref.listen(authNotifierProvider, (_, __) => router.refresh());

  return router;
});
