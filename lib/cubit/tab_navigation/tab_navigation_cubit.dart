import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/tab_navigation/tab_navigation_state.dart';

class TabNavigationCubit extends Cubit<TabNavigationState> {
  TabNavigationCubit() : super(const ProfileTab());

  void changeTab(int index) {
    switch (index) {
      case 0:
        emit(const ProfileTab());
        break;
      case 1:
        emit(const CameraTab());
        break;
      case 2:
        emit(const AddCameraTab());
        break;
    }
  }
}
