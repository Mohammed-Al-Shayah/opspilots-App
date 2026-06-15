import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_entities.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';

enum ChatStatus { initial, loading, loaded, empty, failure, sending }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.conversations = const [],
    this.messages = const [],
    this.selectedConversation,
    this.errorMessage,
  });

  final ChatStatus status;
  final List<ChatConversationEntity> conversations;
  final List<ChatMessageEntity> messages;
  final ChatConversationEntity? selectedConversation;
  final String? errorMessage;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatConversationEntity>? conversations,
    List<ChatMessageEntity>? messages,
    ChatConversationEntity? selectedConversation,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      selectedConversation: selectedConversation ?? this.selectedConversation,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    conversations,
    messages,
    selectedConversation,
    errorMessage,
  ];
}

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required GetConversationsUseCase getConversationsUseCase,
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
  }) : _getConversationsUseCase = getConversationsUseCase,
       _getMessagesUseCase = getMessagesUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       super(const ChatState());

  final GetConversationsUseCase _getConversationsUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  Future<void> loadConversations() async {
    emit(state.copyWith(status: ChatStatus.loading, errorMessage: null));

    final result = await _getConversationsUseCase();
    result.when(
      success: (conversations) => emit(
        state.copyWith(
          status: conversations.isEmpty ? ChatStatus.empty : ChatStatus.loaded,
          conversations: conversations,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: ChatStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> selectConversation(ChatConversationEntity conversation) async {
    emit(
      state.copyWith(
        status: ChatStatus.loading,
        selectedConversation: conversation,
        messages: const [],
        errorMessage: null,
      ),
    );

    final result = await _getMessagesUseCase(conversation.id);
    result.when(
      success: (messages) => emit(
        state.copyWith(
          status: ChatStatus.loaded,
          selectedConversation: conversation,
          messages: messages,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: ChatStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    final conversation = state.selectedConversation;
    final text = message.trim();
    if (conversation == null || text.isEmpty) {
      return;
    }

    final previousMessages = state.messages;
    emit(state.copyWith(status: ChatStatus.sending, errorMessage: null));
    final result = await _sendMessageUseCase(
      conversationId: conversation.id,
      message: text,
    );
    result.when(
      success: (sentMessage) => emit(
        state.copyWith(
          status: ChatStatus.loaded,
          messages: [...previousMessages, sentMessage],
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: ChatStatus.loaded,
          messages: previousMessages,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
