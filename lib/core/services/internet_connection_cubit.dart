import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connectivity_service.dart';

class InternetConnectionCubit extends Cubit<ConnectivityStatus> {
  final InternetConnectionService _connectivityService;
  late final StreamSubscription<ConnectivityStatus> _subscription;

  InternetConnectionCubit(this._connectivityService)
      : super(_connectivityService.currentStatus) {
    _subscription = _connectivityService.connectionStream.listen((status) {
      emit(status);
    });
  }

  bool get isConnected =>
      state == ConnectivityStatus.connected ||
      state == ConnectivityStatus.phoneData;

  bool get isPhoneData => state == ConnectivityStatus.phoneData;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
