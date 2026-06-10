import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';
import '../../domain/user_role.dart';
import '../cubit/role_cubit.dart';

class RolePreviewScreen extends StatelessWidget {
  const RolePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    final selectedRole = context.watch<RoleCubit>().state.selectedRole;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              AppStrings.t('rolePreviewTitle', language),
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.t('rolePreviewSubtitle', language),
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ...UserRole.values.map((role) {
              final isSelected = role == selectedRole;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  onTap: () => context.read<RoleCubit>().selectRole(role),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? AppColors.teal
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          language == 'ar' ? role.labelAr : role.labelEn,
                          style: AppTextStyles.title,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            AppButton(
              label: AppStrings.t('continue', language),
              icon: Icons.arrow_forward,
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }
}
