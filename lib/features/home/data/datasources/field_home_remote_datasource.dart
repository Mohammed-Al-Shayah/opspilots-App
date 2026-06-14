import '../../../operations/data/datasources/dashboard_remote_datasource.dart';
import '../../../tasks/data/datasources/tasks_remote_datasource.dart';

abstract class FieldHomeRemoteDataSource {
  Future<Map<String, dynamic>> getDashboard();

  Future<List<dynamic>> getMyTasks();
}

class FieldHomeRemoteDataSourceImpl implements FieldHomeRemoteDataSource {
  const FieldHomeRemoteDataSourceImpl({
    required DashboardRemoteDataSource dashboardRemoteDataSource,
    required TasksRemoteDataSource tasksRemoteDataSource,
  }) : _dashboardRemoteDataSource = dashboardRemoteDataSource,
       _tasksRemoteDataSource = tasksRemoteDataSource;

  final DashboardRemoteDataSource _dashboardRemoteDataSource;
  final TasksRemoteDataSource _tasksRemoteDataSource;

  @override
  Future<Map<String, dynamic>> getDashboard() {
    return _dashboardRemoteDataSource.getDashboard();
  }

  @override
  Future<List<dynamic>> getMyTasks() {
    return _tasksRemoteDataSource.getMyTasks();
  }
}
