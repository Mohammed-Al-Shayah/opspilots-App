import '../../domain/user_role.dart';

abstract class RoleLocalDataSource {
  Future<UserRole> getDefaultRole();

  Future<UserRole> saveSelectedRole(UserRole role);
}

class RoleLocalDataSourceImpl implements RoleLocalDataSource {
  RoleLocalDataSourceImpl();

  UserRole _selectedRole = UserRole.fieldEmployee;

  @override
  Future<UserRole> getDefaultRole() async => _selectedRole;

  @override
  Future<UserRole> saveSelectedRole(UserRole role) async {
    _selectedRole = role;
    return _selectedRole;
  }
}
