import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

enum AuthStatus { initial, loading, authenticated, failure, passwordFlowReady }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.email = '',
  });

  final AuthStatus status;
  final AuthUserEntity? user;
  final String? errorMessage;
  final String email;

  AuthState copyWith({
    AuthStatus? status,
    AuthUserEntity? user,
    String? errorMessage,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, email];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthState());

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    if (email.trim().isEmpty || password.trim().length < 6) {
      const failure = ValidationFailure(
        'Use any valid email and a password with at least 6 characters.',
      );
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
          email: email,
        ),
      );
      return;
    }

    final result = await _loginUseCase(
      LoginParams(emailOrPhone: email, password: password),
    );
    result.when(
      success: (session) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            email: email,
            user: session.user,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: failure.message,
            email: email,
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    final result = await _logoutUseCase();
    result.when(
      success: (_) => emit(const AuthState()),
      failure: (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> requestPasswordReset(String email) async {
    emit(state.copyWith(status: AuthStatus.loading, email: email));
    await Future<void>.delayed(const Duration(milliseconds: 350));
    emit(state.copyWith(status: AuthStatus.passwordFlowReady, email: email));
  }

  Future<void> verifyOtp(String code) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 350));
    emit(state.copyWith(status: AuthStatus.passwordFlowReady));
  }

  Future<void> resetPassword(String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 350));
    emit(state.copyWith(status: AuthStatus.passwordFlowReady));
  }
}
