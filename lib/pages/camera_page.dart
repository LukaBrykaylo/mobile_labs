import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/service/mqtt_services/camera_stream_page.dart';
import 'package:mobile_labs/service/temp_isolate_service.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  FlutterIsolate? _isolate;
  SendPort? _isolateSendPort;
  ReceivePort? _receivePort;
  late Timer _timer;
  Map<String, double> _temperatures = {};
  final _storage = const FlutterSecureStorage();
  Map<String, String> deviceStreamMap = {};

  @override
  void initState() {
    super.initState();
    _loadDeviceStreamMap().then((_) => _startIsolate());
  }

  Future<void> _loadDeviceStreamMap() async {
    final existing = await _storage.read(key: 'device_stream_map');
    if (existing != null) {
      final decoded = jsonDecode(existing);
      if (decoded is Map) {
        setState(() {
          deviceStreamMap =
              decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
        });
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
        setState(() => _temperatures = data);
      }
    });
  }

  void _startTemperatureUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _isolateSendPort?.send(deviceStreamMap.keys.toList());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _receivePort?.close();
    _isolate?.kill();
    super.dispose();
  }

  Widget _buildCameraCard(String name, double temp) {
    return GestureDetector(
      onTap: () => _onCameraTapped(name),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Stack(
          children: [
            const Center(
                child: Icon(Icons.image, color: Colors.white, size: 40),),
            Positioned(
                bottom: 10, left: 10, child: Text(name, style: _textStyle()),),
            Positioned(top: 10, right: 10, child: _buildTemperatureBadge(temp)),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle() => const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,);

  Widget _buildTemperatureBadge(double temp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(8),),
      child: Text('${temp.toStringAsFixed(1)}°C',
          style: const TextStyle(
              color: Colors.white, fontSize: 14,
            fontWeight: FontWeight.bold,),),
    );
  }

  Future<void> _onCameraTapped(String name) async {
    final topic = deviceStreamMap[name];
    if (topic != null) {
      Navigator.push(context,
          MaterialPageRoute<void>(builder: (_) =>
              CameraStreamPage(topic: topic),),);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Topic not found for this camera')),);
    }
  }

  @override
  Widget build(BuildContext context) {
    final names = deviceStreamMap.keys.toList();
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('lib/elements/photos/background_small.jpg',
                  fit: BoxFit.cover,),),
          Column(
            children: [
              const SizedBox(height: 90),
              Expanded(
                child: names.isEmpty
                    ? const Center(
                        child: Text('No connected cameras',
                            style:
                                TextStyle(color: Colors.white70,
                                    fontSize: 18,),),)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: names.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildCameraCard(
                              names[i], _temperatures[names[i]] ?? 0.0,),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
