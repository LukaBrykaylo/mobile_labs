part of 'add_camera_cubit.dart';

abstract class AddCameraState {}

class AddCameraInitial extends AddCameraState {}

class AddCameraLoading extends AddCameraState {}

class AddCameraLoaded extends AddCameraState {
  final Map<String, String> deviceStreamMap;

  AddCameraLoaded(this.deviceStreamMap);
}
