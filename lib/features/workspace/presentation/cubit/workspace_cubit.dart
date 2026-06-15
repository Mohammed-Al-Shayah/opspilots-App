import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../role/domain/user_role.dart';
import '../../domain/entities/workspace_entity.dart';
import '../../domain/usecases/get_workspaces_usecase.dart';
import '../../domain/usecases/select_workspace_usecase.dart';

enum WorkspaceStatus { initial, loading, loaded, selecting, empty, failure }

class WorkspaceState extends Equatable {
  const WorkspaceState({
    this.status = WorkspaceStatus.initial,
    this.workspaces = const [],
    this.selectedWorkspace,
    this.errorMessage,
  });

  final WorkspaceStatus status;
  final List<WorkspaceEntity> workspaces;
  final WorkspaceEntity? selectedWorkspace;
  final String? errorMessage;

  WorkspaceState copyWith({
    WorkspaceStatus? status,
    List<WorkspaceEntity>? workspaces,
    WorkspaceEntity? selectedWorkspace,
    String? errorMessage,
  }) {
    return WorkspaceState(
      status: status ?? this.status,
      workspaces: workspaces ?? this.workspaces,
      selectedWorkspace: selectedWorkspace ?? this.selectedWorkspace,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    workspaces,
    selectedWorkspace,
    errorMessage,
  ];
}

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit({
    required GetWorkspacesUseCase getWorkspacesUseCase,
    required SelectWorkspaceUseCase selectWorkspaceUseCase,
  }) : _getWorkspacesUseCase = getWorkspacesUseCase,
       _selectWorkspaceUseCase = selectWorkspaceUseCase,
       super(const WorkspaceState());

  final GetWorkspacesUseCase _getWorkspacesUseCase;
  final SelectWorkspaceUseCase _selectWorkspaceUseCase;

  Future<void> loadWorkspaces() async {
    emit(
      state.copyWith(
        status: WorkspaceStatus.loading,
        errorMessage: null,
        selectedWorkspace: null,
      ),
    );

    final result = await _getWorkspacesUseCase();
    result.when(
      success: (workspaces) {
        emit(
          state.copyWith(
            status: workspaces.isEmpty
                ? WorkspaceStatus.empty
                : WorkspaceStatus.loaded,
            workspaces: workspaces,
            selectedWorkspace:
                workspaces.length == 1 &&
                    workspaces.first.availableRoles.isNotEmpty
                ? workspaces.first
                : null,
            errorMessage: null,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: WorkspaceStatus.failure,
            workspaces: const [],
            selectedWorkspace: null,
            errorMessage: failure.message,
          ),
        );
      },
    );
  }

  void selectWorkspace(WorkspaceEntity workspace) {
    emit(
      state.copyWith(
        status: WorkspaceStatus.loaded,
        selectedWorkspace: workspace,
        errorMessage: null,
      ),
    );
  }

  Future<bool> activateSelectedWorkspace(UserRole role) async {
    final workspace = state.selectedWorkspace;
    if (workspace == null) {
      emit(
        state.copyWith(
          status: WorkspaceStatus.failure,
          errorMessage: 'Select a workspace first.',
        ),
      );
      return false;
    }

    emit(state.copyWith(status: WorkspaceStatus.selecting, errorMessage: null));
    if (!workspace.availableRoles.contains(role)) {
      emit(
        state.copyWith(
          status: WorkspaceStatus.loaded,
          errorMessage: 'This workspace does not include the selected role.',
        ),
      );
      return false;
    }
    final roleId = workspace.roleIdFor(role);
    if (roleId == null) {
      emit(
        state.copyWith(
          status: WorkspaceStatus.loaded,
          errorMessage: 'Selected workspace response does not include role_id.',
        ),
      );
      return false;
    }

    final result = await _selectWorkspaceUseCase(
      SelectWorkspaceParams(workspace: workspace, role: role, roleId: roleId),
    );
    return result.when(
      success: (_) {
        emit(
          state.copyWith(status: WorkspaceStatus.loaded, errorMessage: null),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: WorkspaceStatus.loaded,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }
}
