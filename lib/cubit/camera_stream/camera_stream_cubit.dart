import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/camera_stream/camera_stream_state.dart';
import 'package:mobile_labs/elements/constants/mqtt_constants.dart';
import 'package:mobile_labs/service/mqtt_services/mqtt_service.dart';

class CameraStreamCubit extends Cubit<CameraStreamState> {
  final String topic;
  late final MQTTService _mqttService;

  CameraStreamCubit(this.topic) : super(CameraStreamInitial()) {
    _mqttService = MQTTService(
      broker: mqttBroker,
      topic: topic,
      username: mqttUsername,
      password: mqttPassword,
      onMessageReceived: (message) {
        if (message.trim().isEmpty) return;
        try {
          final imageBytes = base64Decode(message);
          emit(CameraStreamImage(imageBytes));
        } catch (_) {
          emit(CameraStreamError('Error decoding image'));
        }
      },
    );
    _mqttService.connect();
  }

  void disconnect() async {
    await _mqttService.unpair(topic);
    _mqttService.disconnect();
    emit(CameraStreamDisconnected());
  }

  @override
  Future<void> close() {
    _mqttService.disconnect();
    return super.close();
  }
}
