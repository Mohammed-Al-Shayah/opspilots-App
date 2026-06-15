import '../../../../core/utils/app_result.dart';
import '../entities/chat_entities.dart';
import '../repositories/chat_repository.dart';

class GetConversationsUseCase {
  const GetConversationsUseCase(this._repository);

  final ChatRepository _repository;

  Future<AppResult<List<ChatConversationEntity>>> call() {
    return _repository.getConversations();
  }
}
