import 'package:equatable/equatable.dart';

class CameraState extends Equatable {
  final Map<String, String> deviceStreamMap;
  final Map<String, double> temperatures;

  const CameraState({
    required this.deviceStreamMap,
    required this.temperatures,
  });

  factory CameraState.initial() {
    return const CameraState(deviceStreamMap: {}, temperatures: {});
  }

  CameraState copyWith({
    Map<String, String>? deviceStreamMap,
    Map<String, double>? temperatures,
  }) {
    return CameraState(
      deviceStreamMap: deviceStreamMap ?? this.deviceStreamMap,
      temperatures: temperatures ?? this.temperatures,
    );
  }

  @override
  List<Object> get props => [deviceStreamMap, temperatures];
}
