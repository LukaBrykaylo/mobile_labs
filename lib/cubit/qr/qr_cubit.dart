import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(QrInitial());

  final _storage = const FlutterSecureStorage();
  late MqttServerClient _client;
  String? _authTopic;
  bool _isWaitingForResponse = false;

  String? get authTopic => _authTopic;

  void scanTopic(String topic) async {
    _authTopic = topic;
    emit(QrScanSuccess(topic));
    _connectMQTT(topic);
  }

  Future<void> _connectMQTT(String topic) async {
    _client = MqttServerClient.withPort(
      'b16ed41a7caf46488f1fcebc76b78e95.s1.eu.hivemq.cloud',
      'flutter_client',
      8883,
    );
    _client.secure = true;
    _client.setProtocolV311();
    _client.keepAlivePeriod = 20;
    _client.securityContext = SecurityContext.defaultContext;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs('Broke', 'Xx1234567890')
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
      _client.subscribe('auth', MqttQos.atMostOnce);
      _client.unsubscribe(_authTopic!);

      _client.updates!.listen((c) async {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        final decoded = jsonDecode(payload);

        if (decoded['sender'] != 'EspCam') return;

        final streamTopic = decoded['stream_topic']?.toString();
        if (streamTopic != null) {
          final existing = await _storage.read(key: 'device_stream_map');
          Map<String, String> deviceStreamMap = {};
          if (existing != null) {
            final decodedMap = jsonDecode(existing);
            if (decodedMap is Map) {
              deviceStreamMap = decodedMap.map(
                  (key, value) => MapEntry(key.toString(), value.toString()),);
            }
          }
          deviceStreamMap[_authTopic!] = streamTopic;
          await _storage.write(
              key: 'device_stream_map', value: jsonEncode(deviceStreamMap),);
          emit(QrAuthenticated(streamTopic));
        }
      });
    } catch (e) {
      _client.disconnect();
      emit(QrError('Failed to connect to MQTT'));
    }
  }

  void sendAuth(String login, String password) {
    final authMessage = '$login:$password';
    final builder = MqttClientPayloadBuilder()..addString(authMessage);

    if (_authTopic != null) {
      _client.publishMessage(
          'secret_auth', MqttQos.atMostOnce, builder.payload!,);
      _isWaitingForResponse = true;
      emit(QrWaiting());

      Future.delayed(const Duration(seconds: 5), () {
        if (_isWaitingForResponse) {
          _client.disconnect();
          emit(QrError('Failed to receive response'));
        }
      });
    }
  }
}
