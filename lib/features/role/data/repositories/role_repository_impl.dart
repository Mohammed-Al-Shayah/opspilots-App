import '../../../../core/utils/app_result.dart';
import '../../domain/repositories/role_repository.dart';
import '../../domain/user_role.dart';

class RoleRepositoryImpl implements RoleRepository {
  RoleRepositoryImpl();

  UserRole _selectedRole = UserRole.fieldEmployee;

  @override
  Future<AppResult<UserRole>> getDefaultRole() async {
    return AppResult.success(_selectedRole);
  }

  @override
  Future<AppResult<UserRole>> saveSelectedRole(UserRole role) async {
    _selectedRole = role;
    return AppResult.success(role);
  }
}
