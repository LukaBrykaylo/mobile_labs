import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_labs/service/mqtt_services/mqtt_service.dart';

class CameraStreamPage extends StatefulWidget {
  final String topic;

  const CameraStreamPage({required this.topic, super.key});

  @override
  State<CameraStreamPage> createState() => _CameraStreamPageState();
}

class _CameraStreamPageState extends State<CameraStreamPage> {
  late MQTTService _mqttService;
  Uint8List? _latestImage;

  @override
  void initState() {
    super.initState();
    _mqttService = MQTTService(
      broker: 'b16ed41a7caf46488f1fcebc76b78e95.s1.eu.hivemq.cloud',
      topic: widget.topic,
      username: 'Broke',
      password: 'Xx1234567890',
      onMessageReceived: (message) {
        try {
          if (message.trim().isNotEmpty) {
            setState(() {
              _latestImage = base64Decode(message);
            });
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error decoding image')),
          );
        }
      },
    );
    _mqttService.connect();
  }

  void _handleDisconnect() {
    _mqttService.unpair(widget.topic);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disconnected from camera')),
    );
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/elements/photos/background_small.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: _latestImage != null
                ? Image.memory(_latestImage!)
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Waiting for response',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleDisconnect,
                icon: const Icon(Icons.stop_circle),
                label: const Text('Disconnect'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
