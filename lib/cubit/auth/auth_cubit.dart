import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/service/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

  Future<void> logIn(String username, String password) async {
    emit(AuthLoading());
    final success = await authService.logIn(username, password);
    if (success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure('Invalid username or password'));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(AuthLoading());
    final success = await authService.signUp(name, email, password);
    if (success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure('Failed to sign up'));
    }
  }
}
