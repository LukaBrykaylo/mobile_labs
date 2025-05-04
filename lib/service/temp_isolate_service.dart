import 'dart:isolate';
import 'dart:math';

@pragma('vm:entry-point')
void temperatureIsolate(SendPort sendPort) async {
  final random = Random();
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  await for (final message in receivePort) {
    if (message is List<String>) {
      final temps = <String, double>{
        for (final camera in message) camera: 20 + random.nextDouble() * 15,
      };
      sendPort.send(temps);
    }
  }
}
