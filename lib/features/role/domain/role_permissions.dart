import 'user_role.dart';

enum AppModule {
  home,
  tasks,
  map,
  attendance,
  chat,
  profile,
  reviews,
  team,
  tickets,
  reports,
  operations,
  aiCenter,
  approvals,
  requests,
}

class RolePermissions {
  const RolePermissions._();

  static bool canAccessModule(UserRole role, AppModule module) {
    return modulesFor(role).contains(module);
  }

  static List<AppModule> modulesFor(UserRole role) {
    switch (role) {
      case UserRole.fieldEmployee:
        return const [
          AppModule.home,
          AppModule.tasks,
          AppModule.map,
          AppModule.attendance,
          AppModule.chat,
          AppModule.profile,
        ];
      case UserRole.supervisor:
        return const [
          AppModule.home,
          AppModule.reviews,
          AppModule.team,
          AppModule.map,
          AppModule.tickets,
          AppModule.reports,
          AppModule.profile,
        ];
      case UserRole.operationsManager:
        return const [
          AppModule.home,
          AppModule.operations,
          AppModule.map,
          AppModule.reports,
          AppModule.aiCenter,
          AppModule.approvals,
          AppModule.profile,
        ];
      case UserRole.client:
        return const [
          AppModule.home,
          AppModule.requests,
          AppModule.tickets,
          AppModule.chat,
          AppModule.profile,
        ];
    }
  }
}
