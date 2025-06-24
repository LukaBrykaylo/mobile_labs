import 'dart:typed_data';

abstract class CameraStreamState {}

class CameraStreamInitial extends CameraStreamState {}

class CameraStreamImage extends CameraStreamState {
  final Uint8List imageBytes;
  CameraStreamImage(this.imageBytes);
}

class CameraStreamError extends CameraStreamState {
  final String message;
  CameraStreamError(this.message);
}

class CameraStreamDisconnected extends CameraStreamState {}
