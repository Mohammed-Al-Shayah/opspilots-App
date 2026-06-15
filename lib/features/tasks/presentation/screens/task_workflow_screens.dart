import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/navigation_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/widgets/ops_header.dart';
import '../../domain/entities/task_transition.dart';
import '../../domain/usecases/submit_task_workflow_usecase.dart';
import '../cubit/tasks_cubit.dart';
import '../../domain/entities/task_item.dart';

enum TaskDetailsStage { pending, accepted, active }

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({
    super.key,
    this.stage = TaskDetailsStage.pending,
    this.taskId,
    this.initialTask,
  });

  final TaskDetailsStage stage;
  final String? taskId;
  final TaskItem? initialTask;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  Future<TaskItem?>? _taskFuture;

  @override
  void initState() {
    super.initState();
    final taskId = widget.taskId;
    if (taskId != null && taskId.isNotEmpty) {
      _taskFuture = _loadTask(taskId);
    }
  }

  Future<TaskItem?> _loadTask(String taskId) async {
    return context.read<TasksCubit>().loadTaskDetails(taskId);
  }

  @override
  Widget build(BuildContext context) {
    final isAccepted = widget.stage == TaskDetailsStage.accepted;
    final isActive = widget.stage == TaskDetailsStage.active;
    final selectedTask = context.watch<TasksCubit>().state.selectedTask;
    final fallbackTask = widget.initialTask ?? selectedTask;

    return _WorkflowScaffold(
      title: 'Task Details',
      fallbackRoute: AppRoutes.tasks,
      bottom: _TaskDetailsBottom(stage: widget.stage),
      child: FutureBuilder<TaskItem?>(
        future: _taskFuture,
        initialData: fallbackTask,
        builder: (context, snapshot) {
          final task = snapshot.data ?? fallbackTask;
          if (task == null) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: const [_InlineError(message: 'No task selected.')],
            );
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (snapshot.connectionState == ConnectionState.waiting)
                const LinearProgressIndicator(minHeight: 2),
              if (snapshot.connectionState == ConnectionState.waiting)
                const SizedBox(height: 16),
              if (snapshot.hasError) ...[
                _InlineError(message: _errorMessage(snapshot.error)),
                const SizedBox(height: 16),
              ],
              _TaskInfoCard(
                task: task,
                status: isActive
                    ? TaskStatus.inProgress
                    : isAccepted
                    ? null
                    : task.status,
                accepted: isAccepted,
                showBeforePhotos: isActive,
              ),
              const SizedBox(height: 18),
              _DescriptionCard(description: task.description),
              if (isActive) ...[
                const SizedBox(height: 18),
                const _BeforePhotosSummary(),
                const SizedBox(height: 18),
                _ActionGrid(),
              ],
            ],
          );
        },
      ),
    );
  }

  String _errorMessage(Object? error) {
    if (error is AppFailure) {
      return error.message;
    }
    return 'Could not refresh task details.';
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.danger, fontSize: 13),
      ),
    );
  }
}

class AcceptTaskScreen extends StatefulWidget {
  const AcceptTaskScreen({super.key});

  @override
  State<AcceptTaskScreen> createState() => _AcceptTaskScreenState();
}

class _AcceptTaskScreenState extends State<AcceptTaskScreen> {
  bool _isSubmitting = false;

  Future<void> _acceptTask() async {
    if (_isSubmitting) {
      return;
    }
    setState(() => _isSubmitting = true);
    final accepted = await context.read<TasksCubit>().transitionSelectedTask(
      TaskTransition.accept,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSubmitting = false);
    if (accepted) {
      final task = context.read<TasksCubit>().state.selectedTask;
      context.go(AppRoutes.acceptedTaskDetails, extra: task);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TasksCubit>().state;
    final task = state.selectedTask;
    final errorMessage = state.errorMessage;

    return _WorkflowScaffold(
      title: 'Accept Task',
      fallbackRoute: AppRoutes.taskDetails,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
            decoration: _bluePanelDecoration(),
            child: Column(
              children: [
                _CircleIcon(icon: Icons.check, color: const Color(0xFF2F7DF6)),
                const SizedBox(height: 20),
                const Text(
                  'Accept this task?',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'By accepting, you commit to\ncompleting this task',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 17,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 48),
                if (task == null)
                  const _InlineError(message: 'No task selected.')
                else
                  _MiniTaskCard(task: task),
              ],
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 14),
            _InlineError(message: errorMessage),
          ],
          const SizedBox(height: 24),
          _PrimaryButton(
            label: _isSubmitting ? 'Accepting...' : 'Accept Task',
            icon: Icons.check_circle_outline,
            onPressed: _isSubmitting || task == null ? null : _acceptTask,
          ),
          const SizedBox(height: 12),
          _SecondaryButton(
            label: 'Cancel',
            onPressed: () => context.popOrGo(AppRoutes.taskDetails),
          ),
        ],
      ),
    );
  }
}

