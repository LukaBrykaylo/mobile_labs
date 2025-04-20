import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef MessageCallback = void Function(String message);

class MQTTService {
  final String broker;
  final String topic;
  final String username;
  final String password;
  final MessageCallback onMessageReceived;

  late MqttServerClient _client;

  MQTTService({
    required this.broker,
    required this.topic,
    required this.username,
    required this.password,
    required this.onMessageReceived,
  }) {
    _client = MqttServerClient.withPort(broker, 'flutter_client', 8883);
    _client.logging(on: false);
    _client.secure = true;
    _client.keepAlivePeriod = 20;
    _client.setProtocolV311();
    _client.securityContext = SecurityContext.defaultContext;
  }

  Future<void> connect() async {
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs(username, password)
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
      if (_client.connectionStatus!.state == MqttConnectionState.connected) {
        final subResult = _client.subscribe(topic, MqttQos.atMostOnce);
        if (subResult == null) {
          disconnect();
        }

        _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
          final payload =
              MqttPublishPayload.bytesToStringAsString(message.payload.message);

          onMessageReceived(payload);
        });
      } else {
        disconnect();
      }
    } catch (e) {
      disconnect();
    }
  }

  void disconnect() {
    _client.disconnect();
  }
}
