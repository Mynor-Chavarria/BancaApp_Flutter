import 'data/repositories/login_repository_impl.dart';
import 'domain/usecases/get_login_usecase.dart';
import 'presentation/state/login_cubit.dart';

class LoginDependencies {
  const LoginDependencies._();

  static LoginCubit createLoginCubit() {
    final repository = LoginRepositoryImpl();
    final useCase = GetLoginUseCase(repository);
    return LoginCubit(useCase);
  }
}
