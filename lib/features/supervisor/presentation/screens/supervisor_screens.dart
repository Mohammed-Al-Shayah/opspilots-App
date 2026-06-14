import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/navigation_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../tasks/presentation/widgets/field_bottom_nav.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../cubit/supervisor_cubit.dart';

class SupervisorHomeScreen extends StatelessWidget {
  const SupervisorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supervisorState = context.watch<SupervisorCubit>().state;
    if (supervisorState.status == SupervisorStatus.initial) {
      Future.microtask(() {
        if (context.mounted) {
          context.read<SupervisorCubit>().loadSummary();
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const _SupervisorHeader(),
            Transform.translate(
              offset: const Offset(0, -6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SupervisorStats(),
                    const SizedBox(height: 20),
                    const _DelayedAlert(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _DarkAction(
                            icon: Icons.assignment_turned_in_outlined,
                            label: 'Team Tasks',
                            onTap: () =>
                                context.go(AppRoutes.supervisorTeamTasks),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DarkAction(
                            icon: Icons.groups_outlined,
                            label: 'Team Members',
                            onTap: () => context.go(AppRoutes.supervisorTeam),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Team Activity',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _TeamActivityCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.home),
    );
  }
}

class SupervisorTeamTasksScreen extends StatelessWidget {
  const SupervisorTeamTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supervisorState = context.watch<SupervisorCubit>().state;
    if (supervisorState.status == SupervisorStatus.initial) {
      Future.microtask(() {
        if (context.mounted) {
          context.read<SupervisorCubit>().loadSummary();
        }
      });
    }
    final tasks = supervisorState.summary?.teamTasks ?? const [];

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
                children: const [
                  Text(
                    'Team Tasks',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 22),
                  _SupervisorSearch(),
                  SizedBox(height: 18),
                  _TaskTabs(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                children: [
                  const _TaskMetricsRow(),
                  const SizedBox(height: 18),
                  Text(
                    '${tasks.length} tasks',
                    style: TextStyle(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: 18),
                  if (tasks.isEmpty)
                    const _EmptySupervisorTasks()
                  else
                    for (final task in tasks) ...[
                      TaskCard(task: task),
                      const SizedBox(height: 14),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.tasks),
    );
  }
}

class SupervisorReviewsScreen extends StatefulWidget {
  const SupervisorReviewsScreen({super.key});

  @override
  State<SupervisorReviewsScreen> createState() =>
      _SupervisorReviewsScreenState();
}

class _EmptySupervisorTasks extends StatelessWidget {
  const _EmptySupervisorTasks();

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
        'No team tasks available',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.mutedText),
      ),
    );
  }
}

class _SupervisorReviewsScreenState extends State<SupervisorReviewsScreen> {
  var reviewed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 50, 24, 0),
              child: Text(
                'Task Reviews',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _ReviewTabs(
                reviewed: reviewed,
                onChanged: (value) => setState(() => reviewed = value),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: reviewed
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        _ReviewCard(
                          onTap: () =>
                              context.push(AppRoutes.supervisorReviewDetails),
                        ),
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.all(24),
                      child: _NoPendingReviews(),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(
        currentTab: FieldNavTab.reviews,
      ),
    );
  }
}

class SupervisorReviewDetailsScreen extends StatelessWidget {
  const SupervisorReviewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _BackTitle(
              title: 'Supervisor Review',
              fallbackRoute: AppRoutes.supervisorReviews,
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  _ReviewDetailsCard(),
                  SizedBox(height: 18),
                  _ReviewDescriptionCard(),
                  SizedBox(height: 18),
                  _RatingCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: _OutlineAction(
                  label: 'Reopen',
                  icon: Icons.replay,
                  onTap: () => _showReasonDialog(
                    context,
                    title: 'Reopen Task',
                    subtitle: 'Please provide a reason for reopening this task',
                    label: 'Reason to Reopen *',
                    hint: 'Please provide a reason...',
                    confirmLabel: 'Confirm Reopen',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OutlineAction(
                  label: 'Reject',
                  icon: Icons.cancel_outlined,
                  color: Colors.red,
                  onTap: () => _showReasonDialog(
                    context,
                    title: 'Reject Task',
                    subtitle: 'Please provide a reason for rejecting this task',
                    label: 'Reason for Rejection *',
                    hint: 'Please provide a reason...',
                    confirmLabel: 'Confirm Reject',
                    destructive: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.supervisorReviews),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Approve'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.enterpriseGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupervisorTeamScreen extends StatelessWidget {
  const SupervisorTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
          children: const [
            Text(
              'My Team',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 22),
            _SupervisorSearch(text: 'Search team members...'),
            SizedBox(height: 18),
            _TeamSummaryRow(),
            SizedBox(height: 24),
            Text(
              'Team Members (3)',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 18),
            _TeamMemberCard(
              name: 'أحمد محمد',
              phone: '+966501234567',
              location: 'حي العليا',
              active: 3,
              completed: 45,
              rating: '4.8',
              online: true,
            ),
            SizedBox(height: 14),
            _TeamMemberCard(
              name: 'خالد العلي',
              phone: '+966507654321',
              location: 'شارع الملك فهد',
              active: 2,
              completed: 38,
              rating: '4.6',
              online: true,
            ),
            SizedBox(height: 14),
            _TeamMemberCard(
              name: 'محمد حسن',
              phone: '+966509876543',
              location: '',
              active: 0,
              completed: 52,
              rating: '4.9',
              online: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.team),
    );
  }
}

class _SupervisorHeader extends StatelessWidget {
  const _SupervisorHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 46, 24, 42),
      decoration: const BoxDecoration(
        color: AppColors.darkSlate,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Evening',
                  style: TextStyle(color: Color(0xFFC8D3E1)),
                ),
                SizedBox(height: 8),
                Text(
                  'خالد العلي',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text('Supervisor', style: TextStyle(color: Color(0xFFD7DEE8))),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SupervisorStats extends StatelessWidget {
  const _SupervisorStats();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.65,
      children: const [
        _SupervisorStat(
          value: '8',
          label: 'Active Team',
          color: Color(0xFF3B5BFF),
          icon: Icons.groups_outlined,
        ),
        _SupervisorStat(
          value: '0',
          label: 'Pending\nReviews',
          color: Color(0xFFFF4D1D),
          icon: Icons.assignment_turned_in_outlined,
        ),
        _SupervisorStat(
          value: '1',
          label: 'Completed\nToday',
          color: Color(0xFF10BFA0),
          icon: Icons.check_circle_outline,
        ),
        _SupervisorStat(
          value: '2',
          label: 'Delayed',
          color: Color(0xFF94A3B8),
          icon: Icons.access_time,
        ),
      ],
    );
  }
}

class _SupervisorStat extends StatelessWidget {
  const _SupervisorStat({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  final String value;
  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.22),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.15,
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

class _DelayedAlert extends StatelessWidget {
  const _DelayedAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2 Delayed Tasks',
                style: TextStyle(
                  color: Color(0xFFB91C1C),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Requires immediate attention',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DarkAction extends StatelessWidget {
  const _DarkAction({
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
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.darkSlate,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamActivityCard extends StatelessWidget {
  const _TeamActivityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        children: [
          _ActivityRow(
            label: 'Completed Today',
            value: '1',
            color: Color(0xFF16A34A),
          ),
          SizedBox(height: 18),
          _ActivityRow(
            label: 'In Progress',
            value: '1',
            color: Color(0xFF2563EB),
          ),
          SizedBox(height: 18),
          _ActivityRow(label: 'Delayed', value: '2', color: Colors.red),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.mutedText),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _SupervisorSearch extends StatelessWidget {
  const _SupervisorSearch({this.text = 'Search'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF94A3B8), size: 24),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        if (text == 'Search')
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.filter_alt_outlined),
          ),
      ],
    );
  }
}

class _TaskTabs extends StatelessWidget {
  const _TaskTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          _TabChip(label: 'All', selected: true),
          _TabChip(label: 'Active'),
          _TabChip(label: 'Completed'),
          _TabChip(label: 'Delayed'),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: const TextStyle(color: AppColors.ink, fontSize: 12),
        ),
      ),
    );
  }
}

class _TaskMetricsRow extends StatelessWidget {
  const _TaskMetricsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MetricBox(
            value: '1',
            label: 'Active',
            color: Color(0xFF2563EB),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricBox(
            value: '1',
            label: 'Completed',
            color: Color(0xFF16A34A),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricBox(value: '2', label: 'Delayed', color: Colors.red),
        ),
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
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
      height: 98,
      decoration: _cardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 22),
          Text(label, style: const TextStyle(color: AppColors.mutedText)),
        ],
      ),
    );
  }
}

