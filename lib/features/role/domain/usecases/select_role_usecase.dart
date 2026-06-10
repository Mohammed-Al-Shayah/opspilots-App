import '../../../../core/utils/app_result.dart';
import '../repositories/role_repository.dart';
import '../user_role.dart';

class SelectRoleUseCase {
  const SelectRoleUseCase(this._repository);

  final RoleRepository _repository;

  Future<AppResult<UserRole>> call(UserRole role) {
    return _repository.saveSelectedRole(role);
  }
}
