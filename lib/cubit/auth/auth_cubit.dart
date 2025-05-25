import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/service/auth_service.dart';

class AuthCubit extends Cubit<void> {
  final IAuthService authService;

  AuthCubit({required this.authService}) : super(null);

  void logIn(BuildContext context, String username, String password) {
    authService.logIn(context, username, password);
  }

  void signUp(
      BuildContext context,
      String name,
      String email,
      String password,
      ) {
    authService.signUp(context, name, email, password);
  }
}