class TaskCheckInScreen extends StatefulWidget {
  const TaskCheckInScreen({super.key});

  @override
  State<TaskCheckInScreen> createState() => _TaskCheckInScreenState();
}

class _TaskCheckInScreenState extends State<TaskCheckInScreen> {
  bool _submitting = false;

  Future<void> _checkIn() async {
    if (_submitting) {
      return;
    }
    setState(() => _submitting = true);
    final position = await _currentPosition();
    if (position == null || !mounted) {
      setState(() => _submitting = false);
      return;
    }
    final success = await context.read<TasksCubit>().transitionSelectedTask(
      TaskTransition.checkIn,
      latitude: position.latitude,
      longitude: position.longitude,
    );
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    if (success) {
      context.go(AppRoutes.beforePhotos);
    }
  }

  Future<Position?> _currentPosition() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!await Geolocator.isLocationServiceEnabled()) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Location service is disabled.')),
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
        const SnackBar(content: Text('Location permission is required.')),
      );
      return null;
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _WorkflowScaffold(
      title: 'Check In',
      fallbackRoute: AppRoutes.acceptedTaskDetails,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 166,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF9CA3AF),
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 42),
                const Text(
                  'Location',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'شارع الملك فهد، الرياض',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: AppColors.mutedText, fontSize: 16),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFFDF4),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      _RoundBadgeIcon(
                        icon: Icons.navigation,
                        color: Color(0xFF00C853),
                      ),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distance from location',
                            style: TextStyle(color: AppColors.mutedText),
                          ),
                          Text(
                            'Location will be verified',
                            style: TextStyle(
                              color: Color(0xFF00C853),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Current GPS is sent to the API',
                            style: TextStyle(
                              color: AppColors.mutedText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          _PrimaryButton(
            label: _submitting ? 'Checking in...' : 'Check In',
            icon: Icons.location_on_outlined,
            onPressed: _submitting ? null : _checkIn,
          ),
        ],
      ),
    );
  }
}

class TaskPhotoUploadScreen extends StatefulWidget {
  const TaskPhotoUploadScreen.before({super.key})
    : title = 'Before Photos',
      fallbackRoute = AppRoutes.taskCheckIn,
      nextRoute = AppRoutes.activeTaskDetails;

  const TaskPhotoUploadScreen.after({super.key})
    : title = 'After Photos',
      fallbackRoute = AppRoutes.completeTask,
      nextRoute = AppRoutes.clientSignature;

  final String title;
  final String fallbackRoute;
  final String nextRoute;

  @override
  State<TaskPhotoUploadScreen> createState() => _TaskPhotoUploadScreenState();
}

class _TaskPhotoUploadScreenState extends State<TaskPhotoUploadScreen> {
  final _picker = ImagePicker();
  final _photos = <XFile>[];
  bool _uploading = false;

  String get _type =>
      widget.title.toLowerCase().startsWith('before') ? 'before' : 'after';

