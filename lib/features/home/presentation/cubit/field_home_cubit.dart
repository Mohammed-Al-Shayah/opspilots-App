import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/field_home_summary_entity.dart';
import '../../domain/usecases/get_field_home_summary_usecase.dart';

enum FieldHomeStatus { initial, loading, loaded, failure }

class FieldHomeState extends Equatable {
  const FieldHomeState({
    this.status = FieldHomeStatus.initial,
    this.summary,
    this.errorMessage,
  });

  final FieldHomeStatus status;
  final FieldHomeSummaryEntity? summary;
  final String? errorMessage;

  FieldHomeState copyWith({
    FieldHomeStatus? status,
    FieldHomeSummaryEntity? summary,
    String? errorMessage,
  }) {
    return FieldHomeState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage];
}

class FieldHomeCubit extends Cubit<FieldHomeState> {
  FieldHomeCubit({required GetFieldHomeSummaryUseCase getSummaryUseCase})
    : _getSummaryUseCase = getSummaryUseCase,
      super(const FieldHomeState());

  final GetFieldHomeSummaryUseCase _getSummaryUseCase;

  Future<void> loadSummary() async {
    emit(state.copyWith(status: FieldHomeStatus.loading, errorMessage: null));
    final result = await _getSummaryUseCase();
    result.when(
      success: (summary) => emit(
        state.copyWith(
          status: FieldHomeStatus.loaded,
          summary: summary,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: FieldHomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
