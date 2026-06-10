import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  var _checkedIn = false;

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
              title: AppStrings.t('attendance', language),
              fallbackRoute: AppRoutes.home,
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _AttendancePanel(
                    checkedIn: _checkedIn,
                    onPressed: () => setState(() => _checkedIn = !_checkedIn),
                  ),
                  const SizedBox(height: 24),
                  const _LocationCard(),
                  const SizedBox(height: 18),
                  const _HistoryButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendancePanel extends StatelessWidget {
  const _AttendancePanel({required this.checkedIn, required this.onPressed});

  final bool checkedIn;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accent = checkedIn
        ? const Color(0xFF00C853)
        : const Color(0xFF2F7DF6);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: checkedIn ? const Color(0xFFEFFDF4) : const Color(0xFFEFF6FF),
        border: Border.all(
          color: checkedIn ? const Color(0xFF86EFAC) : const Color(0xFFB6D6FF),
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            child: const Icon(Icons.access_time, color: Colors.white, size: 42),
          ),
          const SizedBox(height: 18),
          Text(
            checkedIn ? '16:17' : '16:16',
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tuesday, June 2, 2026',
            style: TextStyle(color: AppColors.mutedText, fontSize: 16),
          ),
          if (checkedIn) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  Text(
                    'Checked in at',
                    style: TextStyle(color: AppColors.mutedText),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '16:17',
                    style: TextStyle(
                      color: Color(0xFF00C853),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Duration: 0h 0m',
                    style: TextStyle(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.access_time, size: 18),
              label: Text(checkedIn ? 'Check Out' : 'Check In'),
              style: FilledButton.styleFrom(
                backgroundColor: checkedIn
                    ? const Color(0xFFFF2D3E)
                    : AppColors.darkSlate,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location', style: TextStyle(color: AppColors.mutedText)),
                SizedBox(height: 3),
                Text(
                  'Al Olaya, Riyadh, Saudi Arabia',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Accuracy: ±10 meters',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryButton extends StatelessWidget {
  const _HistoryButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, color: AppColors.ink, size: 17),
          SizedBox(width: 12),
          Text(
            'Attendance History',
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
