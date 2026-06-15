import '../../../../core/network/api_response_reader.dart';
import '../../domain/entities/chat_entities.dart';

class ChatConversationModel extends ChatConversationEntity {
  const ChatConversationModel({
    required super.id,
    required super.name,
    required super.role,
    required super.lastMessage,
    required super.lastMessageAt,
    required super.unreadCount,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    final participant = ApiResponseReader.asMap(
      json['participant'] ?? json['user'] ?? json['member'],
    );
    final lastMessage = ApiResponseReader.asMap(json['last_message']);
    return ChatConversationModel(
      id: (json['id'] ?? json['conversation_id'] ?? '').toString(),
      name: (json['name'] ?? participant['name'] ?? '').toString(),
      role:
          (json['role'] ?? participant['role'] ?? participant['role_key'] ?? '')
              .toString(),
      lastMessage:
          (json['last_message_text'] ??
                  lastMessage['message'] ??
                  lastMessage['body'] ??
                  lastMessage['text'] ??
                  json['message'] ??
                  '')
              .toString(),
      lastMessageAt:
          (json['last_message_at'] ??
                  lastMessage['created_at'] ??
                  json['updated_at'] ??
                  '')
              .toString(),
      unreadCount: _int(json['unread_count'] ?? json['unread']),
    );
  }

  static int _int(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.conversationId,
    required super.text,
    required super.createdAt,
    required super.isMine,
    required super.isSystem,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final sender = ApiResponseReader.asMap(json['sender'] ?? json['user']);
    final type = (json['type'] ?? '').toString().toLowerCase();
    return ChatMessageModel(
      id: (json['id'] ?? '').toString(),
      conversationId: (json['conversation_id'] ?? '').toString(),
      text: (json['message'] ?? json['body'] ?? json['text'] ?? '').toString(),
      createdAt: (json['created_at'] ?? json['time'] ?? '').toString(),
      isMine:
          json['is_mine'] == true ||
          json['mine'] == true ||
          sender['is_me'] == true,
      isSystem:
          json['is_system'] == true ||
          type == 'system' ||
          type == 'status_update',
    );
  }
}
