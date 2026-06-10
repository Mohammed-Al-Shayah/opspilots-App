import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../cubit/language_cubit.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OpsHeader(
              title: AppStrings.t('settings', language),
              fallbackRoute: AppRoutes.profile,
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _SettingsCard(
                    children: const [
                      _SwitchRow(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        subtitle: 'Enable push notifications',
                        value: true,
                      ),
                      _Divider(),
                      _SwitchRow(
                        icon: Icons.location_on_outlined,
                        title: 'Location Access',
                        subtitle: 'Required for check-in',
                        value: true,
                      ),
                      _Divider(),
                      _SwitchRow(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Switch to dark theme',
                        value: false,
                      ),
                      _Divider(),
                      _SwitchRow(
                        icon: Icons.fingerprint,
                        title: 'Biometric Login',
                        subtitle: 'Use fingerprint or face ID',
                        value: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SettingsCard(
                    children: [
                      _ArrowRow(
                        icon: Icons.language,
                        title: AppStrings.t('selectLanguage', language),
                        subtitle: AppStrings.t(
                          language == 'ar' ? 'arabic' : 'english',
                          language,
                        ),
                        onTap: () => context.push(AppRoutes.language),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _SettingsCard(
                    children: [
                      _ArrowRow(
                        icon: Icons.info_outline,
                        title: 'About OpsPilot',
                        subtitle: 'Version 1.0.0',
                      ),
                    ],
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

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Icon(icon, color: AppColors.mutedText, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.ink, fontSize: 18),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: (_) {}),
        ],
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  const _ArrowRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon, color: AppColors.mutedText, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: AppColors.ink, fontSize: 18),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.mutedText),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.border);
  }
}
