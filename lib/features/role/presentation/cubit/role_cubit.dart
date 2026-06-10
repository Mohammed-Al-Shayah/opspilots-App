import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_default_role_usecase.dart';
import '../../domain/usecases/select_role_usecase.dart';
import '../../domain/user_role.dart';

class RoleState extends Equatable {
  const RoleState({this.selectedRole = UserRole.fieldEmployee});

  final UserRole selectedRole;

  RoleState copyWith({UserRole? selectedRole}) {
    return RoleState(selectedRole: selectedRole ?? this.selectedRole);
  }

  @override
  List<Object> get props => [selectedRole];
}

class RoleCubit extends Cubit<RoleState> {
  RoleCubit({
    required GetDefaultRoleUseCase getDefaultRoleUseCase,
    required SelectRoleUseCase selectRoleUseCase,
  }) : _getDefaultRoleUseCase = getDefaultRoleUseCase,
       _selectRoleUseCase = selectRoleUseCase,
       super(const RoleState());

  final GetDefaultRoleUseCase _getDefaultRoleUseCase;
  final SelectRoleUseCase _selectRoleUseCase;

  Future<void> loadDefaultRole() async {
    final result = await _getDefaultRoleUseCase();
    result.when(
      success: (role) => emit(state.copyWith(selectedRole: role)),
      failure: (_) {},
    );
  }

  Future<void> selectRole(UserRole role) async {
    final result = await _selectRoleUseCase(role);
    result.when(
      success: (selectedRole) =>
          emit(state.copyWith(selectedRole: selectedRole)),
      failure: (_) => emit(state.copyWith(selectedRole: role)),
    );
  }
}