  Future<void> _pick(ImageSource source) async {
    if (_uploading) {
      return;
    }
    final picked = await _picker.pickImage(source: source, imageQuality: 82);
    if (picked == null || !mounted) {
      return;
    }

    setState(() => _uploading = true);
    final uploaded = await context.read<TasksCubit>().uploadSelectedTaskPhoto(
      filePath: picked.path,
      type: _type,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _uploading = false;
      if (uploaded) {
        _photos.add(picked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _WorkflowScaffold(
      title: widget.title,
      subtitle: 'Upload at least 2 photos (${_photos.length}/2)',
      fallbackRoute: widget.fallbackRoute,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final photo in _photos)
                      _PhotoThumb(filePath: photo.path),
                    for (var i = _photos.length; i < 2; i++)
                      const _PhotoThumb(),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: _UploadBox(
                        icon: Icons.camera_alt_outlined,
                        label: 'Take Photo',
                        onTap: () => _pick(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _UploadBox(
                        icon: Icons.upload_outlined,
                        label: 'Choose from Gallery',
                        onTap: () => _pick(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                if (_uploading) ...[
                  const SizedBox(height: 18),
                  const LinearProgressIndicator(minHeight: 2),
                ],
              ],
            ),
          ),
          const SizedBox(height: 26),
          _PrimaryButton(
            label: 'Next',
            onPressed: _photos.length < 2 || _uploading
                ? null
                : () => context.go(widget.nextRoute),
          ),
        ],
      ),
    );
  }
}

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final _entries = <String>[];
  double _total = 0;

