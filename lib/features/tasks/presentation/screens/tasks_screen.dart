import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_skeleton.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';
import '../cubit/tasks_cubit.dart';
import '../../domain/entities/task_item.dart';
import '../widgets/field_bottom_nav.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var _selectedTab = _TaskTab.today;

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().loadMyTasks();
  }

  List<TaskItem> _visibleTasks(List<TaskItem> source) {
    switch (_selectedTab) {
      case _TaskTab.today:
        return source;
      case _TaskTab.pending:
        return source
            .where((task) => task.status == TaskStatus.pending)
            .toList();
      case _TaskTab.inProgress:
        return source
            .where((task) => task.status == TaskStatus.inProgress)
            .toList();
      case _TaskTab.completed:
        return source
            .where((task) => task.status == TaskStatus.completed)
            .toList();
      case _TaskTab.delayed:
        return source
            .where((task) => task.status == TaskStatus.delayed)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    final tasksState = context.watch<TasksCubit>().state;
    final tasks = _visibleTasks(tasksState.tasks);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.t('myTasks', language),
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _SearchField(language: language)),
                      const SizedBox(width: 10),
                      _IconBox(
                        icon: Icons.filter_alt_outlined,
                        onTap: () => context.push(AppRoutes.taskFilter),
                      ),
                      const SizedBox(width: 8),
                      _IconBox(
                        icon: Icons.calendar_today_outlined,
                        onTap: () => context.push(AppRoutes.taskCalendar),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _TaskTabs(
                    selectedTab: _selectedTab,
                    onChanged: (tab) => setState(() => _selectedTab = tab),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: _TasksBody(
                status: tasksState.status,
                tasks: tasks,
                errorMessage: tasksState.errorMessage,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.tasks),
    );
  }
}

class _TasksBody extends StatelessWidget {
  const _TasksBody({
    required this.status,
    required this.tasks,
    required this.errorMessage,
  });

  final TasksStatus status;
  final List<TaskItem> tasks;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (status == TasksStatus.loading || status == TasksStatus.initial) {
      return const AppLoadingSkeleton(itemCount: 3);
    }

    if (status == TasksStatus.failure) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppEmptyState(
              title: 'Could not load tasks',
              message: errorMessage ?? 'Please try again.',
              icon: Icons.cloud_off_outlined,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Try again',
              icon: Icons.refresh,
              onPressed: () => context.read<TasksCubit>().loadMyTasks(),
            ),
          ],
        ),
      );
    }

    if (tasks.isEmpty) {
      return const AppEmptyState(
        title: 'No tasks',
        message: 'There are no tasks in this view.',
        icon: Icons.assignment_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<TasksCubit>().loadMyTasks(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(
              '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
              style: const TextStyle(color: AppColors.mutedText, fontSize: 14),
            );
          }

          return TaskCard(
            task: tasks[index - 1],
            onTap: () {
              context.read<TasksCubit>().selectTask(tasks[index - 1]);
              context.push(AppRoutes.taskDetails, extra: tasks[index - 1]);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 18),
        itemCount: tasks.length + 1,
      ),
    );
  }
}

enum _TaskTab {
  today('Today'),
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed'),
  delayed('Delayed');

  const _TaskTab(this.label);

  final String label;
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.language});

  final String language;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.search, color: Color(0xFF94A3B8), size: 24),
        const SizedBox(width: 12),
        Text(
          AppStrings.t('search', language),
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border, width: 1.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.ink, size: 20),
      ),
    );
  }
}

class _TaskTabs extends StatelessWidget {
  const _TaskTabs({required this.selectedTab, required this.onChanged});

  final _TaskTab selectedTab;
  final ValueChanged<_TaskTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _TaskTab.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          final tab = _TaskTab.values[index];
          final isSelected = tab == selectedTab;
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onChanged(tab),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                tab.label,
                style: const TextStyle(color: AppColors.ink, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
