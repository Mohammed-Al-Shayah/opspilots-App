import '../../domain/entities/attendance_record_entity.dart';

class AttendanceRecordModel extends AttendanceRecordEntity {
  const AttendanceRecordModel({
    required super.id,
    super.checkedInAt,
    super.checkedOutAt,
    super.latitude,
    super.longitude,
    super.notes,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id']?.toString() ?? '',
      checkedInAt:
          json['checked_in_at']?.toString() ?? json['check_in_at']?.toString(),
      checkedOutAt:
          json['checked_out_at']?.toString() ??
          json['check_out_at']?.toString(),
      latitude: _doubleValue(json['latitude']),
      longitude: _doubleValue(json['longitude']),
      notes: json['notes']?.toString(),
    );
  }

  static double? _doubleValue(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '');
  }
}
