class ApiPaths {
  const ApiPaths._();

  static const login = '/auth/login';
  static const setPassword = '/auth/set-password';
  static const me = '/auth/me';
  static const logout = '/auth/logout';

  static const workspaces = '/workspaces';
  static const selectWorkspace = '/workspaces/select';
  static const currentWorkspace = '/workspaces/current';

  static const dashboard = '/dashboard';
  static const reportsOverview = '/reports/overview';
  static const attendanceCsv = '/exports/attendance.csv';
  static const auditLogsCsv = '/exports/audit-logs.csv';

  static const tasksMy = '/tasks/my';
  static const tasks = '/tasks';

  static const attendanceMy = '/attendance/my';
  static const attendanceCheckIn = '/attendance/check-in';
  static const attendanceCheckOut = '/attendance/check-out';
  static const attendance = '/attendance';

  static const notifications = '/notifications';
  static const notificationsReadAll = '/notifications/read-all';
  static const liveMap = '/live-map';
  static const fieldEmployeeLocations = '/field-employees/locations';
  static const chatConversations = '/chat/conversations';
  static const chatAttachments = '/chat/attachments';

  static String taskMy(String taskId) => '/tasks/my/$taskId';
  static String task(String taskId) => '/tasks/$taskId';
  static String taskDetails(String taskId) => '/tasks/$taskId/details';
  static String taskAccept(String taskId) => '/tasks/$taskId/accept';
  static String taskReject(String taskId) => '/tasks/$taskId/reject';
  static String taskOnTheWay(String taskId) => '/tasks/$taskId/on-the-way';
  static String taskArrived(String taskId) => '/tasks/$taskId/arrived';
  static String taskCheckIn(String taskId) => '/tasks/$taskId/check-in';
  static String taskStart(String taskId) => '/tasks/$taskId/start';
  static String taskSubmitForReview(String taskId) {
    return '/tasks/$taskId/submit-for-review';
  }

  static String taskApprove(String taskId) => '/tasks/$taskId/approve';
  static String taskReviewReject(String taskId) {
    return '/tasks/$taskId/review-reject';
  }

  static String taskReopen(String taskId) => '/tasks/$taskId/reopen';
  static String taskNotes(String taskId) => '/tasks/$taskId/notes';
  static String taskMaterials(String taskId) => '/tasks/$taskId/materials';
  static String taskExpenses(String taskId) => '/tasks/$taskId/expenses';
  static String taskPhotos(String taskId) => '/tasks/$taskId/photos';
  static String taskPhotosUpload(String taskId) =>
      '/tasks/$taskId/photos/upload';
  static String taskPhoto(String taskId, String photoId) {
    return '/tasks/$taskId/photos/$photoId';
  }

  static String taskSignature(String taskId) => '/tasks/$taskId/signature';
  static String taskSignatureUpload(String taskId) {
    return '/tasks/$taskId/signature/upload';
  }

  static String taskRating(String taskId) => '/tasks/$taskId/rating';
  static String notificationRead(String notificationId) {
    return '/notifications/$notificationId/read';
  }

  static String chatMessages(String conversationId) {
    return '/chat/conversations/$conversationId/messages';
  }
}
