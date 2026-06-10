import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/router/navigation_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';

class TaskFilterScreen extends StatefulWidget {
  const TaskFilterScreen({super.key});

  @override
  State<TaskFilterScreen> createState() => _TaskFilterScreenState();
}

class _TaskFilterScreenState extends State<TaskFilterScreen> {
  final _selected = <String>{};

  void _toggle(String value, bool? checked) {
    setState(() {
      if (checked ?? false) {
        _selected.add(value);
      } else {
        _selected.remove(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            OpsHeader(
              title: AppStrings.t('filter', language),
              fallbackRoute: AppRoutes.tasks,
              action: OpsHeaderAction.text(
                label: AppStrings.t('reset', language),
                onPressed: () => setState(_selected.clear),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _FilterSection(
                    title: 'Status',
                    children: [
                      for (final value in _statuses)
                        _CheckRow(
                          label: value,
                          checked: _selected.contains(value),
                          onChanged: (checked) => _toggle(value, checked),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _FilterSection(
                    title: 'Priority',
                    children: [
                      for (final value in _priorities)
                        _CheckRow(
                          label: value,
                          checked: _selected.contains(value),
                          onChanged: (checked) => _toggle(value, checked),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _FilterSection(
                    title: 'Date Range',
                    children: [
                      _DateOption('Today'),
                      _DateOption('Tomorrow'),
                      _DateOption('This Week'),
                      _DateOption('This Month'),
                      _DateOption('Overdue'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => context.popOrGo(AppRoutes.tasks),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.darkSlate,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(AppStrings.t('applyFilters', language)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _statuses = [
  'Pending',
  'Accepted',
  'On the Way',
  'Arrived',
  'In Progress',
  'Waiting Client',
  'Need Materials',
  'Completed',
  'Failed',
  'Reopened',
];

const _priorities = ['Urgent', 'High', 'Medium', 'Low'];

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Checkbox(
            value: checked,
            onChanged: onChanged,
            side: const BorderSide(color: AppColors.border, width: 1.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF334155), fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _DateOption extends StatelessWidget {
  const _DateOption(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF334155), fontSize: 16),
      ),
    );
  }
}
