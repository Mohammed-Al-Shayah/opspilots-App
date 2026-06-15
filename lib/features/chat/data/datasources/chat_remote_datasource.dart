import '../chat_api_service.dart';

abstract class ChatRemoteDataSource {
  Future<List<dynamic>> getConversations();

  Future<List<dynamic>> getMessages(String conversationId);

  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({required ChatApiService apiService})
    : _apiService = apiService;

  final ChatApiService _apiService;

  @override
  Future<List<dynamic>> getConversations() => _apiService.getConversations();

  @override
  Future<List<dynamic>> getMessages(String conversationId) {
    return _apiService.getMessages(conversationId);
  }

  @override
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
  }) {
    return _apiService.sendMessage(
      conversationId: conversationId,
      message: message,
    );
  }
}
