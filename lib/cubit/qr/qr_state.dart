part of 'qr_cubit.dart';

abstract class QrState {}

class QrInitial extends QrState {}

class QrScanSuccess extends QrState {
  final String topic;
  QrScanSuccess(this.topic);
}

class QrWaiting extends QrState {}

class QrAuthenticated extends QrState {
  final String streamTopic;
  QrAuthenticated(this.streamTopic);
}

class QrError extends QrState {
  final String message;
  QrError(this.message);
}
