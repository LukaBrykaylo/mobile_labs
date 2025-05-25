import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/add_camera/add_camera_cubit.dart';

class AddCameraPage extends StatelessWidget {
  const AddCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddCameraCubit()..loadDeviceStreamMap(),
      child: const AddCameraView(),
    );
  }
}

class AddCameraView extends StatelessWidget {
  const AddCameraView({super.key});

  void _addCamera(BuildContext context) {
    final cubit = context.read<AddCameraCubit>();
    Navigator.pushNamed(context, '/qr_code').then((_) {
      if (!cubit.isClosed) {
        cubit.loadDeviceStreamMap();
      }
    });
  }


  Widget _buildCameraItem(
      BuildContext context, String deviceTopic, String streamTopic,) {
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
            onPressed: () {
              context.read<AddCameraCubit>().removeCamera(deviceTopic);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCameraList(BuildContext context, Map<String, String> map) {
    if (map.isEmpty) {
      return const Center(
        child: Text(
          'No connected cameras',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: map.entries
          .map((entry) => _buildCameraItem(context, entry.key, entry.value))
          .toList(),
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
                  onTap: () => _addCamera(context),
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
              Expanded(
                child: BlocBuilder<AddCameraCubit, AddCameraState>(
                  builder: (context, state) {
                    if (state is AddCameraLoaded) {
                      return _buildCameraList(context, state.deviceStreamMap);
                    } else if (state is AddCameraLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const SizedBox.shrink();
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
