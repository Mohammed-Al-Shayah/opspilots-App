import '../../../role/domain/user_role.dart';
import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.defaultRole,
  });

  factory AuthUserModel.fromJson(
    Map<String, dynamic> json, {
    required String fallbackEmail,
  }) {
    final email = json['email']?.toString() ?? fallbackEmail;
    return AuthUserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? email,
      email: email,
      defaultRole: _roleFromJson(json),
    );
  }

  static UserRole _roleFromJson(Map<String, dynamic> json) {
    final roleValue = json['role'] ?? json['default_role'] ?? json['type'];
    final role = roleValue.toString().toLowerCase().replaceAll('-', '_');

    if (role.contains('supervisor')) {
      return UserRole.supervisor;
    }
    if (role.contains('operations') || role.contains('manager')) {
      return UserRole.operationsManager;
    }
    if (role.contains('client')) {
      return UserRole.client;
    }
    return UserRole.fieldEmployee;
  }
}
