import '../../../../core/utils/app_result.dart';
import '../entities/live_map_entity.dart';

abstract class LiveMapRepository {
  Future<AppResult<LiveMapEntity>> getLiveMap();
}
