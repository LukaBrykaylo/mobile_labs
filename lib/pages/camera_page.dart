import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  final List<String> cameraNames;

  const CameraPage({required this.cameraNames, super.key});

  void _openCamera(String cameraName) {
    // TODO: Camera view logic for specific camera
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
                child: cameraNames.isEmpty
                    ? const Center(
                        child: Text(
                          'No connected cameras',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: cameraNames.length,
                        itemBuilder: (context, index) {
                          final cameraName = cameraNames[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () => _openCamera(cameraName),
                              child: Container(
                                height: 220,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.white, width: 0.5,),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
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
                                  ],
                                ),
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
}
