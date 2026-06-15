import '../../../../core/utils/app_result.dart';
import '../entities/chat_entities.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<AppResult<ChatMessageEntity>> call({
    required String conversationId,
    required String message,
  }) {
    return _repository.sendMessage(
      conversationId: conversationId,
      message: message,
    );
  }
}
