import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase {
  const GetDashboardUseCase(this._repository);

  final DashboardRepository _repository;

  Future<List<DashboardEntity>> call() {
    return _repository.getMyAccounts();
  }
}
