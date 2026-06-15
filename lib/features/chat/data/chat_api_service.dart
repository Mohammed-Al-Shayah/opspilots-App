import 'package:dio/dio.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/api_response_reader.dart';
import '../../../core/network/dio_client.dart';

class ChatApiService {
  const ChatApiService({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<List<dynamic>> getConversations() async {
    try {
      final response = await _dioClient.instance.get<Object?>(
        ApiPaths.chatConversations,
      );
      return ApiResponseReader.asList(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<List<dynamic>> getMessages(String conversationId) async {
    try {
      final response = await _dioClient.instance.get<Object?>(
        ApiPaths.chatMessages(conversationId),
      );
      return ApiResponseReader.asList(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    try {
      final response = await _dioClient.instance.post<Object?>(
        ApiPaths.chatMessages(conversationId),
        data: {'message': message},
      );
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }
}
