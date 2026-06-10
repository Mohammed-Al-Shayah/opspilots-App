import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AppTimelineItem {
  const AppTimelineItem({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
  });

  final String title;
  final String subtitle;
  final bool isCompleted;
}

class AppTimeline extends StatelessWidget {
  const AppTimeline({required this.items, super.key});

  final List<AppTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: item.isCompleted
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: AppTextStyles.body),
                    const SizedBox(height: 2),
                    Text(item.subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
