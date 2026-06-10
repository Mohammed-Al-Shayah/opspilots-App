import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_shell.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _codeController = TextEditingController(text: '482913');

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.passwordFlowReady) {
          context.go(AppRoutes.resetPassword);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        return AuthShell(
          title: 'Verify code',
          subtitle: 'Use the six-digit code sent to your email.',
          child: Column(
            children: [
              AppInput(
                label: 'Verification code',
                controller: _codeController,
                prefixIcon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 22),
              AppButton(
                label: isLoading ? 'Verifying...' : 'Verify',
                icon: Icons.verified_outlined,
                onPressed: isLoading
                    ? null
                    : () => context.read<AuthCubit>().verifyOtp(
                        _codeController.text,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
