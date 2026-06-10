import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AppMapPreview extends StatelessWidget {
  const AppMapPreview({
    required this.locationName,
    required this.address,
    super.key,
  });

  final String locationName;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.map_outlined, color: Colors.white24, size: 72),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationName,
                  style: AppTextStyles.title.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  address,
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
