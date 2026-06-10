import '../../../role/domain/user_role.dart';

class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.defaultRole,
  });

  final String id;
  final String name;
  final String email;
  final UserRole defaultRole;
}
