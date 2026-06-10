import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/supervisor_summary_entity.dart';
import '../../domain/usecases/get_supervisor_summary_usecase.dart';

enum SupervisorStatus { initial, loading, loaded, failure }

class SupervisorState extends Equatable {
  const SupervisorState({
    this.status = SupervisorStatus.initial,
    this.summary,
    this.errorMessage,
  });

  final SupervisorStatus status;
  final SupervisorSummaryEntity? summary;
  final String? errorMessage;

  SupervisorState copyWith({
    SupervisorStatus? status,
    SupervisorSummaryEntity? summary,
    String? errorMessage,
  }) {
    return SupervisorState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage];
}

class SupervisorCubit extends Cubit<SupervisorState> {
  SupervisorCubit({required GetSupervisorSummaryUseCase getSummaryUseCase})
    : _getSummaryUseCase = getSummaryUseCase,
      super(const SupervisorState());

  final GetSupervisorSummaryUseCase _getSummaryUseCase;

  Future<void> loadSummary() async {
    emit(state.copyWith(status: SupervisorStatus.loading, errorMessage: null));
    final result = await _getSummaryUseCase();
    result.when(
      success: (summary) => emit(
        state.copyWith(
          status: SupervisorStatus.loaded,
          summary: summary,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: SupervisorStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
