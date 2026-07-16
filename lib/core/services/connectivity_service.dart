import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityStatus {
  connected,
  phoneData,
  disconnected,
}

class InternetConnectionService {
  final StreamController<ConnectivityStatus> _connectionStatusController =
      StreamController<ConnectivityStatus>.broadcast();

  Stream<ConnectivityStatus> get connectionStream =>
      _connectionStatusController.stream;

  ConnectivityStatus _currentStatus = ConnectivityStatus.disconnected;
  ConnectivityStatus get currentStatus => _currentStatus;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  static const _disconnectDebounce = Duration(seconds: 3);
  Timer? _disconnectTimer;

  Future<void> init() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);

    final initialResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(initialResult);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final newStatus = _resolveStatus(result);

    if (newStatus != ConnectivityStatus.disconnected) {
      _disconnectTimer?.cancel();
      _disconnectTimer = null;
      _applyStatus(newStatus);
    } else {
      if (_disconnectTimer?.isActive ?? false) return;
      _disconnectTimer = Timer(_disconnectDebounce, () {
        _applyStatus(ConnectivityStatus.disconnected);
        _disconnectTimer = null;
      });
    }
  }

  ConnectivityStatus _resolveStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn)) {
      return ConnectivityStatus.connected;
    } else if (result.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.phoneData;
    }
    return ConnectivityStatus.disconnected;
  }

  void _applyStatus(ConnectivityStatus newStatus) {
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _connectionStatusController.add(newStatus);
      debugPrint('Connectivity status updated: $newStatus');
    }
  }

  void dispose() {
    _disconnectTimer?.cancel();
    _connectivitySubscription.cancel();
    _connectionStatusController.close();
  }
}
