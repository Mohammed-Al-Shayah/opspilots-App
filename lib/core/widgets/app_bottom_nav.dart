import 'package:flutter/material.dart';

import '../../features/role/domain/role_permissions.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.modules,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<AppModule> modules;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex.clamp(0, modules.length - 1).toInt(),
      onDestinationSelected: onTap,
      destinations: modules.map((module) {
        return NavigationDestination(
          icon: Icon(_iconFor(module)),
          label: _labelFor(module),
        );
      }).toList(),
    );
  }

  IconData _iconFor(AppModule module) {
    switch (module) {
      case AppModule.home:
        return Icons.dashboard_outlined;
      case AppModule.tasks:
      case AppModule.reviews:
      case AppModule.requests:
      case AppModule.approvals:
        return Icons.assignment_outlined;
      case AppModule.map:
        return Icons.map_outlined;
      case AppModule.attendance:
      case AppModule.team:
        return Icons.groups_outlined;
      case AppModule.chat:
      case AppModule.tickets:
        return Icons.forum_outlined;
      case AppModule.profile:
        return Icons.person_outline;
      case AppModule.reports:
      case AppModule.operations:
        return Icons.analytics_outlined;
      case AppModule.aiCenter:
        return Icons.auto_awesome_outlined;
    }
  }

  String _labelFor(AppModule module) {
    switch (module) {
      case AppModule.home:
        return 'Home';
      case AppModule.tasks:
        return 'Tasks';
      case AppModule.map:
        return 'Map';
      case AppModule.attendance:
        return 'Attendance';
      case AppModule.chat:
        return 'Chat';
      case AppModule.profile:
        return 'Profile';
      case AppModule.reviews:
        return 'Reviews';
      case AppModule.team:
        return 'Team';
      case AppModule.tickets:
        return 'Tickets';
      case AppModule.reports:
        return 'Reports';
      case AppModule.operations:
        return 'Ops';
      case AppModule.aiCenter:
        return 'AI';
      case AppModule.approvals:
        return 'Approvals';
      case AppModule.requests:
        return 'Requests';
    }
  }
}
