import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/camera_stream/camera_stream_state.dart';
import 'package:mobile_labs/service/mqtt_services/mqtt_service.dart';

class CameraStreamCubit extends Cubit<CameraStreamState> {
  final String topic;
  late final MQTTService _mqttService;

  CameraStreamCubit(this.topic) : super(CameraStreamInitial()) {
    _mqttService = MQTTService(
      broker: 'b16ed41a7caf46488f1fcebc76b78e95.s1.eu.hivemq.cloud',
      topic: topic,
      username: 'Broke',
      password: 'Xx1234567890',
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
