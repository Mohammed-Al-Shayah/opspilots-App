import '../../../../core/utils/app_result.dart';
import '../datasources/role_local_datasource.dart';
import '../../domain/repositories/role_repository.dart';
import '../../domain/user_role.dart';

class RoleRepositoryImpl implements RoleRepository {
  const RoleRepositoryImpl({required RoleLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final RoleLocalDataSource _localDataSource;

  @override
  Future<AppResult<UserRole>> getDefaultRole() async {
    return AppResult.success(await _localDataSource.getDefaultRole());
  }

  @override
  Future<AppResult<UserRole>> saveSelectedRole(UserRole role) async {
    return AppResult.success(await _localDataSource.saveSelectedRole(role));
  }
}
