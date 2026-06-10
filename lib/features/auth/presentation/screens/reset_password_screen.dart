import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_shell.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.passwordFlowReady) {
          context.go(AppRoutes.login);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        return AuthShell(
          title: 'Create new password',
          subtitle: 'Choose a strong password for secure mobile access.',
          child: Column(
            children: [
              AppInput(
                label: 'New password',
                controller: _passwordController,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              AppInput(
                label: 'Confirm password',
                controller: _confirmController,
                prefixIcon: Icons.lock_reset_outlined,
                obscureText: true,
              ),
              const SizedBox(height: 22),
              AppButton(
                label: isLoading ? 'Saving...' : 'Save password',
                icon: Icons.check,
                onPressed: isLoading
                    ? null
                    : () => context.read<AuthCubit>().resetPassword(
                        _passwordController.text,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
