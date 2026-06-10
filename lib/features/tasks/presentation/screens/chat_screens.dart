import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/router/navigation_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';
import '../widgets/field_bottom_nav.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

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
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _ConversationTile(
                    name: 'خالد العلي',
                    role: 'Supervisor',
                    message: 'Great work on the last task!',
                    time: '10:30 AM',
                    unread: 2,
                    onTap: () => context.push(AppRoutes.chatThread),
                  ),
                  const SizedBox(height: 10),
                  const _ConversationTile(
                    name: 'سارة أحمد',
                    role: 'Operations Manager',
                    message: 'Please check the delayed tasks',
                    time: 'Yesterday',
                  ),
                  const SizedBox(height: 10),
                  const _ConversationTile(
                    name: 'Support Team',
                    role: 'Support',
                    message: 'How can we help you today?',
                    time: '2 days ago',
                    unread: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.chat),
    );
  }
}

class ChatThreadScreen extends StatelessWidget {
  const ChatThreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 24, 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.popOrGo(AppRoutes.chat),
                    icon: Icon(
                      language == 'ar' ? Icons.arrow_forward : Icons.arrow_back,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFF0F1F4),
                    child: Icon(Icons.person_outline, color: AppColors.ink),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خالد العلي',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Supervisor',
                        style: TextStyle(color: AppColors.mutedText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  _MessageBubble(
                    text: 'Hi! How is the task going?',
                    time: '10:15 AM',
                  ),
                  SizedBox(height: 16),
                  _MessageBubble(
                    text: 'Going well! Just finished the\ninstallation.',
                    time: '10:18 AM',
                    mine: true,
                  ),
                  SizedBox(height: 16),
                  _MessageBubble(
                    text: 'Great work on the last task!',
                    time: '10:30 AM',
                  ),
                  SizedBox(height: 18),
                  Center(
                    child: _SystemMessage(
                      text: 'Task T-001 status updated to "Completed"',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_file, color: AppColors.ink),
                  const SizedBox(width: 22),
                  const Expanded(
                    child: Text(
                      'Type a message...',
                      style: TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.darkSlate,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(Icons.send_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.name,
    required this.role,
    required this.message,
    required this.time,
    this.unread,
    this.onTap,
  });

  final String name;
  final String role;
  final String message;
  final String time;
  final int? unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border, width: 1.3),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFF0F1F4),
                  child: Icon(Icons.person_outline, color: AppColors.ink),
                ),
                if (unread != null)
                  Positioned(
                    top: -6,
                    right: -5,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: const Color(0xFFFF3045),
                      child: Text(
                        '$unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    role,
                    style: const TextStyle(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    style: const TextStyle(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.text,
    required this.time,
    this.mine = false,
  });

  final String text;
  final String time;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 245),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: mine ? AppColors.darkSlate : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: mine ? Colors.white : AppColors.ink,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: TextStyle(
                color: mine ? AppColors.cyan : AppColors.mutedText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemMessage extends StatelessWidget {
  const _SystemMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
      ),
    );
  }
}
