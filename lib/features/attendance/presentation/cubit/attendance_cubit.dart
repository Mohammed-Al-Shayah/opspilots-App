import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/attendance_record_entity.dart';
import '../../domain/usecases/check_attendance_usecase.dart';
import '../../domain/usecases/get_my_attendance_usecase.dart';

enum AttendanceStatus {
  initial,
  loading,
  loaded,
  empty,
  failure,
  actionLoading,
}

class AttendanceState extends Equatable {
  const AttendanceState({
    this.status = AttendanceStatus.initial,
    this.records = const [],
    this.activeRecord,
    this.errorMessage,
  });

  final AttendanceStatus status;
  final List<AttendanceRecordEntity> records;
  final AttendanceRecordEntity? activeRecord;
  final String? errorMessage;

  bool get isCheckedIn => activeRecord != null;

  AttendanceState copyWith({
    AttendanceStatus? status,
    List<AttendanceRecordEntity>? records,
    AttendanceRecordEntity? activeRecord,
    bool clearActiveRecord = false,
    String? errorMessage,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      records: records ?? this.records,
      activeRecord: clearActiveRecord
          ? null
          : activeRecord ?? this.activeRecord,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, records, activeRecord, errorMessage];
}

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit({
    required GetMyAttendanceUseCase getMyAttendanceUseCase,
    required CheckInUseCase checkInUseCase,
    required CheckOutUseCase checkOutUseCase,
  }) : _getMyAttendanceUseCase = getMyAttendanceUseCase,
       _checkInUseCase = checkInUseCase,
       _checkOutUseCase = checkOutUseCase,
       super(const AttendanceState());

  final GetMyAttendanceUseCase _getMyAttendanceUseCase;
  final CheckInUseCase _checkInUseCase;
  final CheckOutUseCase _checkOutUseCase;

  Future<void> loadAttendance() async {
    emit(state.copyWith(status: AttendanceStatus.loading, errorMessage: null));

    final result = await _getMyAttendanceUseCase();
    result.when(
      success: (records) => _emitRecords(records),
      failure: (failure) => emit(
        state.copyWith(
          status: AttendanceStatus.failure,
          records: const [],
          clearActiveRecord: true,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<bool> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    emit(
      state.copyWith(
        status: AttendanceStatus.actionLoading,
        errorMessage: null,
      ),
    );

    final result = await _checkInUseCase(
      AttendanceLocationParams(latitude: latitude, longitude: longitude),
    );

    return result.when(
      success: (record) async {
        if (record != null) {
          _emitRecords([record, ...state.records]);
        } else {
          await loadAttendance();
        }
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: _loadedStatus(state.records),
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> checkOut({
    required double latitude,
    required double longitude,
  }) async {
    emit(
      state.copyWith(
        status: AttendanceStatus.actionLoading,
        errorMessage: null,
      ),
    );

    final result = await _checkOutUseCase(
      AttendanceLocationParams(latitude: latitude, longitude: longitude),
    );

    return result.when(
      success: (record) async {
        if (record != null) {
          final updatedRecords = _replaceOrPrepend(record, state.records);
          _emitRecords(updatedRecords);
        } else {
          await loadAttendance();
        }
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: _loadedStatus(state.records),
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  void _emitRecords(List<AttendanceRecordEntity> records) {
    final sorted = [...records]..sort(_compareNewestFirst);
    emit(
      state.copyWith(
        status: _loadedStatus(sorted),
        records: sorted,
        activeRecord: _activeRecord(sorted),
        clearActiveRecord: _activeRecord(sorted) == null,
        errorMessage: null,
      ),
    );
  }

  AttendanceRecordEntity? _activeRecord(List<AttendanceRecordEntity> records) {
    for (final record in records) {
      if (record.checkedInAt != null && record.checkedOutAt == null) {
        return record;
      }
    }
    return null;
  }

  List<AttendanceRecordEntity> _replaceOrPrepend(
    AttendanceRecordEntity record,
    List<AttendanceRecordEntity> records,
  ) {
    var replaced = false;
    final nextRecords = records.map((current) {
      if (current.id == record.id) {
        replaced = true;
        return record;
      }
      return current;
    }).toList();

    if (!replaced) {
      nextRecords.insert(0, record);
    }
    return nextRecords;
  }

  int _compareNewestFirst(
    AttendanceRecordEntity left,
    AttendanceRecordEntity right,
  ) {
    final leftDate = DateTime.tryParse(left.checkedInAt ?? '');
    final rightDate = DateTime.tryParse(right.checkedInAt ?? '');
    if (leftDate == null && rightDate == null) {
      return 0;
    }
    if (leftDate == null) {
      return 1;
    }
    if (rightDate == null) {
      return -1;
    }
    return rightDate.compareTo(leftDate);
  }

  AttendanceStatus _loadedStatus(List<AttendanceRecordEntity> records) {
    return records.isEmpty ? AttendanceStatus.empty : AttendanceStatus.loaded;
  }
}
