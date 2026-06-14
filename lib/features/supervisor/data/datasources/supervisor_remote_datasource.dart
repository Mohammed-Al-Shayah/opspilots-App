import '../../../operations/data/datasources/dashboard_remote_datasource.dart';
import '../../../tasks/data/datasources/tasks_remote_datasource.dart';

abstract class SupervisorRemoteDataSource {
  Future<Map<String, dynamic>> getDashboard();

  Future<List<dynamic>> getTeamTasks();
}

class SupervisorRemoteDataSourceImpl implements SupervisorRemoteDataSource {
  const SupervisorRemoteDataSourceImpl({
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
  Future<List<dynamic>> getTeamTasks() {
    return _tasksRemoteDataSource.getTasks();
  }
}
