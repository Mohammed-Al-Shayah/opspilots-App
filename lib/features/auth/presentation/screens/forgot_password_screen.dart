import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_shell.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController(text: 'field@opspilot.app');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.passwordFlowReady) {
          context.go(AppRoutes.otp);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        return AuthShell(
          title: 'Reset password',
          subtitle:
              'Enter your work email and we will send a verification code.',
          child: Column(
            children: [
              AppInput(
                label: 'Work email',
                controller: _emailController,
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 22),
              AppButton(
                label: isLoading ? 'Sending...' : 'Send code',
                icon: Icons.send_outlined,
                onPressed: isLoading
                    ? null
                    : () => context.read<AuthCubit>().requestPasswordReset(
                        _emailController.text,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
