import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/navigation_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../tasks/presentation/widgets/field_bottom_nav.dart';

class OperationsHomeScreen extends StatelessWidget {
  const OperationsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const _OperationsHeader(),
            Transform.translate(
              offset: const Offset(0, -12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _OpsCounters(),
                    SizedBox(height: 20),
                    _CompletionRateCard(),
                    SizedBox(height: 22),
                    _AiSummaryCard(),
                    SizedBox(height: 26),
                    _DelayedAlert(),
                    SizedBox(height: 26),
                    Text(
                      'Quick Access',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 18),
                    _QuickAccessGrid(),
                    SizedBox(height: 26),
                    Text(
                      'Operations Overview',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 18),
                    _OperationsOverviewCard(),
                    SizedBox(height: 24),
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

class OperationsReportsScreen extends StatelessWidget {
  const OperationsReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => context.popOrGo(AppRoutes.home),
                        icon: const Icon(Icons.arrow_back, size: 20),
                        label: const Text('Back'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: AppColors.mutedText,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_outlined, size: 18),
                        label: const Text('Export'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined, size: 18),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reports',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  _PeriodTabs(),
                  SizedBox(height: 26),
                  _ReportMetricGrid(),
                  SizedBox(height: 26),
                  _PerformanceTrendCard(),
                  SizedBox(height: 26),
                  _TeamPerformanceCard(),
                  SizedBox(height: 26),
                  _TaskDistributionCard(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(
        currentTab: FieldNavTab.reports,
      ),
    );
  }
}

class OperationsAiCenterScreen extends StatelessWidget {
  const OperationsAiCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 46),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF9D1CFF), Color(0xFF1768FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => context.popOrGo(AppRoutes.home),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text('Back'),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Center',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Intelligent Operations Insights',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  _AiDailySummary(),
                  SizedBox(height: 18),
                  _AiPredictionsCard(),
                  SizedBox(height: 18),
                  _RiskDetectionCard(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(
        currentTab: FieldNavTab.aiCenter,
      ),
    );
  }
}

class _OperationsHeader extends StatelessWidget {
  const _OperationsHeader();

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
                  'سارة أحمد',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Operations Manager',
                  style: TextStyle(color: Color(0xFFD7DEE8)),
                ),
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
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.notifications_none, color: Colors.white),
                ),
                Positioned(
                  top: 9,
                  right: 9,
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

class _OpsCounters extends StatelessWidget {
  const _OpsCounters();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _CounterBox(
            value: '1',
            label: 'Completed',
            color: Color(0xFF10BFA0),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _CounterBox(
            value: '1',
            label: 'Open Tickets',
            color: Color(0xFFFF4D1D),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _CounterBox(
            value: '3',
            label: 'Active Teams',
            color: Color(0xFF9333EA),
          ),
        ),
      ],
    );
  }
}

class _CounterBox extends StatelessWidget {
  const _CounterBox({
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
      height: 95,
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
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionRateCard extends StatelessWidget {
  const _CompletionRateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Completion Rate',
                  style: TextStyle(color: AppColors.mutedText),
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '33%',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: 14),
                    Text(
                      '+5% from yesterday',
                      style: TextStyle(color: AppColors.mutedText),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.trending_up, color: Color(0xFF16A34A)),
        ],
      ),
    );
  }
}

class _AiSummaryCard extends StatelessWidget {
  const _AiSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        border: Border.all(color: const Color(0xFFD8B4FE)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFA855F7),
            child: Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Daily Summary',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Operations are running smoothly.\nTeam performance is above average.\nOne delayed task requires attention.',
                  style: TextStyle(color: AppColors.mutedText, height: 1.35),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFA020F0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View Full Report'),
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

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.72,
      children: const [
        _QuickAccessTile(icon: Icons.bar_chart_outlined, label: 'Reports'),
        _QuickAccessTile(icon: Icons.groups_outlined, label: 'Live Map'),
        _QuickAccessTile(
          icon: Icons.assignment_turned_in_outlined,
          label: 'All Tasks',
        ),
        _QuickAccessTile(
          icon: Icons.auto_awesome_outlined,
          label: 'AI Insights',
        ),
      ],
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.ink),
          const SizedBox(height: 14),
          Text(
            label,
            style: const TextStyle(color: AppColors.ink, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _OperationsOverviewCard extends StatelessWidget {
  const _OperationsOverviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Task Completion',
                  style: TextStyle(color: AppColors.mutedText),
                ),
              ),
              Text(
                '33%',
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.33,
              minHeight: 7,
              color: Color(0xFF16A34A),
              backgroundColor: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(
                child: _OverviewNumber(label: 'Total Tasks', value: '3'),
              ),
              Expanded(
                child: _OverviewNumber(
                  label: 'Avg. Response Time',
                  value: '2.3h',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewNumber extends StatelessWidget {
  const _OverviewNumber({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        children: [
          _TabPill(label: 'Daily', selected: true),
          _TabPill(label: 'Weekly'),
          _TabPill(label: 'Monthly'),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label, style: const TextStyle(color: AppColors.ink)),
      ),
    );
  }
}

class _ReportMetricGrid extends StatelessWidget {
  const _ReportMetricGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.02,
      children: const [
        _ReportMetric(
          label: 'Completion',
          value: '33%',
          note: '+5% from last period',
          color: Color(0xFF16A34A),
          icon: Icons.trending_up,
        ),
        _ReportMetric(
          label: 'Total Tasks',
          value: '3',
          note: '+12 from yesterday',
          color: Color(0xFF2563EB),
          icon: Icons.bar_chart,
        ),
        _ReportMetric(
          label: 'Delayed',
          value: '2',
          note: '-2 from yesterday',
          color: Colors.red,
          icon: Icons.trending_down,
        ),
        _ReportMetric(
          label: 'Avg Response',
          value: '2.3h',
          note: 'Improved by 15%',
          color: Color(0xFFA020F0),
          icon: Icons.calendar_today,
        ),
      ],
    );
  }
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({
    required this.label,
    required this.value,
    required this.note,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final String note;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppColors.mutedText)),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Text(note, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PerformanceTrendCard extends StatelessWidget {
  const _PerformanceTrendCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Trend', style: _cardTitle),
          SizedBox(height: 40),
          _ProgressLine(
            label: 'Task Completion',
            value: '33%',
            progress: 0.33,
            color: Color(0xFF16A34A),
          ),
          SizedBox(height: 14),
          _ProgressLine(
            label: 'Client Satisfaction',
            value: '4.6/5',
            progress: 0.92,
            color: Color(0xFFF8C400),
          ),
          SizedBox(height: 14),
          _ProgressLine(
            label: 'On-Time Delivery',
            value: '87%',
            progress: 0.87,
            color: Color(0xFF2F7DF6),
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppColors.mutedText),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            color: color,
            backgroundColor: const Color(0xFFE5E7EB),
          ),
        ),
      ],
    );
  }
}

