import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';
import '../cubit/tasks_cubit.dart';
import '../widgets/task_card.dart';

class TaskCalendarScreen extends StatelessWidget {
  const TaskCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    final tasksState = context.watch<TasksCubit>().state;
    final today = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(today);
    final tasks = tasksState.tasks
        .where((task) => task.time.contains(todayKey))
        .toList();

    if (tasksState.status == TasksStatus.initial) {
      Future.microtask(context.read<TasksCubit>().loadMyTasks);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OpsHeader(
              title: AppStrings.t('taskCalendar', language),
              fallbackRoute: AppRoutes.tasks,
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: RefreshIndicator(
                onRefresh: context.read<TasksCubit>().loadMyTasks,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _CalendarHeader(date: today, language: language),
                    const SizedBox(height: 30),
                    Text(
                      DateFormat.yMMMMd(language).format(today),
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'} scheduled',
                      style: const TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (tasks.isEmpty)
                      const _NoTasksCard()
                    else
                      for (final task in tasks) ...[
                        TaskCard(task: task),
                        const SizedBox(height: 12),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({required this.date, required this.language});

  final DateTime date;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined, color: AppColors.ink),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              DateFormat.yMMMM(language).format(date),
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            DateFormat.d(language).format(date),
            style: const TextStyle(
              color: AppColors.darkSlate,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoTasksCard extends StatelessWidget {
  const _NoTasksCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFFD1D5DB),
            size: 44,
          ),
          SizedBox(height: 34),
          Text(
            'No tasks scheduled',
            style: TextStyle(color: AppColors.mutedText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
