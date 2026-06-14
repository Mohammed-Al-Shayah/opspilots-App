import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_response_reader.dart';
import '../../../../core/utils/app_result.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../domain/entities/field_home_summary_entity.dart';
import '../../domain/repositories/field_home_repository.dart';
import '../datasources/field_home_remote_datasource.dart';

class FieldHomeRepositoryImpl implements FieldHomeRepository {
  const FieldHomeRepositoryImpl({
    required FieldHomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final FieldHomeRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<FieldHomeSummaryEntity>> getSummary() async {
    try {
      final rawTasks = await _remoteDataSource.getMyTasks();
      final dashboard = await _remoteDataSource.getDashboard();
      final tasks = rawTasks
          .map(ApiResponseReader.asMap)
          .map(TaskModel.fromJson)
          .toList();

      return AppResult.success(
        FieldHomeSummaryEntity(
          employeeName: _stringValue(dashboard, const [
            'employee_name',
            'name',
          ]),
          roleLabel: 'Field Employee',
          todayCount: _intValue(dashboard, const ['today', 'today_tasks']),
          pendingCount: _intValue(dashboard, const [
            'pending',
            'pending_tasks',
          ]),
          activeCount: _intValue(dashboard, const ['active', 'active_tasks']),
          completedCount: _intValue(dashboard, const [
            'completed',
            'completed_tasks',
          ]),
          completionRate: _rateValue(dashboard, const [
            'completion_rate',
            'completionRate',
          ]),
          todayTasks: tasks,
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

  double _rateValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is num) {
        return value > 1 ? value / 100 : value.toDouble();
      }
      final parsed = double.tryParse(value?.toString() ?? '');
      if (parsed != null) {
        return parsed > 1 ? parsed / 100 : parsed;
      }
    }
    return 0;
  }
}
