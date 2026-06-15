import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../../live_map/domain/entities/live_map_entity.dart';
import '../../../live_map/presentation/cubit/live_map_cubit.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';
import '../widgets/field_bottom_nav.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveMapCubit>().loadLiveMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OpsHeader(
              title: AppStrings.t('liveMap', language),
              fallbackRoute: AppRoutes.home,
              action: OpsHeaderAction.outlined(
                label: AppStrings.t('filter', language),
                icon: Icons.refresh,
                onPressed: context.read<LiveMapCubit>().loadLiveMap,
              ),
            ),
            BlocBuilder<LiveMapCubit, LiveMapState>(
              builder: (context, state) {
                final summary = state.summary;
                return _MapPreview(summary: summary);
              },
            ),
            Expanded(
              child: BlocBuilder<LiveMapCubit, LiveMapState>(
                builder: (context, state) {
                  if (state.status == LiveMapStatus.loading &&
                      state.summary == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == LiveMapStatus.failure) {
                    return _MessageState(
                      icon: Icons.error_outline,
                      title: 'Unable to load live map',
                      message: state.errorMessage ?? '',
                      onRetry: context.read<LiveMapCubit>().loadLiveMap,
                    );
                  }

                  final summary = state.summary;
                  final employees = summary?.employees ?? const [];
                  return RefreshIndicator(
                    onRefresh: context.read<LiveMapCubit>().loadLiveMap,
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _MetricTile(
                                value: (summary?.active ?? 0).toString(),
                                label: 'Active',
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MetricTile(
                                value: (summary?.fieldTeam ?? 0).toString(),
                                label: 'Field Team',
                                color: const Color(0xFF16A34A),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MetricTile(
                                value: (summary?.areas ?? 0).toString(),
                                label: 'Areas',
                                color: const Color(0xFF9333EA),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'Active Field Employees',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (employees.isEmpty)
                          const _EmptyMapState()
                        else
                          ...employees.map(_EmployeeLocationCard.new),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FieldBottomNav(currentTab: FieldNavTab.map),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({required this.summary});

  final LiveMapEntity? summary;

  @override
  Widget build(BuildContext context) {
    final employees = summary?.employees ?? const [];
    return Container(
      height: 222,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDDF3FF), Color(0xFFDDFBEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Color(0xFF8D98A8),
            size: 86,
          ),
          Positioned(
            top: 52,
            left: 92,
            child: _Pin(
              color: const Color(0xFF2563EB),
              count: employees.length,
            ),
          ),
          const Positioned(
            top: 72,
            right: 118,
            child: _Pin(color: Color(0xFF16A34A)),
          ),
          const Positioned(
            bottom: 74,
            right: 164,
            child: _Pin(color: Color(0xFFFF6B21)),
          ),
          Positioned(
            bottom: 54,
            child: Column(
              children: [
                const Text(
                  'Map overview',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 18),
                ),
                Text(
                  '${employees.length} live locations',
                  style: const TextStyle(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.color, this.count});

  final Color color;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: count == null
          ? const Icon(Icons.place_outlined, color: Colors.white, size: 18)
          : Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
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
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
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
          const SizedBox(height: 20),
          Text(label, style: const TextStyle(color: AppColors.mutedText)),
        ],
      ),
    );
  }
}

class _EmployeeLocationCard extends StatelessWidget {
  const _EmployeeLocationCard(this.employee);

  final FieldEmployeeLocationEntity employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFEFF6FF),
            child: Icon(Icons.groups_outlined, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name.isEmpty ? 'Field employee' : employee.name,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.locationName.isEmpty
                      ? _coordinates(employee)
                      : employee.locationName,
                  style: const TextStyle(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
          if (employee.status.isNotEmpty) _StatusBadge(employee.status),
        ],
      ),
    );
  }

  String _coordinates(FieldEmployeeLocationEntity employee) {
    final lat = employee.latitude;
    final lng = employee.longitude;
    if (lat == null || lng == null) {
      return 'Location unavailable';
    }
    return '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.status);

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: const TextStyle(
          color: Color(0xFF2563EB),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyMapState extends StatelessWidget {
  const _EmptyMapState();

  @override
  Widget build(BuildContext context) {
    return const _MessageCard(
      icon: Icons.groups_outlined,
      title: 'No live employee locations',
      message: 'No employees are reporting locations right now.',
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _MessageCard(icon: icon, title: title, message: message),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFCBD5E1), size: 46),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedText),
            ),
          ],
        ],
      ),
    );
  }
}
