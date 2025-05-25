import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/cubit/camera/camera_state.dart';
import 'package:mobile_labs/service/temp_isolate_service.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState.initial());

  FlutterIsolate? _isolate;
  SendPort? _isolateSendPort;
  ReceivePort? _receivePort;
  Timer? _timer;
  final _storage = const FlutterSecureStorage();

  Future<void> initialize() async {
    await _loadDeviceStreamMap();
    await _startIsolate();
  }

  Future<void> _loadDeviceStreamMap() async {
    final existing = await _storage.read(key: 'device_stream_map');
    if (existing != null) {
      final decoded = jsonDecode(existing);
      if (decoded is Map) {
        emit(
          state.copyWith(deviceStreamMap: Map<String, String>.from(decoded)),
        );
      }
    }
  }

  Future<void> _startIsolate() async {
    _receivePort = ReceivePort();
    _isolate =
        await FlutterIsolate.spawn(temperatureIsolate, _receivePort!.sendPort);

    _receivePort!.listen((data) {
      if (data is SendPort) {
        _isolateSendPort = data;
        _startTemperatureUpdates();
      } else if (data is Map<String, double>) {
        emit(state.copyWith(temperatures: data));
      }
    });
  }

  void _startTemperatureUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _isolateSendPort?.send(state.deviceStreamMap.keys.toList());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _receivePort?.close();
    _isolate?.kill();
    return super.close();
  }
}
