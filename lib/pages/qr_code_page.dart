import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final _storage = const FlutterSecureStorage();
  String? authTopic;
  late MqttServerClient _client;

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isWaitingForResponse = false;

  void _connectMQTT(String topic) async {
      _client = MqttServerClient.withPort(
          'b16ed41a7caf46488f1fcebc76b78e95.s1.eu.hivemq.cloud',
          'flutter_client',
          8883,);
      _client.logging(on: false);
      _client.secure = true;
      _client.keepAlivePeriod = 20;
      _client.setProtocolV311();
      _client.securityContext = SecurityContext.defaultContext;

      final connMessage = MqttConnectMessage()
          .withClientIdentifier('flutter_client')
          .authenticateAs('Broke', 'Xx1234567890')
          .withWillQos(MqttQos.atMostOnce);
      _client.connectionMessage = connMessage;

    try {
      await _client.connect();
      _client.subscribe('auth', MqttQos.atMostOnce);
      _client.unsubscribe(authTopic!);
      _client.updates!.listen((c) async {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
            message.payload.message,);


          final decoded = jsonDecode(payload);
          if (decoded['sender'] != 'EspCam') {
            return;
          }

          final String? streamTopic = decoded['stream_topic'] as String?;
          final existing = await _storage.read(key: 'device_stream_map');
          Map<String, String> deviceStreamMap = {};
          if (existing != null) {
            final decodedMap = jsonDecode(existing);
            if (decodedMap is Map) {
              deviceStreamMap = decodedMap.map((key, value) =>
                  MapEntry(key.toString(), value.toString()),);
            }
          }

          if (streamTopic != null) {
            deviceStreamMap[authTopic!] = streamTopic;
          }
          await _storage.write(
              key: 'device_stream_map', value: jsonEncode(deviceStreamMap),);

          if (!mounted) return;

          setState(() {
            isWaitingForResponse = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Saved stream topic: $streamTopic')),);

      });
    } catch (e) {
      _client.disconnect();
    }
  }

  void _sendAuth(String login, String password) {
    final authMessage = '$login:$password';
    final builder = MqttClientPayloadBuilder();
    builder.addString(authMessage);

    if (authTopic != null) {
      _client.publishMessage('secret_auth', MqttQos.atMostOnce,
          builder.payload!,);

      setState(() {
        isWaitingForResponse = true;
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (isWaitingForResponse) {
          _client.disconnect();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to receive response')),);
        }
      });
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final String? topic = capture.barcodes.first.rawValue;
    if (topic != null) {
      setState(() {
        authTopic = topic;
      });
      _connectMQTT(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (authTopic == null) {
      return Scaffold(
        body: MobileScanner(onDetect: _onDetect),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                  controller: loginController,
                  decoration: const InputDecoration(labelText: 'Login'),),
              TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _sendAuth(loginController.text, passwordController.text);
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
