class AttendanceRecordEntity {
  const AttendanceRecordEntity({
    required this.id,
    this.checkedInAt,
    this.checkedOutAt,
    this.latitude,
    this.longitude,
    this.notes,
  });

  final String id;
  final String? checkedInAt;
  final String? checkedOutAt;
  final double? latitude;
  final double? longitude;
  final String? notes;
}
