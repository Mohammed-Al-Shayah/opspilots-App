import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';
import '../widgets/field_bottom_nav.dart';

class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({super.key});

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
            OpsHeader(
              title: AppStrings.t('liveMap', language),
              fallbackRoute: AppRoutes.home,
              action: OpsHeaderAction.outlined(
                label: AppStrings.t('filter', language),
                icon: Icons.filter_alt_outlined,
                onPressed: () {},
              ),
            ),
            const _MapPreview(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  Row(
                    children: [
                      Expanded(
                        child: _MetricTile(
                          value: '1',
                          label: 'Active',
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _MetricTile(
                          value: '3',
                          label: 'Field Team',
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _MetricTile(
                          value: '5',
                          label: 'Areas',
                          color: Color(0xFF9333EA),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26),
                  Text(
                    'Active Field Employees',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 18),
                  _EmployeeTile(
                    name: 'أحمد محمد',
                    location: 'شارع الملك فهد',
                    status: 'En Route',
                    color: Color(0xFF3B82F6),
                  ),
                  SizedBox(height: 14),
                  _EmployeeTile(
                    name: 'خالد العلي',
                    location: 'حي العليا',
                    status: 'Working',
                    color: Color(0xFF22C55E),
                  ),
                  SizedBox(height: 14),
                  _EmployeeTile(
                    name: 'محمد حسن',
                    location: 'شارع العروبة',
                    status: 'Arrived',
                    color: AppColors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.map),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 222,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDDF3FF), Color(0xFFDDFBEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Icon(Icons.location_on_outlined, color: Color(0xFF8D98A8), size: 86),
          Positioned(
            top: 58,
            left: 98,
            child: _MapPin(icon: Icons.navigation, color: Color(0xFF3B82F6)),
          ),
          Positioned(
            top: 90,
            right: 116,
            child: _MapPin(
              icon: Icons.location_on_outlined,
              color: Color(0xFF22C55E),
            ),
          ),
          Positioned(
            top: 130,
            right: 150,
            child: _MapPin(
              icon: Icons.location_on_outlined,
              color: AppColors.orange,
            ),
          ),
          Positioned(
            bottom: 52,
            child: Column(
              children: [
                Text(
                  'Map View',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 18),
                ),
                Text(
                  'Real-time tracking',
                  style: TextStyle(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white, size: 17),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Text(label, style: const TextStyle(color: AppColors.mutedText)),
        ],
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.name,
    required this.location,
    required this.status,
    required this.color,
  });

  final String name;
  final String location;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(Icons.groups_outlined, color: color),
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.mutedText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(color: AppColors.mutedText),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(status, style: TextStyle(color: color, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
