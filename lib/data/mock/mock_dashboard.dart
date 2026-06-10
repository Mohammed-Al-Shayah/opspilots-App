class DashboardMetric {
  const DashboardMetric({
    required this.label,
    required this.value,
    required this.trend,
  });

  final String label;
  final String value;
  final String trend;
}

const mockDashboardMetrics = [
  DashboardMetric(label: 'Today Tasks', value: '18', trend: '+12%'),
  DashboardMetric(label: 'SLA Health', value: '94%', trend: '+4%'),
  DashboardMetric(label: 'Open Tickets', value: '7', trend: '-2'),
  DashboardMetric(label: 'Active Teams', value: '5', trend: 'Live'),
];