  Future<void> _addMaterial() async {
    final result = await _showMaterialDialog(context);
    if (result == null || !mounted) {
      return;
    }
    final success = await context.read<TasksCubit>().submitWorkflowAction(
      TaskWorkflowAction.material,
      result,
    );
    if (!mounted) {
      return;
    }
    if (success) {
      setState(() {
        _entries.add(result['name']?.toString() ?? 'Material');
        _total += (result['cost'] as num?)?.toDouble() ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ListEntryScreen(
      title: 'Materials',
      summaryLabel: 'Total Materials Cost',
      summaryValue: '\$${_total.toStringAsFixed(2)}',
      icon: Icons.inventory_2_outlined,
      iconColor: const Color(0xFF2563EB),
      sectionTitle: 'Used Materials (${_entries.length})',
      emptyIcon: Icons.inventory_2_outlined,
      emptyText: 'No materials added yet',
      addTitle: 'Add Material',
      addSubtitle: 'Enter the material details below',
      entries: _entries,
      onAdd: _addMaterial,
    );
  }
}

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _entries = <String>[];
  double _total = 0;

  Future<void> _addExpense() async {
    final result = await _showExpenseDialog(context);
    if (result == null || !mounted) {
      return;
    }
    final success = await context.read<TasksCubit>().submitWorkflowAction(
      TaskWorkflowAction.expense,
      result,
    );
    if (!mounted) {
      return;
    }
    if (success) {
      setState(() {
        _entries.add(result['type']?.toString() ?? 'Expense');
        _total += (result['amount'] as num?)?.toDouble() ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ListEntryScreen(
      title: 'Expenses',
      summaryLabel: 'Total Expenses',
      summaryValue: '\$${_total.toStringAsFixed(2)}',
      icon: Icons.attach_money,
      iconColor: const Color(0xFF16A34A),
      sectionTitle: 'Expenses (${_entries.length})',
      emptyIcon: Icons.attach_money,
      emptyText: 'No expenses added yet',
      addTitle: 'Add Expense',
      addSubtitle: 'Enter the expense details below',
      entries: _entries,
      onAdd: _addExpense,
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _notesController = TextEditingController();
  bool _clientVisible = false;
  bool _submitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final note = _notesController.text.trim();
    if (note.isEmpty || _submitting) {
      return;
    }
    setState(() => _submitting = true);
    final success = await context.read<TasksCubit>().submitWorkflowAction(
      TaskWorkflowAction.note,
      {'note': note, 'client_visible': _clientVisible},
    );
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    if (success) {
      context.go(AppRoutes.activeTaskDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _WorkflowScaffold(
      title: 'Add Note',
      fallbackRoute: AppRoutes.activeTaskDetails,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(color: AppColors.ink, fontSize: 15),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _notesController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Add your notes here...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: AppColors.ink, fontSize: 17),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client visible',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Client can see this note',
                              style: TextStyle(color: AppColors.mutedText),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _clientVisible,
                        onChanged: (value) {
                          setState(() => _clientVisible = value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const _UploadBox(
                  icon: Icons.camera_alt_outlined,
                  label: 'Attach Image',
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: 'Cancel',
                  onPressed: () => context.popOrGo(AppRoutes.activeTaskDetails),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PrimaryButton(
                  label: _submitting ? 'Saving...' : 'Save',
                  icon: Icons.note_alt_outlined,
                  onPressed: _submitting ? null : _save,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdateStatusScreen extends StatefulWidget {
  const UpdateStatusScreen({super.key});

  @override
  State<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
  final _noteController = TextEditingController();
  var _selected = TaskTransition.onTheWay;
  bool _submitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    if (_submitting) {
      return;
    }
    setState(() => _submitting = true);
    final success = await context.read<TasksCubit>().transitionSelectedTask(
      _selected,
      note: _noteController.text.trim(),
    );
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    if (success) {
      context.go(AppRoutes.activeTaskDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = const [
      (label: 'On the Way', transition: TaskTransition.onTheWay),
      (label: 'Arrived', transition: TaskTransition.arrived),
      (label: 'In Progress', transition: TaskTransition.start),
      (label: 'Failed', transition: TaskTransition.reviewReject),
    ];
    return _WorkflowScaffold(
      title: 'Update Status',
      fallbackRoute: AppRoutes.activeTaskDetails,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Status',
                  style: TextStyle(color: AppColors.mutedText),
                ),
                SizedBox(height: 4),
                Text(
                  'In Progress',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 36),
                Text('Task', style: TextStyle(color: AppColors.mutedText)),
                SizedBox(height: 8),
                Text(
                  'صيانة نظام التكييف',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Select New Status',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          for (final status in statuses) ...[
            _StatusOption(
              label: status.label,
              selected: status.transition == _selected,
              onTap: () => setState(() => _selected = status.transition),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          const Text(
            'Add Note (Optional)',
            style: TextStyle(color: AppColors.ink),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Add a note about this status change...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: 'Cancel',
                  onPressed: () => context.popOrGo(AppRoutes.activeTaskDetails),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PrimaryButton(
                  label: _submitting ? 'Updating...' : 'Update Status',
                  onPressed: _submitting ? null : _updateStatus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CompleteTaskScreen extends StatelessWidget {
  const CompleteTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WorkflowScaffold(
      title: 'Complete Task',
      subtitle: 'Follow the steps to finalize',
      showBack: false,
      fallbackRoute: AppRoutes.activeTaskDetails,
      bottom: Padding(
        padding: const EdgeInsets.all(16),
        child: _GreenButton(
          label: 'Continue to Upload After Photos',
          onPressed: () => context.go(AppRoutes.afterPhotos),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _CompletionStep(
            number: '1',
            title: 'Upload After Photos',
            subtitle: 'Take photos of completed\nwork',
            action: 'Start',
            active: true,
          ),
          SizedBox(height: 18),
          _CompletionStep(
            number: '2',
            title: 'Get Client Signature',
            subtitle: 'Client confirmation required',
          ),
          SizedBox(height: 18),
          _CompletionStep(
            number: '3',
            title: 'Rate Service',
            subtitle: 'Rate your experience',
          ),
          SizedBox(height: 18),
          _CompletionStep(
            number: '4',
            title: 'Task Completed!',
            subtitle: 'Complete all steps above to finish',
            disabled: true,
          ),
        ],
      ),
    );
  }
}

class ClientSignatureScreen extends StatefulWidget {
  const ClientSignatureScreen({super.key});

  @override
  State<ClientSignatureScreen> createState() => _ClientSignatureScreenState();
}

class _ClientSignatureScreenState extends State<ClientSignatureScreen> {
  final _signatureKey = GlobalKey();
  final _points = <Offset?>[];
  bool _uploading = false;

  void _clear() {
    setState(_points.clear);
  }

  Future<void> _uploadSignature(String clientName) async {
    if (_points.whereType<Offset>().isEmpty || _uploading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client signature is required.')),
      );
      return;
    }

    setState(() => _uploading = true);
    final bytes = await _signatureBytes();
    if (bytes == null || !mounted) {
      setState(() => _uploading = false);
      return;
    }
    final uploaded = await context
        .read<TasksCubit>()
        .uploadSelectedTaskSignature(bytes: bytes, clientName: clientName);
    if (!mounted) {
      return;
    }
    setState(() => _uploading = false);
    if (uploaded) {
      context.go(AppRoutes.rateService);
    }
  }

  Future<Uint8List?> _signatureBytes() async {
    final boundary = _signatureKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary) {
      return null;
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TasksCubit>().state.selectedTask;
    final clientName = task?.client.isNotEmpty == true
        ? task!.client
        : 'Client unavailable';
    return _WorkflowScaffold(
      title: 'Client Signature',
      fallbackRoute: AppRoutes.afterPhotos,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Client Name',
                  style: TextStyle(color: AppColors.ink),
                ),
                const SizedBox(height: 18),
                Text(clientName, style: const TextStyle(color: AppColors.ink)),
                const SizedBox(height: 46),
                const Text('Sign here', style: TextStyle(color: AppColors.ink)),
                const SizedBox(height: 8),
                RepaintBoundary(
                  key: _signatureKey,
                  child: GestureDetector(
                    onPanStart: (details) =>
                        setState(() => _points.add(details.localPosition)),
                    onPanUpdate: (details) =>
                        setState(() => _points.add(details.localPosition)),
                    onPanEnd: (_) => setState(() => _points.add(null)),
                    child: Container(
                      height: 192,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD1D5DB),
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomPaint(
                        painter: _SignaturePainter(_points),
                        child: Center(
                          child: _points.whereType<Offset>().isEmpty
                              ? const Text(
                                  'Draw signature here',
                                  style: TextStyle(color: AppColors.mutedText),
                                )
                              : const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _SecondaryButton(label: 'Clear', onPressed: _clear),
              ],
            ),
          ),
          const SizedBox(height: 26),
          _PrimaryButton(
            label: _uploading ? 'Uploading...' : 'Next',
            onPressed: _uploading ? null : () => _uploadSignature(clientName),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  const _SignaturePainter(this.points);

  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ink
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var index = 0; index < points.length - 1; index++) {
      final current = points[index];
      final next = points[index + 1];
      if (current != null && next != null) {
        canvas.drawLine(current, next, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class RateServiceScreen extends StatefulWidget {
  const RateServiceScreen({super.key});

  @override
  State<RateServiceScreen> createState() => _RateServiceScreenState();
}

class _RateServiceScreenState extends State<RateServiceScreen> {
  bool _submitting = false;

  Future<void> _completeTask() async {
    if (_submitting) {
      return;
    }
    setState(() => _submitting = true);
    final cubit = context.read<TasksCubit>();
    final ratingSaved = await cubit.submitWorkflowAction(
      TaskWorkflowAction.rating,
      const {'rating': 2},
    );
    if (!ratingSaved || !mounted) {
      setState(() => _submitting = false);
      return;
    }
    final completed = await cubit.transitionSelectedTask(
      TaskTransition.submitForReview,
    );
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    if (completed) {
      context.go(AppRoutes.tasks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _WorkflowScaffold(
      title: 'Rate Service',
      fallbackRoute: AppRoutes.clientSignature,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: _cardDecoration(),
            child: const Column(
              children: [
                Text(
                  'How was the service?',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Color(0xFFF8C400), size: 48),
                    SizedBox(width: 8),
                    Icon(Icons.star, color: Color(0xFFF8C400), size: 48),
                    SizedBox(width: 8),
                    Icon(Icons.star_border, color: Color(0xFFD1D5DB), size: 48),
                    SizedBox(width: 8),
                    Icon(Icons.star_border, color: Color(0xFFD1D5DB), size: 48),
                    SizedBox(width: 8),
                    Icon(Icons.star_border, color: Color(0xFFD1D5DB), size: 48),
                  ],
                ),
                SizedBox(height: 24),
                Text('Fair ⭐⭐', style: TextStyle(color: AppColors.mutedText)),
                SizedBox(height: 46),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Feedback (Optional)',
                    style: TextStyle(color: AppColors.ink),
                  ),
                ),
                SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Share your experience...',
                    style: TextStyle(color: AppColors.mutedText, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          _GreenButton(
            label: _submitting ? 'Completing...' : 'Complete Task',
            onPressed: _submitting ? null : _completeTask,
          ),
        ],
      ),
    );
  }
}

class _WorkflowScaffold extends StatelessWidget {
  const _WorkflowScaffold({
    required this.title,
    required this.fallbackRoute,
    required this.child,
    this.subtitle,
    this.bottom,
    this.showBack = true,
  });

  final String title;
  final String? subtitle;
  final String fallbackRoute;
  final Widget child;
  final Widget? bottom;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OpsHeader(
              title: title,
              subtitle: subtitle,
              fallbackRoute: fallbackRoute,
              showBack: showBack,
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: bottom == null
          ? null
          : Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(top: false, child: bottom!),
            ),
    );
  }
}

class _TaskInfoCard extends StatelessWidget {
  const _TaskInfoCard({
    required this.task,
    required this.status,
    required this.accepted,
    required this.showBeforePhotos,
  });

  final TaskItem task;
  final TaskStatus? status;
  final bool accepted;
  final bool showBeforePhotos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Task ID: ${task.id.isEmpty ? '-' : task.id}',
            style: const TextStyle(color: AppColors.mutedText),
          ),
          const SizedBox(height: 34),
          Row(
            children: [
              if (accepted)
                const _SmallPill(label: 'Accepted', color: Color(0xFF2563EB))
              else if (status != null)
                _SmallPill(label: status!.label, color: status!.color),
              const SizedBox(width: 10),
              _SmallPill(
                label: task.priority.label,
                color: task.priority.color,
                icon: task.priority.icon,
              ),
            ],
          ),
          const SizedBox(height: 56),
          const Divider(color: AppColors.border),
          const SizedBox(height: 28),
          _InfoLine(
            icon: Icons.person_outline,
            label: 'Client',
            value: task.client.isEmpty ? '-' : task.client,
          ),
          const SizedBox(height: 18),
          const _InfoLine(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: '+966501111111',
          ),
          const SizedBox(height: 18),
          _InfoLine(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: task.location.isEmpty ? '-' : task.location,
            extra: 'View on map',
          ),
          const SizedBox(height: 18),
          _InfoLine(
            icon: Icons.access_time,
            label: 'Scheduled Time',
            value: task.time.isEmpty ? '-' : task.time,
          ),
        ],
      ),
    );
  }
}

class _TaskDetailsBottom extends StatelessWidget {
  const _TaskDetailsBottom({required this.stage});

  final TaskDetailsStage stage;

  @override
  Widget build(BuildContext context) {
    if (stage == TaskDetailsStage.pending) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _SecondaryButton(
                label: 'Reject Task',
                icon: Icons.cancel_outlined,
                onPressed: () async {
                  final rejected = await context
                      .read<TasksCubit>()
                      .transitionSelectedTask(TaskTransition.reject);
                  if (rejected && context.mounted) {
                    context.popOrGo(AppRoutes.tasks);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PrimaryButton(
                label: 'Accept Task',
                icon: Icons.check_circle_outline,
                onPressed: () => context.go(AppRoutes.acceptTask),
              ),
            ),
          ],
        ),
      );
    }
    if (stage == TaskDetailsStage.accepted) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: _PrimaryButton(
          label: 'Start Task',
          onPressed: () => context.go(AppRoutes.taskCheckIn),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _GreenButton(
        label: 'Complete Task',
        onPressed: () => context.go(AppRoutes.completeTask),
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 42),
          Text(
            description.isEmpty ? '-' : description,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColors.mutedText,
              fontSize: 16,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _BeforePhotosSummary extends StatelessWidget {
  const _BeforePhotosSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Before Photos',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 40),
          Row(children: [_BlankPhoto(), SizedBox(width: 10), _BlankPhoto()]),
        ],
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.05,
      children: [
        _ActionBox(
          icon: Icons.inventory_2_outlined,
          label: 'Materials',
          onTap: () => context.go(AppRoutes.materials),
        ),
        _ActionBox(
          icon: Icons.attach_money,
          label: 'Expenses',
          onTap: () => context.go(AppRoutes.expenses),
        ),
        _ActionBox(
          icon: Icons.note_alt_outlined,
          label: 'Add Note',
          onTap: () => context.go(AppRoutes.addNote),
        ),
        _ActionBox(
          icon: Icons.edit_outlined,
          label: 'Update Status',
          onTap: () => context.go(AppRoutes.updateStatus),
        ),
      ],
    );
  }
}

class _ListEntryScreen extends StatelessWidget {
  const _ListEntryScreen({
    required this.title,
    required this.summaryLabel,
    required this.summaryValue,
    required this.icon,
    required this.iconColor,
    required this.sectionTitle,
    required this.emptyIcon,
    required this.emptyText,
    required this.addTitle,
    required this.addSubtitle,
    required this.entries,
    required this.onAdd,
  });

  final String title;
  final String summaryLabel;
  final String summaryValue;
  final IconData icon;
  final Color iconColor;
  final String sectionTitle;
  final IconData emptyIcon;
  final String emptyText;
  final String addTitle;
  final String addSubtitle;
  final List<String> entries;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return _WorkflowScaffold(
      title: title,
      fallbackRoute: AppRoutes.activeTaskDetails,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              border: Border.all(color: iconColor.withValues(alpha: 0.35)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summaryLabel,
                        style: const TextStyle(color: AppColors.mutedText),
                      ),
                      Text(
                        summaryValue,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(icon, color: iconColor, size: 50),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: Text(
                  sectionTitle,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.darkSlate,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (entries.isEmpty)
            Container(
              height: 174,
              decoration: _cardDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(emptyIcon, color: const Color(0xFFD1D5DB), size: 52),
                  const SizedBox(height: 28),
                  Text(
                    emptyText,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            for (final entry in entries) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Icon(emptyIcon, color: iconColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>?> _showMaterialDialog(BuildContext context) {
  final nameController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final costController = TextEditingController(text: '0');
  final notesController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return _EntryDialog(
        title: 'Add Material',
        subtitle: 'Enter the material details below',
        children: [
          _DialogTextField(
            controller: nameController,
            label: 'Material Name *',
            hint: 'e.g., Electrical Cable',
          ),
          Row(
            children: [
              Expanded(
                child: _DialogTextField(
                  controller: quantityController,
                  label: 'Quantity *',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _DialogTextField(
                  controller: costController,
                  label: r'Cost ($) *',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          _DialogTextField(
            controller: notesController,
            label: 'Notes',
            hint: 'Optional notes...',
          ),
        ],
        onSave: () {
          final name = nameController.text.trim();
          if (name.isEmpty) {
            return null;
          }
          return {
            'name': name,
            'quantity': num.tryParse(quantityController.text.trim()) ?? 1,
            'cost': num.tryParse(costController.text.trim()) ?? 0,
            if (notesController.text.trim().isNotEmpty)
              'notes': notesController.text.trim(),
          };
        },
      );
    },
  );
}

Future<Map<String, dynamic>?> _showExpenseDialog(BuildContext context) {
  final typeController = TextEditingController();
  final amountController = TextEditingController(text: '0');
  final notesController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return _EntryDialog(
        title: 'Add Expense',
        subtitle: 'Enter the expense details below',
        children: [
          _DialogTextField(
            controller: typeController,
            label: 'Expense Type *',
            hint: 'Fuel, parking, materials...',
          ),
          _DialogTextField(
            controller: amountController,
            label: r'Amount ($) *',
            keyboardType: TextInputType.number,
          ),
          _DialogTextField(
            controller: notesController,
            label: 'Notes',
            hint: 'Optional notes...',
          ),
        ],
        onSave: () {
          final type = typeController.text.trim();
          if (type.isEmpty) {
            return null;
          }
          return {
            'type': type,
            'amount': num.tryParse(amountController.text.trim()) ?? 0,
            if (notesController.text.trim().isNotEmpty)
              'notes': notesController.text.trim(),
          };
        },
      );
    },
  );
}

class _EntryDialog extends StatelessWidget {
  const _EntryDialog({
    required this.title,
    required this.subtitle,
    required this.children,
    required this.onSave,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Map<String, dynamic>? Function() onSave;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 18, 26, 26),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.mutedText),
              ),
              const SizedBox(height: 18),
              ...children,
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryButton(
                      label: 'Save',
                      onPressed: () {
                        final payload = onSave();
                        if (payload == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Required fields are missing.'),
                            ),
                          );
                          return;
                        }
                        Navigator.of(context).pop(payload);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  const _DialogTextField({
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
        ),
      ),
    );
  }
}

class _CompletionStep extends StatelessWidget {
  const _CompletionStep({
    required this.number,
    required this.title,
    required this.subtitle,
    this.action,
    this.active = false,
    this.disabled = false,
  });

  final String number;
  final String title;
  final String subtitle;
  final String? action;
  final bool active;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: disabled ? const Color(0xFFF3F4F6) : Colors.white,
        border: Border.all(color: AppColors.border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: disabled ? const Color(0xFF9CA3AF) : Colors.white,
            foregroundColor: disabled ? Colors.white : AppColors.mutedText,
            child: Text(number),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
          if (action != null)
            FilledButton(
              onPressed: () => context.go(AppRoutes.afterPhotos),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.darkSlate,
              ),
              child: Text(action!),
            ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({required this.label, this.selected = false, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF3E8FF) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFFD8B4FE) : AppColors.border,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF9333EA).withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? const Color(0xFF7E22CE) : AppColors.ink,
                  fontSize: 16,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_outline, color: Color(0xFF7E22CE)),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
    this.extra,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF9CA3AF), size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.mutedText)),
              const SizedBox(height: 4),
              Text(
                value,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (extra != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.navigation_outlined,
                      size: 16,
                      color: AppColors.ink,
                    ),
                    const SizedBox(width: 10),
                    Text(extra!, style: const TextStyle(color: AppColors.ink)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniTaskCard extends StatelessWidget {
  const _MiniTaskCard({required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _CompactInfo(
            icon: Icons.person_outline,
            text: task.client.isEmpty ? '-' : task.client,
          ),
          const SizedBox(height: 8),
          _CompactInfo(
            icon: Icons.location_on_outlined,
            text: task.location.isEmpty ? '-' : task.location,
          ),
          const SizedBox(height: 8),
          _CompactInfo(
            icon: Icons.access_time,
            text: task.time.isEmpty ? '-' : task.time,
          ),
        ],
      ),
    );
  }
}

class _CompactInfo extends StatelessWidget {
  const _CompactInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.mutedText),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: AppColors.mutedText),
          ),
        ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 1.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({this.filePath});

  final String? filePath;

  @override
  Widget build(BuildContext context) {
    final path = filePath;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: path == null
              ? const Icon(
                  Icons.image_outlined,
                  color: Color(0xFF9CA3AF),
                  size: 34,
                )
              : Image.file(File(path), fit: BoxFit.cover),
        ),
        if (path != null)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFFF3045),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.icon,
    required this.label,
    this.compact = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: compact ? 36 : 96,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border, width: 1.3),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.ink, size: 18),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.ink, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlankPhoto extends StatelessWidget {
  const _BlankPhoto();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98,
      height: 98,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _ActionBox extends StatelessWidget {
  const _ActionBox({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border, width: 1.3),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.ink, size: 20),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: AppColors.ink)),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 46),
    );
  }
}

class _RoundBadgeIcon extends StatelessWidget {
  const _RoundBadgeIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.darkSlate,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _GreenButton extends StatelessWidget {
  const _GreenButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.enterpriseGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.border, width: 1.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    border: Border.all(color: AppColors.border, width: 1.3),
    borderRadius: BorderRadius.circular(14),
  );
}

BoxDecoration _bluePanelDecoration() {
  return BoxDecoration(
    color: const Color(0xFFEFF6FF),
    border: Border.all(color: const Color(0xFFB6D6FF), width: 1.4),
    borderRadius: BorderRadius.circular(14),
  );
}
