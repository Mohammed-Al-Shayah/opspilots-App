class ChatConversationEntity {
  const ChatConversationEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  final String id;
  final String name;
  final String role;
  final String lastMessage;
  final String lastMessageAt;
  final int unreadCount;
}

class ChatMessageEntity {
  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.createdAt,
    required this.isMine,
    required this.isSystem,
  });

  final String id;
  final String conversationId;
  final String text;
  final String createdAt;
  final bool isMine;
  final bool isSystem;
}
