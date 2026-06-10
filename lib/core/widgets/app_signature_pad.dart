import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AppSignaturePad extends StatelessWidget {
  const AppSignaturePad({super.key, this.label = 'Client signature'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(child: Text(label, style: AppTextStyles.caption)),
    );
  }
}
