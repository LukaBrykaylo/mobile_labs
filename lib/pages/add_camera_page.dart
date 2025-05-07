import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddCameraPage extends StatefulWidget {
  const AddCameraPage({super.key});

  @override
  AddCameraPageState createState() => AddCameraPageState();
}

class AddCameraPageState extends State<AddCameraPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Map<String, String> deviceStreamMap = {};

  @override
  void initState() {
    super.initState();
    _loadDeviceStreamMap();
  }

  Future<void> _loadDeviceStreamMap() async {
    final existingData = await _storage.read(key: 'device_stream_map');
    if (existingData != null) {
      final decoded = jsonDecode(existingData);
      if (decoded is Map) {
        setState(() {
          deviceStreamMap = decoded.map((key, value) =>
              MapEntry(key.toString(), value.toString()),);
        });
      }
    }
  }

  void _addCamera() {
    Navigator.pushNamed(context, '/qr_code').then((_) => _loadDeviceStreamMap());
  }

  Future<void> _removeCamera(String deviceTopic) async {
    setState(() {
      deviceStreamMap.remove(deviceTopic);
    });
    await _storage.write(key: 'device_stream_map',
        value: jsonEncode(deviceStreamMap),);
  }

  Widget _buildCameraItem(String deviceTopic, String streamTopic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white30, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Device: $deviceTopic',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Stream: $streamTopic',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.deepOrange),
            onPressed: () => _removeCamera(deviceTopic),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraList() {
    if (deviceStreamMap.isEmpty) {
      return const Center(
        child: Text(
          'No connected cameras',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: deviceStreamMap.entries.map((entry) {
        return _buildCameraItem(entry.key, entry.value);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/elements/photos/background_small.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: _addCamera,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 0.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 60),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Connected Cameras:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildCameraList()),
            ],
          ),
        ],
      ),
    );
  }
}
