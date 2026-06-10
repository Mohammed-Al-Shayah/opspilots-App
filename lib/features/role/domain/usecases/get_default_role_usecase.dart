import '../../../../core/utils/app_result.dart';
import '../repositories/role_repository.dart';
import '../user_role.dart';

class GetDefaultRoleUseCase {
  const GetDefaultRoleUseCase(this._repository);

  final RoleRepository _repository;

  Future<AppResult<UserRole>> call() {
    return _repository.getDefaultRole();
  }
}
