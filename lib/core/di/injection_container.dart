import 'package:get_it/get_it.dart';

import '../../features/attendance/data/attendance_api_service.dart';
import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/usecases/check_attendance_usecase.dart';
import '../../features/attendance/domain/usecases/get_company_attendance_usecase.dart';
import '../../features/attendance/domain/usecases/get_my_attendance_usecase.dart';
import '../../features/attendance/presentation/cubit/attendance_cubit.dart';
import '../../features/auth/data/auth_api_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/set_password_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/repositories/field_home_repository_impl.dart';
import '../../features/home/data/datasources/field_home_remote_datasource.dart';
import '../../features/home/domain/repositories/field_home_repository.dart';
import '../../features/home/domain/usecases/get_field_home_summary_usecase.dart';
import '../../features/home/presentation/cubit/field_home_cubit.dart';
import '../../features/operations/data/dashboard_api_service.dart';
import '../../features/operations/data/datasources/dashboard_remote_datasource.dart';
import '../../features/operations/data/repositories/dashboard_repository_impl.dart';
import '../../features/operations/domain/repositories/dashboard_repository.dart';
import '../../features/operations/domain/usecases/export_reports_usecase.dart';
import '../../features/operations/domain/usecases/get_dashboard_usecase.dart';
import '../../features/operations/domain/usecases/get_reports_overview_usecase.dart';
import '../../features/settings/data/repositories/notifications_repository_impl.dart';
import '../../features/settings/data/notifications_api_service.dart';
import '../../features/settings/data/datasources/notifications_remote_datasource.dart';
import '../../features/settings/domain/repositories/notifications_repository.dart';
import '../../features/settings/domain/usecases/get_notifications_usecase.dart';
import '../../features/settings/domain/usecases/mark_notifications_read_usecase.dart';
import '../../features/settings/presentation/cubit/notifications_cubit.dart';
import '../../features/role/data/repositories/role_repository_impl.dart';
import '../../features/role/data/datasources/role_local_datasource.dart';
import '../../features/role/domain/repositories/role_repository.dart';
import '../../features/role/domain/usecases/get_default_role_usecase.dart';
import '../../features/role/domain/usecases/select_role_usecase.dart';
import '../../features/role/presentation/cubit/role_cubit.dart';
import '../../features/supervisor/data/repositories/supervisor_repository_impl.dart';
import '../../features/supervisor/data/datasources/supervisor_remote_datasource.dart';
import '../../features/supervisor/domain/repositories/supervisor_repository.dart';
import '../../features/supervisor/domain/usecases/get_supervisor_summary_usecase.dart';
import '../../features/supervisor/presentation/cubit/supervisor_cubit.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/data/datasources/tasks_remote_datasource.dart';
import '../../features/tasks/data/tasks_api_service.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/get_my_tasks_usecase.dart';
import '../../features/tasks/domain/usecases/get_tasks_usecase.dart';
import '../../features/tasks/domain/usecases/get_task_details_usecase.dart';
import '../../features/tasks/domain/usecases/submit_task_workflow_usecase.dart';
import '../../features/tasks/domain/usecases/transition_task_usecase.dart';
import '../../features/tasks/presentation/cubit/tasks_cubit.dart';
import '../../features/workspace/data/workspace_api_service.dart';
import '../../features/workspace/data/datasources/workspace_remote_datasource.dart';
import '../../features/workspace/data/repositories/workspace_repository_impl.dart';
import '../../features/workspace/domain/repositories/workspace_repository.dart';
import '../../features/workspace/domain/usecases/get_current_workspace_usecase.dart';
import '../../features/workspace/domain/usecases/get_workspaces_usecase.dart';
import '../../features/workspace/domain/usecases/select_workspace_usecase.dart';
import '../../features/workspace/presentation/cubit/workspace_cubit.dart';
import '../network/api_token_store.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (!sl.isRegistered<ApiTokenStore>()) {
    sl.registerLazySingleton<ApiTokenStore>(ApiTokenStore.new);
  }
  if (!sl.isRegistered<DioClient>()) {
    sl.registerLazySingleton<DioClient>(
      () => DioClient(tokenStore: sl<ApiTokenStore>()),
    );
  }
  if (!sl.isRegistered<RoleRepository>()) {
    sl.registerLazySingleton<RoleRepository>(
      () => RoleRepositoryImpl(localDataSource: sl<RoleLocalDataSource>()),
    );
  }
  if (!sl.isRegistered<RoleLocalDataSource>()) {
    sl.registerLazySingleton<RoleLocalDataSource>(RoleLocalDataSourceImpl.new);
  }
  if (!sl.isRegistered<GetDefaultRoleUseCase>()) {
    sl.registerLazySingleton<GetDefaultRoleUseCase>(
      () => GetDefaultRoleUseCase(sl<RoleRepository>()),
    );
  }
  if (!sl.isRegistered<SelectRoleUseCase>()) {
    sl.registerLazySingleton<SelectRoleUseCase>(
      () => SelectRoleUseCase(sl<RoleRepository>()),
    );
  }
  if (!sl.isRegistered<FieldHomeRepository>()) {
    sl.registerLazySingleton<FieldHomeRepository>(
      () => FieldHomeRepositoryImpl(
        remoteDataSource: sl<FieldHomeRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<GetFieldHomeSummaryUseCase>()) {
    sl.registerLazySingleton<GetFieldHomeSummaryUseCase>(
      () => GetFieldHomeSummaryUseCase(sl<FieldHomeRepository>()),
    );
  }
  if (!sl.isRegistered<SupervisorRepository>()) {
    sl.registerLazySingleton<SupervisorRepository>(
      () => SupervisorRepositoryImpl(
        remoteDataSource: sl<SupervisorRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<GetSupervisorSummaryUseCase>()) {
    sl.registerLazySingleton<GetSupervisorSummaryUseCase>(
      () => GetSupervisorSummaryUseCase(sl<SupervisorRepository>()),
    );
  }
  if (!sl.isRegistered<AuthApiService>()) {
    sl.registerLazySingleton<AuthApiService>(
      () => AuthApiService(
        dioClient: sl<DioClient>(),
        tokenStore: sl<ApiTokenStore>(),
      ),
    );
  }
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiService: sl<AuthApiService>()),
    );
  }
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
    );
  }
  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<SetPasswordUseCase>()) {
    sl.registerLazySingleton<SetPasswordUseCase>(
      () => SetPasswordUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<WorkspaceApiService>()) {
    sl.registerLazySingleton<WorkspaceApiService>(
      () => WorkspaceApiService(
        dioClient: sl<DioClient>(),
        tokenStore: sl<ApiTokenStore>(),
      ),
    );
  }
  if (!sl.isRegistered<WorkspaceRemoteDataSource>()) {
    sl.registerLazySingleton<WorkspaceRemoteDataSource>(
      () =>
          WorkspaceRemoteDataSourceImpl(apiService: sl<WorkspaceApiService>()),
    );
  }
  if (!sl.isRegistered<WorkspaceRepository>()) {
    sl.registerLazySingleton<WorkspaceRepository>(
      () => WorkspaceRepositoryImpl(
        remoteDataSource: sl<WorkspaceRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<GetWorkspacesUseCase>()) {
    sl.registerLazySingleton<GetWorkspacesUseCase>(
      () => GetWorkspacesUseCase(sl<WorkspaceRepository>()),
    );
  }
  if (!sl.isRegistered<SelectWorkspaceUseCase>()) {
    sl.registerLazySingleton<SelectWorkspaceUseCase>(
      () => SelectWorkspaceUseCase(sl<WorkspaceRepository>()),
    );
  }
  if (!sl.isRegistered<GetCurrentWorkspaceUseCase>()) {
    sl.registerLazySingleton<GetCurrentWorkspaceUseCase>(
      () => GetCurrentWorkspaceUseCase(sl<WorkspaceRepository>()),
    );
  }
  if (!sl.isRegistered<TasksApiService>()) {
    sl.registerLazySingleton<TasksApiService>(
      () => TasksApiService(dioClient: sl<DioClient>()),
    );
  }
  if (!sl.isRegistered<TasksRemoteDataSource>()) {
    sl.registerLazySingleton<TasksRemoteDataSource>(
      () => TasksRemoteDataSourceImpl(apiService: sl<TasksApiService>()),
    );
  }
  if (!sl.isRegistered<TasksRepository>()) {
    sl.registerLazySingleton<TasksRepository>(
      () => TasksRepositoryImpl(remoteDataSource: sl<TasksRemoteDataSource>()),
    );
  }
  if (!sl.isRegistered<GetMyTasksUseCase>()) {
    sl.registerLazySingleton<GetMyTasksUseCase>(
      () => GetMyTasksUseCase(sl<TasksRepository>()),
    );
  }
  if (!sl.isRegistered<GetTasksUseCase>()) {
    sl.registerLazySingleton<GetTasksUseCase>(
      () => GetTasksUseCase(sl<TasksRepository>()),
    );
  }
  if (!sl.isRegistered<GetTaskDetailsUseCase>()) {
    sl.registerLazySingleton<GetTaskDetailsUseCase>(
      () => GetTaskDetailsUseCase(sl<TasksRepository>()),
    );
  }
  if (!sl.isRegistered<TransitionTaskUseCase>()) {
    sl.registerLazySingleton<TransitionTaskUseCase>(
      () => TransitionTaskUseCase(sl<TasksRepository>()),
    );
  }
  if (!sl.isRegistered<SubmitTaskWorkflowUseCase>()) {
    sl.registerLazySingleton<SubmitTaskWorkflowUseCase>(
      () => SubmitTaskWorkflowUseCase(sl<TasksRepository>()),
    );
  }
  if (!sl.isRegistered<AttendanceApiService>()) {
    sl.registerLazySingleton<AttendanceApiService>(
      () => AttendanceApiService(dioClient: sl<DioClient>()),
    );
  }
  if (!sl.isRegistered<AttendanceRemoteDataSource>()) {
    sl.registerLazySingleton<AttendanceRemoteDataSource>(
      () => AttendanceRemoteDataSourceImpl(
        apiService: sl<AttendanceApiService>(),
      ),
    );
  }
  if (!sl.isRegistered<AttendanceRepository>()) {
    sl.registerLazySingleton<AttendanceRepository>(
      () => AttendanceRepositoryImpl(
        remoteDataSource: sl<AttendanceRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<GetMyAttendanceUseCase>()) {
    sl.registerLazySingleton<GetMyAttendanceUseCase>(
      () => GetMyAttendanceUseCase(sl<AttendanceRepository>()),
    );
  }
  if (!sl.isRegistered<GetCompanyAttendanceUseCase>()) {
    sl.registerLazySingleton<GetCompanyAttendanceUseCase>(
      () => GetCompanyAttendanceUseCase(sl<AttendanceRepository>()),
    );
  }
  if (!sl.isRegistered<CheckInUseCase>()) {
    sl.registerLazySingleton<CheckInUseCase>(
      () => CheckInUseCase(sl<AttendanceRepository>()),
    );
  }
  if (!sl.isRegistered<CheckOutUseCase>()) {
    sl.registerLazySingleton<CheckOutUseCase>(
      () => CheckOutUseCase(sl<AttendanceRepository>()),
    );
  }
  if (!sl.isRegistered<DashboardApiService>()) {
    sl.registerLazySingleton<DashboardApiService>(
      () => DashboardApiService(dioClient: sl<DioClient>()),
    );
  }
  if (!sl.isRegistered<DashboardRemoteDataSource>()) {
    sl.registerLazySingleton<DashboardRemoteDataSource>(
      () =>
          DashboardRemoteDataSourceImpl(apiService: sl<DashboardApiService>()),
    );
  }
  if (!sl.isRegistered<FieldHomeRemoteDataSource>()) {
    sl.registerLazySingleton<FieldHomeRemoteDataSource>(
      () => FieldHomeRemoteDataSourceImpl(
        dashboardRemoteDataSource: sl<DashboardRemoteDataSource>(),
        tasksRemoteDataSource: sl<TasksRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<SupervisorRemoteDataSource>()) {
    sl.registerLazySingleton<SupervisorRemoteDataSource>(
      () => SupervisorRemoteDataSourceImpl(
        dashboardRemoteDataSource: sl<DashboardRemoteDataSource>(),
        tasksRemoteDataSource: sl<TasksRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<DashboardRepository>()) {
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: sl<DashboardRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<GetDashboardUseCase>()) {
    sl.registerLazySingleton<GetDashboardUseCase>(
      () => GetDashboardUseCase(sl<DashboardRepository>()),
    );
  }
  if (!sl.isRegistered<GetReportsOverviewUseCase>()) {
    sl.registerLazySingleton<GetReportsOverviewUseCase>(
      () => GetReportsOverviewUseCase(sl<DashboardRepository>()),
    );
  }
  if (!sl.isRegistered<ExportAttendanceCsvUseCase>()) {
    sl.registerLazySingleton<ExportAttendanceCsvUseCase>(
      () => ExportAttendanceCsvUseCase(sl<DashboardRepository>()),
    );
  }
  if (!sl.isRegistered<ExportAuditLogsCsvUseCase>()) {
    sl.registerLazySingleton<ExportAuditLogsCsvUseCase>(
      () => ExportAuditLogsCsvUseCase(sl<DashboardRepository>()),
    );
  }
  if (!sl.isRegistered<NotificationsApiService>()) {
    sl.registerLazySingleton<NotificationsApiService>(
      () => NotificationsApiService(dioClient: sl<DioClient>()),
    );
  }
  if (!sl.isRegistered<NotificationsRemoteDataSource>()) {
    sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(
        apiService: sl<NotificationsApiService>(),
      ),
    );
  }
  if (!sl.isRegistered<NotificationsRepository>()) {
    sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(
        remoteDataSource: sl<NotificationsRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<GetNotificationsUseCase>()) {
    sl.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(sl<NotificationsRepository>()),
    );
  }
  if (!sl.isRegistered<MarkAllNotificationsReadUseCase>()) {
    sl.registerLazySingleton<MarkAllNotificationsReadUseCase>(
      () => MarkAllNotificationsReadUseCase(sl<NotificationsRepository>()),
    );
  }
  if (!sl.isRegistered<MarkNotificationReadUseCase>()) {
    sl.registerLazySingleton<MarkNotificationReadUseCase>(
      () => MarkNotificationReadUseCase(sl<NotificationsRepository>()),
    );
  }
  if (!sl.isRegistered<AuthCubit>()) {
    sl.registerFactory<AuthCubit>(
      () => AuthCubit(
        loginUseCase: sl<LoginUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<RoleCubit>()) {
    sl.registerFactory<RoleCubit>(
      () => RoleCubit(
        getDefaultRoleUseCase: sl<GetDefaultRoleUseCase>(),
        selectRoleUseCase: sl<SelectRoleUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<FieldHomeCubit>()) {
    sl.registerFactory<FieldHomeCubit>(
      () => FieldHomeCubit(getSummaryUseCase: sl<GetFieldHomeSummaryUseCase>()),
    );
  }
  if (!sl.isRegistered<SupervisorCubit>()) {
    sl.registerFactory<SupervisorCubit>(
      () =>
          SupervisorCubit(getSummaryUseCase: sl<GetSupervisorSummaryUseCase>()),
    );
  }
  if (!sl.isRegistered<WorkspaceCubit>()) {
    sl.registerFactory<WorkspaceCubit>(
      () => WorkspaceCubit(
        getWorkspacesUseCase: sl<GetWorkspacesUseCase>(),
        selectWorkspaceUseCase: sl<SelectWorkspaceUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<TasksCubit>()) {
    sl.registerFactory<TasksCubit>(
      () => TasksCubit(
        getMyTasksUseCase: sl<GetMyTasksUseCase>(),
        getTaskDetailsUseCase: sl<GetTaskDetailsUseCase>(),
        transitionTaskUseCase: sl<TransitionTaskUseCase>(),
        submitTaskWorkflowUseCase: sl<SubmitTaskWorkflowUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<AttendanceCubit>()) {
    sl.registerFactory<AttendanceCubit>(
      () => AttendanceCubit(
        getMyAttendanceUseCase: sl<GetMyAttendanceUseCase>(),
        checkInUseCase: sl<CheckInUseCase>(),
        checkOutUseCase: sl<CheckOutUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<NotificationsCubit>()) {
    sl.registerFactory<NotificationsCubit>(
      () => NotificationsCubit(
        getNotificationsUseCase: sl<GetNotificationsUseCase>(),
        markAllReadUseCase: sl<MarkAllNotificationsReadUseCase>(),
        markReadUseCase: sl<MarkNotificationReadUseCase>(),
      ),
    );
  }
}
