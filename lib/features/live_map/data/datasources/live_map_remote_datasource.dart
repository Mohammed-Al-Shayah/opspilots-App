import '../live_map_api_service.dart';

abstract class LiveMapRemoteDataSource {
  Future<Map<String, dynamic>> getLiveMap();
}

class LiveMapRemoteDataSourceImpl implements LiveMapRemoteDataSource {
  const LiveMapRemoteDataSourceImpl({required LiveMapApiService apiService})
    : _apiService = apiService;

  final LiveMapApiService _apiService;

  @override
  Future<Map<String, dynamic>> getLiveMap() => _apiService.getLiveMap();
}
