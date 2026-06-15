import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/router/navigation_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../chat/domain/entities/chat_entities.dart';
import '../../../chat/presentation/cubit/chat_cubit.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';
import '../widgets/field_bottom_nav.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.t('chat', language),
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color(0xFF94A3B8),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppStrings.t('searchConversations', language),
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.status == ChatStatus.loading &&
                      state.conversations.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == ChatStatus.failure) {
                    return _ChatMessageState(
                      title: 'Unable to load conversations',
                      message: state.errorMessage ?? '',
                      onRetry: context.read<ChatCubit>().loadConversations,
                    );
                  }
                  if (state.conversations.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: _ChatEmptyState(
                        title: 'No conversations',
                        message: 'No conversations are available.',
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: context.read<ChatCubit>().loadConversations,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        return _ConversationCard(
                          conversation: conversation,
                          onTap: () async {
                            await context.read<ChatCubit>().selectConversation(
                              conversation,
                            );
                            if (context.mounted) {
                              context.push(AppRoutes.chatThread);
                            }
                          },
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemCount: state.conversations.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.chat),
    );
  }
}

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({super.key});

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                final conversation = state.selectedConversation;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 24, 14),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.popOrGo(AppRoutes.chat),
                        icon: Icon(
                          language == 'ar'
                              ? Icons.arrow_forward
                              : Icons.arrow_back,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xFFF1F5F9),
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.darkSlate,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversation?.name ?? 'Chat',
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if ((conversation?.role ?? '').isNotEmpty)
                              Text(
                                conversation!.role,
                                style: const TextStyle(
                                  color: AppColors.mutedText,
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listenWhen: (previous, current) {
                  return previous.errorMessage != current.errorMessage &&
                      current.errorMessage != null;
                },
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage ?? 'Chat error')),
                  );
                },
                builder: (context, state) {
                  if (state.selectedConversation == null) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: _ChatEmptyState(
                        title: 'No conversation selected',
                        message: 'Open a conversation from the chat list.',
                      ),
                    );
                  }
                  if (state.status == ChatStatus.loading &&
                      state.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.messages.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: _ChatEmptyState(
                        title: 'No messages',
                        message: 'Start the conversation below.',
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(24),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          state.messages[state.messages.length - index - 1];
                      return _MessageBubble(message);
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  final canSend =
                      state.selectedConversation != null &&
                      state.status != ChatStatus.sending;
                  return Row(
                    children: [
                      const Icon(Icons.attach_file, color: AppColors.mutedText),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: canSend,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filled(
                        onPressed: canSend
                            ? () async {
                                final text = _controller.text;
                                _controller.clear();
                                await context.read<ChatCubit>().sendMessage(
                                  text,
                                );
                              }
                            : null,
                        icon: state.status == ChatStatus.sending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send_outlined),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.darkSlate,
                          disabledBackgroundColor: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({required this.conversation, required this.onTap});

  final ChatConversationEntity conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFF1F5F9),
                  child: Icon(Icons.person_outline, color: AppColors.darkSlate),
                ),
                if (conversation.unreadCount > 0)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF2D3D),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        conversation.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.name.isEmpty
                        ? 'Conversation'
                        : conversation.name,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (conversation.role.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      conversation.role,
                      style: const TextStyle(color: AppColors.mutedText),
                    ),
                  ],
                  if (conversation.lastMessage.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      conversation.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.mutedText),
                    ),
                  ],
                ],
              ),
            ),
            if (conversation.lastMessageAt.isNotEmpty)
              Text(
                conversation.lastMessageAt,
                style: const TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble(this.message);

  final ChatMessageEntity message;

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
          ),
        ),
      );
    }

    final isMine = message.isMine;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 270),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMine ? AppColors.darkSlate : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isMine ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMine ? Colors.white : AppColors.ink,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            if (message.createdAt.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                message.createdAt,
                style: TextStyle(
                  color: isMine ? const Color(0xFF67E8F9) : AppColors.mutedText,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChatMessageState extends StatelessWidget {
  const _ChatMessageState({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _ChatEmptyState(title: title, message: message),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _ChatEmptyState extends StatelessWidget {
  const _ChatEmptyState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFFCBD5E1),
            size: 48,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText),
          ),
        ],
      ),
    );
  }
}
