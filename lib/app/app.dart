import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../features/attendance/presentation/cubit/attendance_cubit.dart';
import '../features/chat/presentation/cubit/chat_cubit.dart';
import '../features/home/presentation/cubit/field_home_cubit.dart';
import '../features/live_map/presentation/cubit/live_map_cubit.dart';
import '../features/operations/presentation/cubit/operations_cubit.dart';
import '../features/role/presentation/cubit/role_cubit.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/settings/presentation/cubit/language_cubit.dart';
import '../features/settings/presentation/cubit/notifications_cubit.dart';
import '../features/supervisor/presentation/cubit/supervisor_cubit.dart';
import '../features/tasks/presentation/cubit/tasks_cubit.dart';
import '../features/workspace/presentation/cubit/workspace_cubit.dart';
import '../core/di/injection_container.dart';
import 'localization/app_strings.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class OpsPilotApp extends StatelessWidget {
  const OpsPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => sl<RoleCubit>()..loadDefaultRole()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<WorkspaceCubit>()),
        BlocProvider(create: (_) => sl<FieldHomeCubit>()),
        BlocProvider(create: (_) => sl<SupervisorCubit>()),
        BlocProvider(create: (_) => sl<TasksCubit>()),
        BlocProvider(create: (_) => sl<AttendanceCubit>()),
        BlocProvider(create: (_) => sl<NotificationsCubit>()),
        BlocProvider(create: (_) => sl<OperationsCubit>()),
        BlocProvider(create: (_) => sl<LiveMapCubit>()),
        BlocProvider(create: (_) => sl<ChatCubit>()),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          final locale = Locale(languageState.languageCode);
          return MaterialApp.router(
            title: 'OpsPilot',
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: AppStrings.supportedLocales,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.light,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return Directionality(
                textDirection: AppStrings.textDirection(locale.languageCode),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
