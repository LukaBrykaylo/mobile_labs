import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/camera_stream/camera_stream_cubit.dart';
import 'package:mobile_labs/cubit/camera_stream/camera_stream_state.dart';

class CameraStreamPage extends StatelessWidget {
  final String topic;

  const CameraStreamPage({required this.topic, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CameraStreamCubit(topic),
      child: const _CameraStreamView(),
    );
  }
}

class _CameraStreamView extends StatelessWidget {
  const _CameraStreamView();

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
            child: BlocConsumer<CameraStreamCubit, CameraStreamState>(
              listener: (context, state) {
                if (state is CameraStreamError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
                if (state is CameraStreamDisconnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Disconnected from camera')),
                  );
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                if (state is CameraStreamImage) {
                  return Image.memory(state.imageBytes);
                } else {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text('Waiting for response',
                          style: TextStyle(color: Colors.white),),
                    ],
                  );
                }
              },
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
                      borderRadius: BorderRadius.circular(12),),
                ),
                onPressed: () => context.read<CameraStreamCubit>().disconnect(),
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
