import '../../../role/domain/user_role.dart';

class WorkspaceEntity {
  const WorkspaceEntity({
    required this.id,
    required this.companyId,
    required this.name,
    required this.industry,
    required this.location,
    required this.availableRoles,
    this.branchId,
    this.roleIds = const {},
    this.rawData = const {},
  });

  final String id;
  final int companyId;
  final int? branchId;
  final String name;
  final String industry;
  final String location;
  final List<UserRole> availableRoles;
  final Map<UserRole, int> roleIds;
  final Map<String, dynamic> rawData;

  int? roleIdFor(UserRole role) {
    return roleIds[role];
  }

  @override
  String toString() {
    return 'WorkspaceEntity(id: $id, companyId: $companyId, branchId: $branchId, '
        'name: $name, availableRoles: $availableRoles, roleIds: $roleIds, '
        'rawData: $rawData)';
  }
}
