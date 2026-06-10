import '../../../../core/network/api_response_reader.dart';
import '../../../role/domain/user_role.dart';
import '../../domain/entities/workspace_entity.dart';

class WorkspaceModel extends WorkspaceEntity {
  const WorkspaceModel({
    required super.id,
    required super.companyId,
    required super.name,
    required super.industry,
    required super.location,
    required super.availableRoles,
    super.branchId,
    super.roleIds,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    final company = ApiResponseReader.asMap(json['company']);
    final branch = ApiResponseReader.asMap(json['branch']);
    final companyId =
        _intValue(json['company_id']) ??
        _intValue(company['id']) ??
        _intValue(json['id']);

    if (companyId == null) {
      throw const FormatException('Workspace response is missing company id.');
    }

    final roles = _rolesFromJson(json);
    return WorkspaceModel(
      id: (json['id'] ?? companyId).toString(),
      companyId: companyId,
      branchId: _intValue(json['branch_id']) ?? _intValue(branch['id']),
      name:
          json['name']?.toString() ??
          company['name']?.toString() ??
          'Workspace $companyId',
      industry:
          json['industry']?.toString() ??
          company['industry']?.toString() ??
          'Operations',
      location:
          json['location']?.toString() ??
          branch['city']?.toString() ??
          company['address']?.toString() ??
          '',
      availableRoles: roles.keys.toList(),
      roleIds: roles,
    );
  }

  static Map<UserRole, int> _rolesFromJson(Map<String, dynamic> json) {
    final roleItems = ApiResponseReader.asList(
      json['roles'] ?? json['available_roles'] ?? json['user_roles'],
    );
    final roles = <UserRole, int>{};

    for (final item in roleItems) {
      final roleMap = ApiResponseReader.asMap(item);
      final role = _roleFromValue(
        roleMap['key'] ??
            roleMap['slug'] ??
            roleMap['name'] ??
            roleMap['label'] ??
            item,
      );
      if (role != null) {
        roles[role] =
            _intValue(roleMap['id'] ?? roleMap['role_id']) ?? role.index + 1;
      }
    }

    if (roles.isEmpty) {
      final role = _roleFromValue(json['role'] ?? json['type']);
      if (role != null) {
        roles[role] = _intValue(json['role_id']) ?? role.index + 1;
      }
    }

    return roles.isEmpty
        ? {UserRole.fieldEmployee: UserRole.fieldEmployee.index + 1}
        : roles;
  }

  static UserRole? _roleFromValue(Object? value) {
    final role = value.toString().toLowerCase().replaceAll('-', '_');
    if (role.contains('field') || role.contains('employee')) {
      return UserRole.fieldEmployee;
    }
    if (role.contains('supervisor')) {
      return UserRole.supervisor;
    }
    if (role.contains('operations') || role.contains('manager')) {
      return UserRole.operationsManager;
    }
    if (role.contains('client')) {
      return UserRole.client;
    }
    return null;
  }

  static int? _intValue(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }
}