class _ReviewTabs extends StatelessWidget {
  const _ReviewTabs({required this.reviewed, required this.onChanged});

  final bool reviewed;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => onChanged(false),
              child: _PillLabel(label: 'Pending (0)', selected: !reviewed),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChanged(true),
              child: _PillLabel(label: 'Reviewed (1)', selected: reviewed),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.ink)),
    );
  }
}

class _NoPendingReviews extends StatelessWidget {
  const _NoPendingReviews();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174,
      decoration: _cardDecoration(),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fact_check_outlined, color: Color(0xFFD1D5DB), size: 44),
          SizedBox(height: 28),
          Text(
            'No pending reviews',
            style: TextStyle(color: AppColors.mutedText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_box_outlined,
                color: Color(0xFF16A34A),
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'فحص أنظمة الإنذار',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Icon(Icons.star, color: Color(0xFFF8C400), size: 18),
                      Text(
                        '5',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text('T-003', style: TextStyle(color: AppColors.mutedText)),
                  SizedBox(height: 8),
                  _MiniMeta(icon: Icons.person_outline, text: 'أحمد محمد'),
                  _MiniMeta(
                    icon: Icons.access_time,
                    text: '2026-05-31 - 08:00',
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _ReviewedBadge(),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.mutedText),
          ],
        ),
      ),
    );
  }
}

