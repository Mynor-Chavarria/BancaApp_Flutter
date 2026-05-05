import 'package:go_router/go_router.dart';

import '../../app/presentation/views/home_tabs_view.dart';
import '../../features/login/login_dependencies.dart';
import '../../features/login/presentation/views/login_view.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder:
          (context, state) =>
              LoginView(createCubit: LoginDependencies.createLoginCubit),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeTabsView(),
    ),
  ],
);
