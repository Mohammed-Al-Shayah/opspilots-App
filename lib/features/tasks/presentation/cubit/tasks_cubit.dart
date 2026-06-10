import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task_transition.dart';
import '../../domain/usecases/get_my_tasks_usecase.dart';
import '../../domain/usecases/get_task_details_usecase.dart';
import '../../domain/usecases/transition_task_usecase.dart';
import '../../domain/entities/task_item.dart';

enum TasksStatus { initial, loading, loaded, empty, failure, actionLoading }

class TasksState extends Equatable {
  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.selectedTask,
    this.errorMessage,
  });

  final TasksStatus status;
  final List<TaskItem> tasks;
  final TaskItem? selectedTask;
  final String? errorMessage;

  TasksState copyWith({
    TasksStatus? status,
    List<TaskItem>? tasks,
    TaskItem? selectedTask,
    String? errorMessage,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      selectedTask: selectedTask ?? this.selectedTask,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tasks, selectedTask, errorMessage];
}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required GetMyTasksUseCase getMyTasksUseCase,
    required GetTaskDetailsUseCase getTaskDetailsUseCase,
    required TransitionTaskUseCase transitionTaskUseCase,
  }) : _getMyTasksUseCase = getMyTasksUseCase,
       _getTaskDetailsUseCase = getTaskDetailsUseCase,
       _transitionTaskUseCase = transitionTaskUseCase,
       super(const TasksState());

  final GetMyTasksUseCase _getMyTasksUseCase;
  final GetTaskDetailsUseCase _getTaskDetailsUseCase;
  final TransitionTaskUseCase _transitionTaskUseCase;

  Future<void> loadMyTasks() async {
    emit(state.copyWith(status: TasksStatus.loading, errorMessage: null));

    final result = await _getMyTasksUseCase();
    result.when(
      success: (tasks) {
        emit(
          state.copyWith(
            status: tasks.isEmpty ? TasksStatus.empty : TasksStatus.loaded,
            tasks: tasks,
            selectedTask: _keepSelectedTask(tasks),
            errorMessage: null,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: TasksStatus.failure,
            tasks: const [],
            errorMessage: failure.message,
          ),
        );
      },
    );
  }

  void selectTask(TaskItem task) {
    emit(state.copyWith(selectedTask: task, errorMessage: null));
  }

  Future<TaskItem> loadTaskDetails(String taskId) async {
    final result = await _getTaskDetailsUseCase(taskId);
    return result.when(
      success: (task) {
        _replaceSelectedTask(task);
        return task;
      },
      failure: (failure) => throw failure,
    );
  }

  Future<bool> transitionSelectedTask(
    TaskTransition transition, {
    String? note,
    String? reason,
    double? latitude,
    double? longitude,
  }) async {
    final task = state.selectedTask;
    if (task == null || task.id.isEmpty) {
      emit(
        state.copyWith(
          status: TasksStatus.loaded,
          errorMessage: 'No task selected.',
        ),
      );
      return false;
    }

    final previousStatus = state.status;
    emit(state.copyWith(status: TasksStatus.actionLoading, errorMessage: null));

    final result = await _transitionTaskUseCase(
      TransitionTaskParams(
        taskId: task.id,
        transition: transition,
        fallbackTask: task,
        note: note,
        reason: reason,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    return result.when(
      success: (updatedTask) {
        _replaceSelectedTask(updatedTask);
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: _restoreStatus(previousStatus),
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  TaskItem? _keepSelectedTask(List<TaskItem> tasks) {
    final selected = state.selectedTask;
    if (selected == null) {
      return null;
    }
    for (final task in tasks) {
      if (task.id == selected.id) {
        return task;
      }
    }
    return selected;
  }

  void _replaceSelectedTask(TaskItem updatedTask) {
    final tasks = state.tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
    emit(
      state.copyWith(
        status: tasks.isEmpty ? TasksStatus.empty : TasksStatus.loaded,
        tasks: tasks,
        selectedTask: updatedTask,
        errorMessage: null,
      ),
    );
  }

  TasksStatus _restoreStatus(TasksStatus previousStatus) {
    if (previousStatus == TasksStatus.loading ||
        previousStatus == TasksStatus.initial ||
        previousStatus == TasksStatus.actionLoading) {
      return state.tasks.isEmpty ? TasksStatus.empty : TasksStatus.loaded;
    }
    return previousStatus;
  }
}
