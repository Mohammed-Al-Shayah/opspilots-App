enum UserRole { fieldEmployee, supervisor, operationsManager, client }

extension UserRoleX on UserRole {
  String get labelEn {
    switch (this) {
      case UserRole.fieldEmployee:
        return 'Field Employee';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.operationsManager:
        return 'Operations Manager';
      case UserRole.client:
        return 'Client';
    }
  }

  String get labelAr {
    switch (this) {
      case UserRole.fieldEmployee:
        return 'موظف ميداني';
      case UserRole.supervisor:
        return 'مشرف';
      case UserRole.operationsManager:
        return 'مدير العمليات';
      case UserRole.client:
        return 'عميل';
    }
  }
}
