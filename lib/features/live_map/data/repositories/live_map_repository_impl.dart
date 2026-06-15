import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/live_map_entity.dart';
import '../../domain/repositories/live_map_repository.dart';
import '../datasources/live_map_remote_datasource.dart';
import '../models/live_map_model.dart';

class LiveMapRepositoryImpl implements LiveMapRepository {
  const LiveMapRepositoryImpl({
    required LiveMapRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final LiveMapRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<LiveMapEntity>> getLiveMap() async {
    try {
      return AppResult.success(
        LiveMapModel.fromJson(await _remoteDataSource.getLiveMap()),
      );
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }
}
