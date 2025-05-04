import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NetworkService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _hasConnection = true;
  Timer? _timer;

  bool get hasConnection => _hasConnection;

  NetworkService() {
    _initConnectivity();
    _startPeriodicCheck();
  }

  void _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final prev = _hasConnection;
    _hasConnection = result != ConnectivityResult.none;

    if (_hasConnection != prev) {
      notifyListeners();
      _showToast(
        _hasConnection
            ? 'Internet connection restored'
            : 'No internet connection',
      );
    }
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
