import 'package:dio/dio.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/api_response_reader.dart';
import '../../../core/network/dio_client.dart';

class LiveMapApiService {
  const LiveMapApiService({required DioClient dioClient})
    : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<Map<String, dynamic>> getLiveMap() async {
    try {
      final response = await _dioClient.instance.get<Object?>(ApiPaths.liveMap);
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }
}
