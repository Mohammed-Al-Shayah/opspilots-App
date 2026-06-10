import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';
import '../widgets/field_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 54),
              color: AppColors.darkSlate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.t('profile', language),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_outline,
                        color: AppColors.ink,
                        size: 58,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      'أحمد محمد',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Center(
                    child: Text(
                      'Field Employee',
                      style: TextStyle(color: Color(0xFFD7DEE8), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const _InfoCard(),
                    const SizedBox(height: 26),
                    _MenuCard(
                      children: [
                        const _MenuRow(
                          icon: Icons.person_outline,
                          label: 'Edit Profile',
                        ),
                        const _Divider(),
                        const _MenuRow(
                          icon: Icons.lock_outline,
                          label: 'Change Password',
                        ),
                        const _Divider(),
                        _MenuRow(
                          icon: Icons.notifications_none,
                          label: AppStrings.t('notifications', language),
                          onTap: () => context.push(AppRoutes.notifications),
                        ),
                        const _Divider(),
                        _MenuRow(
                          icon: Icons.language,
                          label: AppStrings.t('selectLanguage', language),
                          onTap: () => context.push(AppRoutes.language),
                        ),
                        const _Divider(),
                        _MenuRow(
                          icon: Icons.settings_outlined,
                          label: AppStrings.t('settings', language),
                          onTap: () => context.push(AppRoutes.settings),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.login),
                      icon: const Icon(Icons.logout, color: Color(0xFFE11D48)),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        foregroundColor: const Color(0xFFE11D48),
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(
        currentTab: FieldNavTab.profile,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          _InfoRow(
            icon: Icons.mail_outline,
            label: 'Email',
            value: 'mo@gmail.c',
          ),
          Divider(height: 1, color: AppColors.border),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: '+966501234567',
          ),
          Divider(height: 1, color: AppColors.border),
          _InfoRow(
            icon: Icons.business_outlined,
            label: 'Company',
            value: 'شركة الخدمات الميدانية',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.mutedText),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: AppColors.ink, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: AppColors.mutedText),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppColors.ink, fontSize: 17),
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
