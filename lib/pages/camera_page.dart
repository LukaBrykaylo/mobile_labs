import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/camera/camera_cubit.dart';
import 'package:mobile_labs/cubit/camera/camera_state.dart';
import 'package:mobile_labs/service/mqtt_services/camera_stream_page.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CameraCubit()..initialize(),
      child: const CameraView(),
    );
  }
}

class CameraView extends StatelessWidget {
  const CameraView({super.key});

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
                child: BlocBuilder<CameraCubit, CameraState>(
                  builder: (context, state) {
                    final names = state.deviceStreamMap.keys.toList();

                    if (names.isEmpty) {
                      return const Center(
                        child: Text(
                          'No connected cameras',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: names.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildCameraCard(
                          context,
                          names[i],
                          state.temperatures[names[i]] ?? 0.0,
                        ),
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

  Widget _buildCameraCard(BuildContext context, String name, double temp) {
    return GestureDetector(
      onTap: () => _onCameraTapped(context, name),
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
              child: Text(name, style: _textStyle()),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _buildTemperatureBadge(temp),
            ),
          ],
        ),
      ),
    );
  }

  void _onCameraTapped(BuildContext context, String name) {
    final topic =
    context.read<CameraCubit>().state.deviceStreamMap[name];
    if (topic != null) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => CameraStreamPage(topic: topic.toString()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Topic not found for this camera')),
      );
    }
  }

  TextStyle _textStyle() => const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,);

  Widget _buildTemperatureBadge(double temp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${temp.toStringAsFixed(1)}°C',
        style: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold,),
      ),
    );
  }
}