class _TeamPerformanceCard extends StatelessWidget {
  const _TeamPerformanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Team Performance', style: _cardTitle),
          SizedBox(height: 36),
          _TeamPerfRow(
            name: 'أحمد محمد',
            tasks: '15 tasks completed',
            rate: '95%',
          ),
          _TeamPerfRow(
            name: 'خالد العلي',
            tasks: '13 tasks completed',
            rate: '90%',
          ),
          _TeamPerfRow(
            name: 'سارة أحمد',
            tasks: '11 tasks completed',
            rate: '85%',
          ),
        ],
      ),
    );
  }
}

class _TeamPerfRow extends StatelessWidget {
  const _TeamPerfRow({
    required this.name,
    required this.tasks,
    required this.rate,
  });

  final String name;
  final String tasks;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFF0F1F4),
            child: Icon(Icons.groups_outlined, color: AppColors.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  tasks,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rate,
                style: const TextStyle(
                  color: Color(0xFF16A34A),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'Success rate',
                style: TextStyle(color: AppColors.mutedText, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskDistributionCard extends StatelessWidget {
  const _TaskDistributionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task Distribution', style: _cardTitle),
          SizedBox(height: 40),
          _DistributionRow(
            label: 'Completed',
            value: '1',
            color: Color(0xFF16A34A),
          ),
          _DistributionRow(
            label: 'In Progress',
            value: '1',
            color: Color(0xFF2563EB),
          ),
          _DistributionRow(
            label: 'Pending',
            value: '1',
            color: AppColors.orange,
          ),
          _DistributionRow(label: 'Delayed', value: '2', color: Colors.red),
        ],
      ),
    );
  }
}

class _DistributionRow extends StatelessWidget {
  const _DistributionRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.mutedText),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _AiDailySummary extends StatelessWidget {
  const _AiDailySummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FF),
        border: Border.all(color: const Color(0xFFD8B4FE)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFA855F7),
                child: Icon(Icons.psychology_outlined, color: Colors.white),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Daily Summary', style: _cardTitle),
                    SizedBox(height: 8),
                    Text(
                      'Generated at 9:00 AM - Tuesday,\nJune 2, 2026',
                      style: TextStyle(
                        color: AppColors.mutedText,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              '✓ Operations are running smoothly\nwith 92% completion rate\n✓ Team performance is above\naverage compared to last week\n⚠ 2 delayed tasks require\nimmediate attention\n📈 Response time improved by 15%\nthis week',
              style: TextStyle(color: AppColors.ink, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiPredictionsCard extends StatelessWidget {
  const _AiPredictionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.trending_up, color: Color(0xFF2563EB)),
              SizedBox(width: 10),
              Text('AI Predictions', style: _cardTitle),
            ],
          ),
          SizedBox(height: 40),
          _PredictionTile(
            title: 'Expected Completion Today',
            value: '85%',
            subtitle: 'Based on current pace and team availability',
            color: Color(0xFF2563EB),
            background: Color(0xFFEFF6FF),
          ),
          SizedBox(height: 12),
          _PredictionTile(
            title: 'Estimated Response Time',
            value: '2.1h',
            subtitle: 'Average time to complete new tasks',
            color: Color(0xFF16A34A),
            background: Color(0xFFEFFDF4),
          ),
        ],
      ),
    );
  }
}

class _PredictionTile extends StatelessWidget {
  const _PredictionTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.background,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.ink, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _RiskDetectionCard extends StatelessWidget {
  const _RiskDetectionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.red),
              SizedBox(width: 10),
              Text('Risk Detection', style: _cardTitle),
            ],
          ),
          SizedBox(height: 40),
          _RiskLine(
            color: Colors.red,
            title: 'High workload detected',
            subtitle: 'Team member أحمد محمد has 8 active tasks',
          ),
          SizedBox(height: 14),
          _RiskLine(
            color: AppColors.orange,
            title: 'SLA at risk',
            subtitle: '2 tasks may miss deadline without\nintervention',
          ),
        ],
      ),
    );
  }
}

class _RiskLine extends StatelessWidget {
  const _RiskLine({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: CircleAvatar(radius: 4, backgroundColor: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.ink, fontSize: 16),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const _cardTitle = TextStyle(
  color: AppColors.ink,
  fontSize: 20,
  fontWeight: FontWeight.w800,
);

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    border: Border.all(color: AppColors.border, width: 1.3),
    borderRadius: BorderRadius.circular(14),
  );
}
