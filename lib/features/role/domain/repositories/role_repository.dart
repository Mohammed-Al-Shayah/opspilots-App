import '../../../../core/utils/app_result.dart';
import '../user_role.dart';

abstract class RoleRepository {
  Future<AppResult<UserRole>> getDefaultRole();

  Future<AppResult<UserRole>> saveSelectedRole(UserRole role);
}
