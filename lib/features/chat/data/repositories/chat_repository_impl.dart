import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_response_reader.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_models.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ChatRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<ChatConversationEntity>>> getConversations() async {
    try {
      final rows = await _remoteDataSource.getConversations();
      return AppResult.success(
        rows
            .map(ApiResponseReader.asMap)
            .map(ChatConversationModel.fromJson)
            .where((conversation) => conversation.id.isNotEmpty)
            .toList(),
      );
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<List<ChatMessageEntity>>> getMessages(
    String conversationId,
  ) async {
    try {
      final rows = await _remoteDataSource.getMessages(conversationId);
      return AppResult.success(
        rows
            .map(ApiResponseReader.asMap)
            .map(ChatMessageModel.fromJson)
            .toList(),
      );
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<ChatMessageEntity>> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    try {
      final response = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        message: message,
      );
      final payload = response.isEmpty
          ? {
              'conversation_id': conversationId,
              'message': message,
              'is_mine': true,
            }
          : response;
      return AppResult.success(ChatMessageModel.fromJson(payload));
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }
}
