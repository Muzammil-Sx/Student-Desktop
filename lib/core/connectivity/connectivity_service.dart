import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps [Connectivity] — exposes a simple online/offline stream.
class ConnectivityService {
  ConnectivityService([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _sub;

  /// Whether the device currently has any network interface available.
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  /// Broadcast stream of online status changes.
  Stream<bool> get onStatusChange => _controller.stream;

  /// Starts listening. Call once during bootstrap.
  Future<void> start() async {
    final initial = await _connectivity.checkConnectivity();
    _isOnline = _hasConnection(initial);
    _sub = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  /// Stops listening.
  Future<void> dispose() async {
    await _sub?.cancel();
    await _controller.close();
  }

  void _onChanged(List<ConnectivityResult> results) {
    final online = _hasConnection(results);
    if (online != _isOnline) {
      _isOnline = online;
      _controller.add(online);
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}