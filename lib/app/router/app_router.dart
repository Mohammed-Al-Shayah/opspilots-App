import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/role_home_screen.dart';
import '../../features/operations/presentation/screens/operations_screens.dart';
import '../../features/role/presentation/widgets/role_preview_screen.dart';
import '../../features/settings/presentation/screens/app_settings_screen.dart';
import '../../features/settings/presentation/screens/language_settings_screen.dart';
import '../../features/settings/presentation/screens/notifications_screen.dart';
import '../../features/tasks/presentation/screens/chat_screens.dart';
import '../../features/tasks/presentation/screens/attendance_screen.dart';
import '../../features/tasks/presentation/screens/live_map_screen.dart';
import '../../features/tasks/presentation/screens/profile_screen.dart';
import '../../features/supervisor/presentation/screens/supervisor_screens.dart';
import '../../features/tasks/presentation/screens/scan_qr_screen.dart';
import '../../features/tasks/presentation/screens/task_calendar_screen.dart';
import '../../features/tasks/presentation/screens/task_filter_screen.dart';
import '../../features/tasks/presentation/screens/task_workflow_screens.dart';
import '../../features/tasks/presentation/screens/tasks_screen.dart';
import '../../features/tasks/domain/entities/task_item.dart';
import '../../features/workspace/presentation/screens/workspace_selection_screen.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspace,
        builder: (context, state) => const WorkspaceSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.rolePreview,
        builder: (context, state) => const RolePreviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const RoleHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.tasks,
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: AppRoutes.liveMap,
        builder: (context, state) => const LiveMapScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatThread,
        builder: (context, state) => const ChatThreadScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.supervisorTeamTasks,
        builder: (context, state) => const SupervisorTeamTasksScreen(),
      ),
      GoRoute(
        path: AppRoutes.supervisorReviews,
        builder: (context, state) => const SupervisorReviewsScreen(),
      ),
      GoRoute(
        path: AppRoutes.supervisorReviewDetails,
        builder: (context, state) => const SupervisorReviewDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.supervisorTeam,
        builder: (context, state) => const SupervisorTeamScreen(),
      ),
      GoRoute(
        path: AppRoutes.operationsReports,
        builder: (context, state) => const OperationsReportsScreen(),
      ),
      GoRoute(
        path: AppRoutes.operationsAiCenter,
        builder: (context, state) => const OperationsAiCenterScreen(),
      ),
      GoRoute(
        path: AppRoutes.taskFilter,
        builder: (context, state) => const TaskFilterScreen(),
      ),
      GoRoute(
        path: AppRoutes.taskCalendar,
        builder: (context, state) => const TaskCalendarScreen(),
      ),
      GoRoute(
        path: AppRoutes.taskDetails,
        builder: (context, state) {
          final task = state.extra is TaskItem
              ? state.extra! as TaskItem
              : null;
          return TaskDetailsScreen(taskId: task?.id, initialTask: task);
        },
      ),
      GoRoute(
        path: AppRoutes.acceptedTaskDetails,
        builder: (context, state) {
          final task = state.extra is TaskItem
              ? state.extra! as TaskItem
              : null;
          return TaskDetailsScreen(
            stage: TaskDetailsStage.accepted,
            taskId: task?.id,
            initialTask: task,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.activeTaskDetails,
        builder: (context, state) {
          final task = state.extra is TaskItem
              ? state.extra! as TaskItem
              : null;
          return TaskDetailsScreen(
            stage: TaskDetailsStage.active,
            taskId: task?.id,
            initialTask: task,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.acceptTask,
        builder: (context, state) => const AcceptTaskScreen(),
      ),
      GoRoute(
        path: AppRoutes.taskCheckIn,
        builder: (context, state) => const TaskCheckInScreen(),
      ),
      GoRoute(
        path: AppRoutes.beforePhotos,
        builder: (context, state) => const TaskPhotoUploadScreen.before(),
      ),
      GoRoute(
        path: AppRoutes.materials,
        builder: (context, state) => const MaterialsScreen(),
      ),
      GoRoute(
        path: AppRoutes.expenses,
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: AppRoutes.addNote,
        builder: (context, state) => const AddNoteScreen(),
      ),
      GoRoute(
        path: AppRoutes.updateStatus,
        builder: (context, state) => const UpdateStatusScreen(),
      ),
      GoRoute(
        path: AppRoutes.completeTask,
        builder: (context, state) => const CompleteTaskScreen(),
      ),
      GoRoute(
        path: AppRoutes.afterPhotos,
        builder: (context, state) => const TaskPhotoUploadScreen.after(),
      ),
      GoRoute(
        path: AppRoutes.clientSignature,
        builder: (context, state) => const ClientSignatureScreen(),
      ),
      GoRoute(
        path: AppRoutes.rateService,
        builder: (context, state) => const RateServiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.attendance,
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.scanQr,
        builder: (context, state) => const ScanQrScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const AppSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const LanguageSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
