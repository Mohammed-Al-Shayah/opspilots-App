import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_skeleton.dart';
import '../../../role/domain/user_role.dart';
import '../../../role/presentation/cubit/role_cubit.dart';
import '../cubit/workspace_cubit.dart';

class WorkspaceSelectionScreen extends StatelessWidget {
  const WorkspaceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WorkspaceCubit>().state;
    if (state.status == WorkspaceStatus.initial) {
      Future.microtask(() {
        if (context.mounted) {
          context.read<WorkspaceCubit>().loadWorkspaces();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Select workspace')),
      body: switch (state.status) {
        WorkspaceStatus.loading => const AppLoadingSkeleton(itemCount: 3),
        WorkspaceStatus.failure => _WorkspaceFailure(
          message: state.errorMessage ?? 'Could not load workspaces.',
        ),
        WorkspaceStatus.empty => const AppEmptyState(
          title: 'No workspaces',
          message: 'Your account is not assigned to any workspace yet.',
        ),
        _ => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Choose company', style: AppTextStyles.headline),
            const SizedBox(height: 8),
            Text(
              'Workspace context controls visible roles, modules, and data.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            ...state.workspaces.map((workspace) {
              final isSelected = state.selectedWorkspace?.id == workspace.id;
              final hasRoles = workspace.availableRoles.isNotEmpty;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  onTap: () {
                    if (!hasRoles) {
                      return;
                    }
                    context.read<WorkspaceCubit>().selectWorkspace(workspace);
                    final selectedRole = context
                        .read<RoleCubit>()
                        .state
                        .selectedRole;
                    if (!workspace.availableRoles.contains(selectedRole)) {
                      context.read<RoleCubit>().selectRole(
                        workspace.availableRoles.first,
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              workspace.name,
                              style: AppTextStyles.title,
                            ),
                          ),
                          if (hasRoles)
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? AppColors.teal
                                  : AppColors.textSecondary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(workspace.industry, style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text(workspace.location, style: AppTextStyles.caption),
                      const SizedBox(height: 12),
                      if (hasRoles)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: workspace.availableRoles
                              .map(
                                (role) => AppBadge(
                                  label: role.labelEn,
                                  color: AppColors.navy,
                                ),
                              )
                              .toList(),
                        )
                      else
                        Text(
                          'No roles are assigned to this workspace.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                state.errorMessage!,
                style: AppTextStyles.caption.copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: 12),
            AppButton(
              label: state.status == WorkspaceStatus.selecting
                  ? 'Selecting workspace...'
                  : 'Continue to role preview',
              icon: state.status == WorkspaceStatus.selecting
                  ? Icons.hourglass_empty
                  : Icons.arrow_forward,
              onPressed:
                  state.selectedWorkspace == null ||
                      state.status == WorkspaceStatus.selecting
                  ? null
                  : () async {
                      final role = context.read<RoleCubit>().state.selectedRole;
                      final activated = await context
                          .read<WorkspaceCubit>()
                          .activateSelectedWorkspace(role);
                      if (activated && context.mounted) {
                        context.go(AppRoutes.rolePreview);
                      }
                    },
            ),
          ],
        ),
      },
    );
  }
}

class _WorkspaceFailure extends StatelessWidget {
  const _WorkspaceFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppEmptyState(
            title: 'Could not load workspaces',
            message: message,
            icon: Icons.cloud_off_outlined,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Try again',
            icon: Icons.refresh,
            onPressed: () => context.read<WorkspaceCubit>().loadWorkspaces(),
          ),
        ],
      ),
    );
  }
}