class _ReviewedBadge extends StatelessWidget {
  const _ReviewedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'Reviewed',
        style: TextStyle(color: Color(0xFF16A34A), fontSize: 12),
      ),
    );
  }
}

class _BackTitle extends StatelessWidget {
  const _BackTitle({required this.title, required this.fallbackRoute});

  final String title;
  final String fallbackRoute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => context.popOrGo(fallbackRoute),
            icon: const Icon(Icons.arrow_back, size: 20),
            label: const Text('Back'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewDetailsCard extends StatelessWidget {
  const _ReviewDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'فحص أنظمة الإنذار',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text('Task ID: T-003', style: TextStyle(color: AppColors.mutedText)),
          SizedBox(height: 34),
          Row(
            children: [
              _StatusPill(label: 'Completed', color: Color(0xFF16A34A)),
              SizedBox(width: 10),
              _StatusPill(
                label: 'Low',
                color: Color(0xFF64748B),
                icon: Icons.arrow_downward,
              ),
            ],
          ),
          SizedBox(height: 56),
          Divider(color: AppColors.border),
          SizedBox(height: 28),
          _DetailLine(
            icon: Icons.person_outline,
            label: 'Client',
            value: 'مستشفى الملك فيصل',
          ),
          _DetailLine(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: '+966503333333',
          ),
          _DetailLine(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: 'شارع العروبة، الرياض',
          ),
          _DetailLine(
            icon: Icons.access_time,
            label: 'Scheduled Time',
            value: '2026-05-31 - 08:00',
          ),
          _DetailLine(
            icon: Icons.person_outline,
            label: 'Assigned Employee',
            value: 'أحمد محمد',
          ),
        ],
      ),
    );
  }
}

class _ReviewDescriptionCard extends StatelessWidget {
  const _ReviewDescriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 42),
          Text(
            'فحص دوري لأنظمة الإنذار والإطفاء',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: AppColors.mutedText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_border, color: AppColors.ink),
              SizedBox(width: 8),
              Text(
                'Rate Service',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 36),
          Row(
            children: [
              Icon(Icons.star, color: Color(0xFFF8C400), size: 28),
              Icon(Icons.star, color: Color(0xFFF8C400), size: 28),
              Icon(Icons.star, color: Color(0xFFF8C400), size: 28),
              Icon(Icons.star, color: Color(0xFFF8C400), size: 28),
              Icon(Icons.star, color: Color(0xFFF8C400), size: 28),
              SizedBox(width: 18),
              Text(
                '5/5',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 34),
          Text(
            'خدمة ممتازة وسريعة',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: AppColors.mutedText),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF9CA3AF), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.mutedText)),
                const SizedBox(height: 4),
                Text(
                  value,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(label, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}

class _MiniMeta extends StatelessWidget {
  const _MiniMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.mutedText),
          const SizedBox(width: 8),
          Text(
            text,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: AppColors.mutedText),
          ),
        ],
      ),
    );
  }
}

class _OutlineAction extends StatelessWidget {
  const _OutlineAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final actionColor = color ?? AppColors.ink;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: actionColor),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: actionColor,
        side: BorderSide(
          color: color?.withValues(alpha: 0.35) ?? AppColors.border,
        ),
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
    );
  }
}

void _showReasonDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String label,
  required String hint,
  required String confirmLabel,
  bool destructive = false,
}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.mutedText,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: const TextStyle(color: AppColors.ink),
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  hint,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 38),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: destructive
                            ? Colors.red
                            : AppColors.darkSlate,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(46),
                      ),
                      child: Text(confirmLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _TeamSummaryRow extends StatelessWidget {
  const _TeamSummaryRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MetricBox(
            value: '2',
            label: 'Active',
            color: Color(0xFF16A34A),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricBox(
            value: '5',
            label: 'Active Tasks',
            color: Color(0xFF2563EB),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricBox(
            value: '4.8',
            label: 'Avg Rating',
            color: Color(0xFFD97706),
          ),
        ),
      ],
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  const _TeamMemberCard({
    required this.name,
    required this.phone,
    required this.location,
    required this.active,
    required this.completed,
    required this.rating,
    required this.online,
  });

  final String name;
  final String phone;
  final String location;
  final int active;
  final int completed;
  final String rating;
  final bool online;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: online
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFF1F5F9),
                child: Icon(
                  Icons.person_outline,
                  color: online ? const Color(0xFF16A34A) : AppColors.mutedText,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: online
                      ? const Color(0xFF22C55E)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Field Employee',
                  style: TextStyle(color: AppColors.mutedText),
                ),
                const SizedBox(height: 8),
                _MiniMeta(icon: Icons.phone_outlined, text: phone),
                if (location.isNotEmpty)
                  _MiniMeta(icon: Icons.location_on_outlined, text: location),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$active active',
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      '↗ $completed completed',
                      style: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '☆ $rating',
              style: const TextStyle(color: Color(0xFFD97706), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    border: Border.all(color: AppColors.border, width: 1.3),
    borderRadius: BorderRadius.circular(14),
  );
}
