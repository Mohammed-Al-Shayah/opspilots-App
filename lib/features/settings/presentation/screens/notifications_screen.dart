import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/language_cubit.dart';
import '../cubit/notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) {
        return;
      }
      final cubit = context.read<NotificationsCubit>();
      if (cubit.state.status == NotificationsStatus.initial) {
        cubit.loadNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<NotificationsCubit, NotificationsState>(
          listenWhen: (previous, current) {
            return previous.errorMessage != current.errorMessage &&
                current.errorMessage != null;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? '')));
          },
          builder: (context, state) {
            return Column(
              children: [
                OpsHeader(
                  title: AppStrings.t('notifications', language),
                  fallbackRoute: AppRoutes.profile,
                  action: OpsHeaderAction.text(
                    label: AppStrings.t('markAllRead', language),
                    onPressed:
                        state.notifications.isEmpty ||
                            state.status == NotificationsStatus.updating
                        ? () {}
                        : context.read<NotificationsCubit>().markAllRead,
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                Expanded(child: _NotificationsBody(state: state)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody({required this.state});

  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;

    if (state.status == NotificationsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == NotificationsStatus.failure &&
        state.notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: context.read<NotificationsCubit>().loadNotifications,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _EmptyState(
              icon: Icons.error_outline,
              text:
                  state.errorMessage ??
                  AppStrings.t('noNotifications', language),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: context.read<NotificationsCubit>().loadNotifications,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _EmptyState(
              icon: Icons.notifications_none,
              text: AppStrings.t('noNotifications', language),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: context.read<NotificationsCubit>().loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: state.notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final notification = state.notifications[index];
          return _NotificationTile(
            notification: notification,
            onTap: () {
              context.read<NotificationsCubit>().markRead(notification.id);
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final NotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    final unread = !notification.isRead;
    final icon = _iconFor(notification.title);
    final iconColor = _iconColorFor(notification.title);

    return InkWell(
      onTap: unread ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: unread ? AppColors.darkSlate : AppColors.border,
            width: unread ? 1.6 : 1.2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withValues(alpha: 0.14),
              foregroundColor: iconColor,
              child: Icon(icon, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (unread)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkSlate,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            AppStrings.t('new', language),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      height: 1.35,
                    ),
                  ),
                  if (notification.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formattedTime(notification.createdAt!, language),
                      style: const TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('task')) {
      return Icons.assignment_turned_in_outlined;
    }
    if (lower.contains('message') || lower.contains('chat')) {
      return Icons.chat_bubble_outline;
    }
    if (lower.contains('approval') || lower.contains('review')) {
      return Icons.check_circle_outline;
    }
    if (lower.contains('error') || lower.contains('delay')) {
      return Icons.error_outline;
    }
    return Icons.notifications_none;
  }

  Color _iconColorFor(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('error') || lower.contains('delay')) {
      return AppColors.orange;
    }
    if (lower.contains('approval') || lower.contains('review')) {
      return const Color(0xFF22C55E);
    }
    if (lower.contains('message') || lower.contains('chat')) {
      return const Color(0xFFD946EF);
    }
    return const Color(0xFF3B82F6);
  }

  String _formattedTime(String value, String language) {
    final parsed = DateTime.tryParse(value)?.toLocal();
    if (parsed == null) {
      return value;
    }
    return DateFormat.yMMMd(language).add_Hm().format(parsed);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.text});

  final IconData icon;
  final String text;

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
        children: [
          Icon(icon, color: const Color(0xFFCBD5E1), size: 44),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
