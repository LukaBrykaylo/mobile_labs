import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/profile/profile_state.dart';
import 'package:mobile_labs/service/auth_service.dart';
import 'package:mobile_labs/service/network_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final IAuthService authService;
  final NetworkService networkService;

  ProfileCubit({
    required this.authService,
    required this.networkService,
  }) : super(ProfileState(isLoading: true)) {
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      emit(state.copyWith(isLoading: true));
      final loggedIn = await authService.isLoggedIn();
      if (loggedIn) {
        final userInfo = await authService.getUserInfo();
        emit(state.copyWith(
          isLoading: false,
          name: userInfo['name'],
          email: userInfo['email'],
        ),);
      } else {
        emit(state.copyWith(isLoading: false, error: 'User not logged in'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> logOut() async {
    try {
      await authService.logOut();
      emit(state.copyWith(loggedOut: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
