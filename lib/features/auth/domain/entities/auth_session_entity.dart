import 'auth_user_entity.dart';

class AuthSessionEntity {
  const AuthSessionEntity({required this.user, required this.token});

  final AuthUserEntity user;
  final String token;
}
