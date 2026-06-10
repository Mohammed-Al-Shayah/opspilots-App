import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../cubit/language_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            OpsHeader(
              title: AppStrings.t('notifications', language),
              fallbackRoute: AppRoutes.profile,
              action: OpsHeaderAction.text(
                label: AppStrings.t('markAllRead', language),
                onPressed: () {},
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  _NotificationTile(
                    icon: Icons.assignment_turned_in_outlined,
                    iconColor: Color(0xFF3B82F6),
                    title: 'New task assigned',
                    text: 'صيانة نظام التكييف - شركة النجاح التجارية',
                    time: '10 min ago',
                    unread: true,
                    emphasized: true,
                  ),
                  SizedBox(height: 10),
                  _NotificationTile(
                    icon: Icons.error_outline,
                    iconColor: AppColors.orange,
                    title: 'Task status changed',
                    text: 'Status: In - تركيب كاميرات مراقبة\nProgress',
                    time: '1 hour ago',
                    unread: true,
                    emphasized: true,
                  ),
                  SizedBox(height: 10),
                  _NotificationTile(
                    icon: Icons.check_circle_outline,
                    iconColor: Color(0xFF22C55E),
                    title: 'Approval needed',
                    text: 'Ready for review - فحص أنظمة الإنذار',
                    time: '2 hours ago',
                  ),
                  SizedBox(height: 10),
                  _NotificationTile(
                    icon: Icons.chat_bubble_outline,
                    iconColor: Color(0xFFD946EF),
                    title: 'New message',
                    text: 'المشرف: رائع، استمر بالعمل الجيد',
                    time: '3 hours ago',
                  ),
                  SizedBox(height: 10),
                  _NotificationTile(
                    icon: Icons.person_outline,
                    iconColor: Color(0xFF9CA3AF),
                    title: 'System announcement',
                    text: 'PM 10:00 - تحديث الصيانة المجدولة الأحد',
                    time: 'Yesterday',
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

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.text,
    required this.time,
    this.unread = false,
    this.emphasized = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String text;
  final String time;
  final bool unread;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: emphasized ? AppColors.darkSlate : AppColors.border,
          width: emphasized ? 1.6 : 1.2,
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
                        title,
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
                        child: const Text(
                          'New',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
