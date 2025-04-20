import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final List<String> cameraNames;

  const CameraPage({required this.cameraNames, super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  final Random _random = Random();
  late Timer _timer;
  Map<String, double> _temperatures = {};

  @override
  void initState() {
    super.initState();
    _updateTemperatures();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _updateTemperatures(),
    );
  }

  void _updateTemperatures() {
    setState(() {
      _temperatures = {
        for (var camera in widget.cameraNames)
          camera: 20 + _random.nextDouble() * 15,
      };
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildCameraCard(String cameraName, double temperature) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/camera_view'),
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
              child: Icon(Icons.image, color: Colors.white, size: 40),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                cameraName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _buildTemperatureBadge(temperature),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureBadge(double temperature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${temperature.toStringAsFixed(1)}°C',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
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
              Expanded(
                child: widget.cameraNames.isEmpty
                    ? const Center(
                        child: Text(
                          'No connected cameras',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: widget.cameraNames.length,
                        itemBuilder: (context, index) {
                          final name = widget.cameraNames[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCameraCard(
                              name,
                              _temperatures[name] ?? 0.0,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
