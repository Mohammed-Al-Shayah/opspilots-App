import '../../../../core/utils/app_result.dart';
import '../entities/live_map_entity.dart';
import '../repositories/live_map_repository.dart';

class GetLiveMapUseCase {
  const GetLiveMapUseCase(this._repository);

  final LiveMapRepository _repository;

  Future<AppResult<LiveMapEntity>> call() => _repository.getLiveMap();
}
