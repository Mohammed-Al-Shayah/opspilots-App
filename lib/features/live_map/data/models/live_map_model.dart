import '../../../../core/network/api_response_reader.dart';
import '../../domain/entities/live_map_entity.dart';

class LiveMapModel extends LiveMapEntity {
  const LiveMapModel({
    required super.active,
    required super.fieldTeam,
    required super.areas,
    required super.employees,
  });

  factory LiveMapModel.fromJson(Map<String, dynamic> json) {
    final employeesValue =
        json['employees'] ?? json['field_employees'] ?? json['locations'];
    final employees = ApiResponseReader.asList(employeesValue)
        .map(ApiResponseReader.asMap)
        .map(FieldEmployeeLocationModel.fromJson)
        .where((employee) => employee.id.isNotEmpty || employee.name.isNotEmpty)
        .toList();

    return LiveMapModel(
      active: _int(json['active'] ?? json['active_count']),
      fieldTeam: _int(
        json['field_team'] ?? json['fieldTeam'] ?? employees.length,
      ),
      areas: _int(json['areas'] ?? json['area_count']),
      employees: employees,
    );
  }

  static int _int(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class FieldEmployeeLocationModel extends FieldEmployeeLocationEntity {
  const FieldEmployeeLocationModel({
    required super.id,
    required super.name,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.locationName,
  });

  factory FieldEmployeeLocationModel.fromJson(Map<String, dynamic> json) {
    final user = ApiResponseReader.asMap(json['user'] ?? json['employee']);
    return FieldEmployeeLocationModel(
      id: (json['id'] ?? json['employee_id'] ?? user['id'] ?? '').toString(),
      name: (json['name'] ?? user['name'] ?? json['employee_name'] ?? '')
          .toString(),
      status: (json['status'] ?? json['state'] ?? '').toString(),
      latitude: _double(json['latitude'] ?? json['lat']),
      longitude: _double(json['longitude'] ?? json['lng'] ?? json['lon']),
      locationName:
          (json['location_name'] ??
                  json['location'] ??
                  json['address'] ??
                  user['location'] ??
                  '')
              .toString(),
    );
  }

  static double? _double(Object? value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '');
  }
}
