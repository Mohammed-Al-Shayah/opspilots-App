import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_result.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/usecases/export_reports_usecase.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import '../../domain/usecases/get_reports_overview_usecase.dart';

enum OperationsStatus { initial, loading, loaded, failure, exporting }

class OperationsState extends Equatable {
  const OperationsState({
    this.status = OperationsStatus.initial,
    this.dashboard,
    this.reports,
    this.errorMessage,
    this.exportedBytes,
  });

  final OperationsStatus status;
  final DashboardSummaryEntity? dashboard;
  final DashboardSummaryEntity? reports;
  final String? errorMessage;
  final int? exportedBytes;

  OperationsState copyWith({
    OperationsStatus? status,
    DashboardSummaryEntity? dashboard,
    DashboardSummaryEntity? reports,
    String? errorMessage,
    int? exportedBytes,
  }) {
    return OperationsState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      reports: reports ?? this.reports,
      errorMessage: errorMessage,
      exportedBytes: exportedBytes,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dashboard,
    reports,
    errorMessage,
    exportedBytes,
  ];
}

class OperationsCubit extends Cubit<OperationsState> {
  OperationsCubit({
    required GetDashboardUseCase getDashboardUseCase,
    required GetReportsOverviewUseCase getReportsOverviewUseCase,
    required ExportAttendanceCsvUseCase exportAttendanceCsvUseCase,
    required ExportAuditLogsCsvUseCase exportAuditLogsCsvUseCase,
  }) : _getDashboardUseCase = getDashboardUseCase,
       _getReportsOverviewUseCase = getReportsOverviewUseCase,
       _exportAttendanceCsvUseCase = exportAttendanceCsvUseCase,
       _exportAuditLogsCsvUseCase = exportAuditLogsCsvUseCase,
       super(const OperationsState());

  final GetDashboardUseCase _getDashboardUseCase;
  final GetReportsOverviewUseCase _getReportsOverviewUseCase;
  final ExportAttendanceCsvUseCase _exportAttendanceCsvUseCase;
  final ExportAuditLogsCsvUseCase _exportAuditLogsCsvUseCase;

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: OperationsStatus.loading, errorMessage: null));
    final result = await _getDashboardUseCase();
    result.when(
      success: (dashboard) => emit(
        state.copyWith(
          status: OperationsStatus.loaded,
          dashboard: dashboard,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: OperationsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadReports() async {
    emit(state.copyWith(status: OperationsStatus.loading, errorMessage: null));
    final result = await _getReportsOverviewUseCase();
    result.when(
      success: (reports) => emit(
        state.copyWith(
          status: OperationsStatus.loaded,
          reports: reports,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: OperationsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> exportAttendanceCsv() async {
    await _export(_exportAttendanceCsvUseCase.call);
  }

  Future<void> exportAuditLogsCsv() async {
    await _export(_exportAuditLogsCsvUseCase.call);
  }

  Future<void> _export(Future<AppResult<List<int>>> Function() request) async {
    emit(state.copyWith(status: OperationsStatus.exporting));
    final result = await request();
    result.when(
      success: (bytes) => emit(
        state.copyWith(
          status: OperationsStatus.loaded,
          exportedBytes: bytes.length,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: OperationsStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
