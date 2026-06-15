import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/live_map_entity.dart';
import '../../domain/usecases/get_live_map_usecase.dart';

enum LiveMapStatus { initial, loading, loaded, empty, failure }

class LiveMapState extends Equatable {
  const LiveMapState({
    this.status = LiveMapStatus.initial,
    this.summary,
    this.errorMessage,
  });

  final LiveMapStatus status;
  final LiveMapEntity? summary;
  final String? errorMessage;

  LiveMapState copyWith({
    LiveMapStatus? status,
    LiveMapEntity? summary,
    String? errorMessage,
  }) {
    return LiveMapState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage];
}

class LiveMapCubit extends Cubit<LiveMapState> {
  LiveMapCubit({required GetLiveMapUseCase getLiveMapUseCase})
    : _getLiveMapUseCase = getLiveMapUseCase,
      super(const LiveMapState());

  final GetLiveMapUseCase _getLiveMapUseCase;

  Future<void> loadLiveMap() async {
    emit(state.copyWith(status: LiveMapStatus.loading, errorMessage: null));

    final result = await _getLiveMapUseCase();
    result.when(
      success: (summary) => emit(
        state.copyWith(
          status: summary.employees.isEmpty
              ? LiveMapStatus.empty
              : LiveMapStatus.loaded,
          summary: summary,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: LiveMapStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
