import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../../attendance/domain/entities/attendance_record_entity.dart';
import '../../../attendance/presentation/cubit/attendance_cubit.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) {
        return;
      }
      final cubit = context.read<AttendanceCubit>();
      if (cubit.state.status == AttendanceStatus.initial) {
        cubit.loadAttendance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state.languageCode;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AttendanceCubit, AttendanceState>(
          listenWhen: (previous, current) {
            return previous.errorMessage != current.errorMessage &&
                current.errorMessage != null;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? '')));
          },
          builder: (context, state) {
            final latestRecord =
                state.activeRecord ??
                (state.records.isNotEmpty ? state.records.first : null);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OpsHeader(
                  title: AppStrings.t('attendance', language),
                  fallbackRoute: AppRoutes.home,
                ),
                const Divider(height: 1, color: AppColors.border),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: context.read<AttendanceCubit>().loadAttendance,
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        if (state.status == AttendanceStatus.loading)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 18),
                            child: LinearProgressIndicator(minHeight: 2),
                          ),
                        _AttendancePanel(
                          state: state,
                          record: latestRecord,
                          language: language,
                          onPressed: () => _handleAttendanceAction(state),
                        ),
                        const SizedBox(height: 24),
                        _LocationCard(record: latestRecord, language: language),
                        const SizedBox(height: 18),
                        _HistoryButton(language: language),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAttendanceAction(AttendanceState state) async {
    final language = context.read<LanguageCubit>().state.languageCode;
    final position = await _currentPosition(language);
    if (position == null || !mounted) {
      return;
    }

    final cubit = context.read<AttendanceCubit>();
    if (state.isCheckedIn) {
      await cubit.checkOut(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } else {
      await cubit.checkIn(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
  }

  Future<Position?> _currentPosition(String language) async {
    final messenger = ScaffoldMessenger.of(context);
    var enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.t('locationUnavailable', language))),
      );
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(AppStrings.t('locationPermissionRequired', language)),
        ),
      );
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}

class _AttendancePanel extends StatelessWidget {
  const _AttendancePanel({
    required this.state,
    required this.record,
    required this.language,
    required this.onPressed,
  });

  final AttendanceState state;
  final AttendanceRecordEntity? record;
  final String language;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final checkedIn = state.isCheckedIn;
    final accent = checkedIn
        ? const Color(0xFF00C853)
        : const Color(0xFF2F7DF6);
    final checkedInAt = DateTime.tryParse(record?.checkedInAt ?? '')?.toLocal();
    final isBusy = state.status == AttendanceStatus.actionLoading;

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
            DateFormat.Hm(language).format(DateTime.now()),
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat.yMMMMEEEEd(language).format(DateTime.now()),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 16),
          ),
          if (checkedIn && checkedInAt != null) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    AppStrings.t('checkedInAt', language),
                    style: const TextStyle(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.Hm(language).format(checkedInAt),
                    style: const TextStyle(
                      color: Color(0xFF00C853),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${AppStrings.t('duration', language)}: ${_durationText(checkedInAt)}',
                    style: const TextStyle(color: AppColors.mutedText),
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
              onPressed: isBusy ? null : onPressed,
              icon: isBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.access_time, size: 18),
              label: Text(
                checkedIn
                    ? AppStrings.t('checkOut', language)
                    : AppStrings.t('checkIn', language),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: checkedIn
                    ? const Color(0xFFFF2D3E)
                    : AppColors.darkSlate,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.mutedText,
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

  String _durationText(DateTime checkedInAt) {
    final duration = DateTime.now().difference(checkedInAt);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.record, required this.language});

  final AttendanceRecordEntity? record;
  final String language;

  @override
  Widget build(BuildContext context) {
    final latitude = record?.latitude;
    final longitude = record?.longitude;
    final locationText = latitude == null || longitude == null
        ? AppStrings.t('locationUnavailable', language)
        : '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.t('location', language),
                  style: const TextStyle(color: AppColors.mutedText),
                ),
                const SizedBox(height: 3),
                Text(
                  locationText,
                  style: const TextStyle(
                    color: AppColors.ink,
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

class _HistoryButton extends StatelessWidget {
  const _HistoryButton({required this.language});

  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: AppColors.ink,
            size: 17,
          ),
          const SizedBox(width: 12),
          Text(
            AppStrings.t('attendanceHistory', language),
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
