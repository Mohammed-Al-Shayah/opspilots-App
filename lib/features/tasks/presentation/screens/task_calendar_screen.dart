import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';

class TaskCalendarScreen extends StatelessWidget {
  const TaskCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
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
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  _CalendarCard(),
                  SizedBox(height: 30),
                  Text(
                    'June 2, 2026',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '0 tasks scheduled',
                    style: TextStyle(color: AppColors.mutedText, fontSize: 15),
                  ),
                  SizedBox(height: 18),
                  _NoTasksCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context) {
    final days = const [
      '31',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '1',
      '2',
      '3',
      '4',
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(34, 28, 34, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _NavButton(icon: Icons.chevron_left),
              const Expanded(
                child: Text(
                  'June 2026',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _NavButton(icon: Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Weekday('Su'),
              _Weekday('Mo'),
              _Weekday('Tu'),
              _Weekday('We'),
              _Weekday('Th'),
              _Weekday('Fr'),
              _Weekday('Sa'),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              final muted = index == 0 || index > 30;
              final selected = index == 2;
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.darkSlate : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  day,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : muted
                        ? AppColors.mutedText
                        : AppColors.ink,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 18, color: AppColors.mutedText),
    );
  }
}

class _Weekday extends StatelessWidget {
  const _Weekday(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
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
