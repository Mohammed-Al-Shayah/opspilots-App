import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_response_reader.dart';
import '../../../../core/utils/app_result.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../domain/entities/supervisor_summary_entity.dart';
import '../../domain/repositories/supervisor_repository.dart';
import '../datasources/supervisor_remote_datasource.dart';

class SupervisorRepositoryImpl implements SupervisorRepository {
  const SupervisorRepositoryImpl({
    required SupervisorRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final SupervisorRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<SupervisorSummaryEntity>> getSummary() async {
    try {
      final rawTasks = await _remoteDataSource.getTeamTasks();
      final dashboard = await _remoteDataSource.getDashboard();
      final tasks = rawTasks
          .map(ApiResponseReader.asMap)
          .map(TaskModel.fromJson)
          .toList();

      return AppResult.success(
        SupervisorSummaryEntity(
          supervisorName: _stringValue(dashboard, const [
            'supervisor_name',
            'name',
          ]),
          activeTeamCount: _intValue(dashboard, const [
            'active_team',
            'activeTeam',
          ]),
          pendingReviewsCount: _intValue(dashboard, const [
            'pending_reviews',
            'pendingReviews',
          ]),
          completedTodayCount: _intValue(dashboard, const [
            'completed_today',
            'completedToday',
          ]),
          delayedCount: _intValue(dashboard, const [
            'delayed',
            'delayed_tasks',
          ]),
          teamTasks: tasks,
        ),
      );
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  String _stringValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return '';
  }

  int _intValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null) {
        return parsed;
      }
    }
    return 0;
  }
}
