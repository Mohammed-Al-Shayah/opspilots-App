class LiveMapEntity {
  const LiveMapEntity({
    required this.active,
    required this.fieldTeam,
    required this.areas,
    required this.employees,
  });

  final int active;
  final int fieldTeam;
  final int areas;
  final List<FieldEmployeeLocationEntity> employees;
}

class FieldEmployeeLocationEntity {
  const FieldEmployeeLocationEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  final String id;
  final String name;
  final String status;
  final double? latitude;
  final double? longitude;
  final String locationName;
}
