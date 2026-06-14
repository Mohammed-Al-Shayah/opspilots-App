enum UserRole { fieldEmployee, supervisor, operationsManager, client }

extension UserRoleX on UserRole {
  String get apiValue {
    switch (this) {
      case UserRole.fieldEmployee:
        return 'field_employee';
      case UserRole.supervisor:
        return 'supervisor';
      case UserRole.operationsManager:
        return 'operations_manager';
      case UserRole.client:
        return 'client';
    }
  }

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
