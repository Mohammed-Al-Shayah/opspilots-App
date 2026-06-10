import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../role/domain/user_role.dart';
import '../../../role/presentation/cubit/role_cubit.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';

enum FieldNavTab {
  home,
  tasks,
  reviews,
  team,
  reports,
  aiCenter,
  map,
  chat,
  profile,
}

class FieldBottomNav extends StatelessWidget {
  const FieldBottomNav({required this.currentTab, super.key});

  final FieldNavTab currentTab;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    final role = context.watch<RoleCubit>().state.selectedRole;
    final tabs = _tabsFor(role);
    final selectedIndex = tabs.indexOf(currentTab);

    return BottomNavigationBar(
      currentIndex: selectedIndex < 0 ? 0 : selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.ink,
      unselectedItemColor: AppColors.mutedText,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 0,
      onTap: (index) => _goToTab(context, tabs[index], role),
      items: tabs.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(_iconFor(tab)),
          label: _labelFor(tab, language, role),
        );
      }).toList(),
    );
  }

  void _goToTab(BuildContext context, FieldNavTab tab, UserRole role) {
    switch (tab) {
      case FieldNavTab.home:
        context.go(AppRoutes.home);
      case FieldNavTab.tasks:
        context.go(
          role == UserRole.supervisor
              ? AppRoutes.supervisorTeamTasks
              : AppRoutes.tasks,
        );
      case FieldNavTab.reviews:
        context.go(AppRoutes.supervisorReviews);
      case FieldNavTab.team:
        context.go(AppRoutes.supervisorTeam);
      case FieldNavTab.reports:
        context.go(AppRoutes.operationsReports);
      case FieldNavTab.aiCenter:
        context.go(AppRoutes.operationsAiCenter);
      case FieldNavTab.map:
        context.go(AppRoutes.liveMap);
      case FieldNavTab.chat:
        context.go(AppRoutes.chat);
      case FieldNavTab.profile:
        context.go(AppRoutes.profile);
    }
  }

  List<FieldNavTab> _tabsFor(UserRole role) {
    switch (role) {
      case UserRole.supervisor:
        return const [
          FieldNavTab.home,
          FieldNavTab.tasks,
          FieldNavTab.reviews,
          FieldNavTab.team,
          FieldNavTab.profile,
        ];
      case UserRole.operationsManager:
        return const [
          FieldNavTab.home,
          FieldNavTab.reports,
          FieldNavTab.map,
          FieldNavTab.aiCenter,
          FieldNavTab.profile,
        ];
      case UserRole.fieldEmployee:
      case UserRole.client:
        return const [
          FieldNavTab.home,
          FieldNavTab.tasks,
          FieldNavTab.map,
          FieldNavTab.chat,
          FieldNavTab.profile,
        ];
    }
  }

  IconData _iconFor(FieldNavTab tab) {
    switch (tab) {
      case FieldNavTab.home:
        return Icons.home_outlined;
      case FieldNavTab.tasks:
        return Icons.assignment_outlined;
      case FieldNavTab.reviews:
        return Icons.fact_check_outlined;
      case FieldNavTab.team:
        return Icons.groups_outlined;
      case FieldNavTab.reports:
        return Icons.bar_chart_outlined;
      case FieldNavTab.aiCenter:
        return Icons.auto_awesome_outlined;
      case FieldNavTab.map:
        return Icons.location_on_outlined;
      case FieldNavTab.chat:
        return Icons.chat_bubble_outline;
      case FieldNavTab.profile:
        return Icons.person_outline;
    }
  }

  String _labelFor(FieldNavTab tab, String language, UserRole role) {
    switch (tab) {
      case FieldNavTab.home:
        return role == UserRole.operationsManager
            ? (language == 'ar' ? 'لوحة التحكم' : 'Dashboard')
            : AppStrings.t('home', language);
      case FieldNavTab.tasks:
        if (role == UserRole.supervisor) {
          return language == 'ar' ? 'مهام الفريق' : 'Team Tasks';
        }
        return AppStrings.t('myTasks', language);
      case FieldNavTab.reviews:
        return language == 'ar' ? 'المراجعات' : 'Reviews';
      case FieldNavTab.team:
        return language == 'ar' ? 'الفريق' : 'Team';
      case FieldNavTab.reports:
        return language == 'ar' ? 'التقارير' : 'Reports';
      case FieldNavTab.aiCenter:
        return language == 'ar' ? 'مركز الذكاء' : 'AI Center';
      case FieldNavTab.map:
        return AppStrings.t('map', language);
      case FieldNavTab.chat:
        return AppStrings.t('chat', language);
      case FieldNavTab.profile:
        return AppStrings.t('profile', language);
    }
  }
}
