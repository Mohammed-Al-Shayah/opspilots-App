import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../operations/presentation/screens/operations_screens.dart';
import '../../../role/domain/user_role.dart';
import '../../../role/presentation/cubit/role_cubit.dart';
import '../../../supervisor/presentation/screens/supervisor_screens.dart';
import '../../../tasks/presentation/widgets/field_bottom_nav.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../cubit/field_home_cubit.dart';

class RoleHomeScreen extends StatelessWidget {
  const RoleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleCubit>().state.selectedRole;
    if (role == UserRole.supervisor) {
      return const SupervisorHomeScreen();
    }
    if (role == UserRole.operationsManager) {
      return const OperationsHomeScreen();
    }

    final state = context.watch<FieldHomeCubit>().state;
    if (state.status == FieldHomeStatus.initial) {
      Future.microtask(() {
        if (context.mounted) {
          context.read<FieldHomeCubit>().loadSummary();
        }
      });
    }
    final summary = state.summary;
    final tasks = summary?.todayTasks ?? const [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => context.read<FieldHomeCubit>().loadSummary(),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _DashboardHeader(
                name: summary?.employeeName ?? '',
                roleLabel: summary?.roleLabel ?? 'Field Employee',
              ),
              Transform.translate(
                offset: const Offset(0, -12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatusCounters(
                        today: summary?.todayCount ?? 2,
                        pending: summary?.pendingCount ?? 1,
                        active: summary?.activeCount ?? 1,
                        completed: summary?.completedCount ?? 1,
                      ),
                      const SizedBox(height: 20),
                      _CompletionCard(rate: summary?.completionRate ?? 0.33),
                      const SizedBox(height: 24),
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Start your field tasks',
                        style: TextStyle(color: AppColors.mutedText),
                      ),
                      const SizedBox(height: 16),
                      _QuickActions(),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Tasks',
                                  style: TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '2 scheduled for today',
                                  style: TextStyle(color: AppColors.mutedText),
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => context.go(AppRoutes.tasks),
                            iconAlignment: IconAlignment.end,
                            icon: const Icon(Icons.chevron_right, size: 20),
                            label: const Text('View All'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (tasks.isEmpty)
                        const _NoTasksCard()
                      else
                        for (final task in tasks) ...[
                          TaskCard(
                            task: task,
                            onTap: () => context.push(
                              AppRoutes.taskDetails,
                              extra: task,
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.home),
    );
  }
}

class _NoTasksCard extends StatelessWidget {
  const _NoTasksCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'No tasks scheduled',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.mutedText),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.name, required this.roleLabel});

  final String name;
  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 42, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.darkSlate,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GOOD AFTERNOON',
                  style: TextStyle(
                    color: Color(0xFFC8D3E1),
                    fontSize: 12,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  roleLabel,
                  style: const TextStyle(
                    color: Color(0xFFD7DEE8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3045),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCounters extends StatelessWidget {
  const _StatusCounters({
    required this.today,
    required this.pending,
    required this.active,
    required this.completed,
  });

  final int today;
  final int pending;
  final int active;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CounterTile(
            value: today.toString(),
            label: 'Today',
            color: const Color(0xFFFF4D1D),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CounterTile(
            value: pending.toString(),
            label: 'Pending',
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CounterTile(
            value: active.toString(),
            label: 'Active',
            color: const Color(0xFF9333EA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CounterTile(
            value: completed.toString(),
            label: 'Completed',
            color: const Color(0xFF10BFA0),
          ),
        ),
      ],
    );
  }
}

class _CounterTile extends StatelessWidget {
  const _CounterTile({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.rate});

  final double rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Completion Rate',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(rate * 100).round()}%',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'of tasks',
                      style: TextStyle(color: AppColors.mutedText),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: rate,
                    minHeight: 7,
                    color: const Color(0xFF4F46E5),
                    backgroundColor: const Color(0xFFE5E7EB),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.trending_up, color: Color(0xFF9AA5B5), size: 42),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.location_on_outlined,
            label: 'Check In',
            onTap: () => context.go(AppRoutes.attendance),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon: Icons.qr_code_scanner,
            label: 'Scan QR',
            onTap: () => context.go(AppRoutes.scanQr),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon: Icons.assignment_turned_in_outlined,
            label: 'My Tasks',
            onTap: () => context.go(AppRoutes.tasks),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border, width: 1.3),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.darkSlate,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
