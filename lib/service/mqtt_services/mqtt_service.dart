import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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

  Future<void> unpair(String targetTopic) async {
    final existing = await _storage.read(key: 'device_stream_map');
    Map<String, String> deviceStreamMap = {};

    if (existing != null) {
      final decodedMap = jsonDecode(existing);
      if (decodedMap is Map) {
        deviceStreamMap = decodedMap.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        );
      }
    }

    String? foundKey;
    deviceStreamMap.forEach((key, value) {
      if (value == targetTopic) {
        foundKey = key;
      }
    });

    if (foundKey != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString('disconnect');
      _client.publishMessage(foundKey!, MqttQos.atMostOnce, builder.payload!);
      deviceStreamMap.remove(foundKey);
      await _storage.write(
          key: 'device_stream_map', value: jsonEncode(deviceStreamMap),);
    }
  }
}
