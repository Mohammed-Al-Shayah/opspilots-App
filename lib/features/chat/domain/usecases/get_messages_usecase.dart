import '../../../../core/utils/app_result.dart';
import '../entities/chat_entities.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  const GetMessagesUseCase(this._repository);

  final ChatRepository _repository;

  Future<AppResult<List<ChatMessageEntity>>> call(String conversationId) {
    return _repository.getMessages(conversationId);
  }
}
