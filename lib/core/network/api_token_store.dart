import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiTokenStore {
  ApiTokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _authTokenKey = 'auth_token';
  static const _workspaceTokenKey = 'workspace_token';
  static const _workspaceIdKey = 'workspace_id';
  static const _loginWorkspacesKey = 'login_workspaces';

  final FlutterSecureStorage _storage;

  Future<String?> readAuthToken() => _storage.read(key: _authTokenKey);

  Future<String?> readWorkspaceToken() =>
      _storage.read(key: _workspaceTokenKey);

  Future<String?> readWorkspaceId() => _storage.read(key: _workspaceIdKey);

  Future<List<dynamic>> readLoginWorkspaces() async {
    final value = await _storage.read(key: _loginWorkspacesKey);
    if (value == null || value.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(value);
    if (decoded is List) {
      return decoded;
    }
    return const [];
  }

  Future<String?> readActiveToken() async {
    return await readWorkspaceToken() ?? await readAuthToken();
  }

  Future<void> saveAuthToken(String token) {
    return _storage.write(key: _authTokenKey, value: token);
  }

  Future<void> saveWorkspaceToken(String token) {
    return _storage.write(key: _workspaceTokenKey, value: token);
  }

  Future<void> saveWorkspaceId(String workspaceId) {
    return _storage.write(key: _workspaceIdKey, value: workspaceId);
  }

  Future<void> saveLoginWorkspaces(List<dynamic> workspaces) {
    return _storage.write(
      key: _loginWorkspacesKey,
      value: jsonEncode(workspaces),
    );
  }

  Future<void> clearWorkspace() async {
    await _storage.delete(key: _workspaceTokenKey);
    await _storage.delete(key: _workspaceIdKey);
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _authTokenKey);
    await _storage.delete(key: _loginWorkspacesKey);
    await clearWorkspace();
  }
}
