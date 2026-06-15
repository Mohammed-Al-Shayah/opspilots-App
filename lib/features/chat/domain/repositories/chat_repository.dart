import '../../../../core/utils/app_result.dart';
import '../entities/chat_entities.dart';

abstract class ChatRepository {
  Future<AppResult<List<ChatConversationEntity>>> getConversations();

  Future<AppResult<List<ChatMessageEntity>>> getMessages(String conversationId);

  Future<AppResult<ChatMessageEntity>> sendMessage({
    required String conversationId,
    required String message,
  });
}
