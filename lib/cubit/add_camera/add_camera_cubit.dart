import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'add_camera_state.dart';

class AddCameraCubit extends Cubit<AddCameraState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AddCameraCubit() : super(AddCameraInitial());

  Future<void> loadDeviceStreamMap() async {
    emit(AddCameraLoading());

    final existingData = await _storage.read(key: 'device_stream_map');
    if (existingData != null) {
      final decoded = jsonDecode(existingData);
      if (decoded is Map) {
        final deviceStreamMap = decoded.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
        );
        emit(AddCameraLoaded(deviceStreamMap));
        return;
      }
    }

    emit(AddCameraLoaded({}));
  }

  Future<void> removeCamera(String deviceTopic) async {
    if (state is AddCameraLoaded) {
      final currentMap = Map<String, String>.from(
        (state as AddCameraLoaded).deviceStreamMap,
      );
      currentMap.remove(deviceTopic);
      await _storage.write(
        key: 'device_stream_map',
        value: jsonEncode(currentMap),
      );
      emit(AddCameraLoaded(currentMap));
    }
  }
}
