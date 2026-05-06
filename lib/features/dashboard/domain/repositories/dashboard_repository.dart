import '../entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<List<DashboardEntity>> getMyAccounts();
}
