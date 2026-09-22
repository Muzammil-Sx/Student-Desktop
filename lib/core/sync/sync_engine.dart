import 'dart:async';
import 'dart:convert';

import '../connectivity/connectivity_service.dart';
import '../database/daos/sync_queue_dao.dart';
import '../utils/logger.dart';
import 'sync_action.dart';

/// Handles a single mutation against the server.
/// Feature modules register their handler here.
typedef SyncHandler = Future<void> Function({
  required String entity,
  required SyncAction action,
  required Map<String, dynamic> payload,
});

/// Processes the offline [SyncQueueDao] when the device is online.
class SyncEngine {
  SyncEngine({
    required SyncQueueDao dao,
    required ConnectivityService connectivity,
  })  : _dao = dao,
        _connectivity = connectivity;

  final SyncQueueDao _dao;
  final ConnectivityService _connectivity;

  /// Registered handlers, keyed by entity name.
  final Map<String, SyncHandler> _handlers = {};

  StreamSubscription<bool>? _connSub;
  bool _isProcessing = false;

  /// Register a handler for a specific entity.
  void registerHandler(String entity, SyncHandler handler) {
    _handlers[entity] = handler;
  }

  /// Start listening for connectivity changes and trigger sync.
  void start() {
    _connSub = _connectivity.onStatusChange.listen((online) {
      if (online) unawaited(processQueue());
    });
    // Attempt initial sync
    unawaited(processQueue());
  }

  Future<void> dispose() async {
    await _connSub?.cancel();
  }

  /// Process all pending queue items. Safe to call multiple times.
  Future<void> processQueue() async {
    if (_isProcessing) return;
    if (!_connectivity.isOnline) return;
    _isProcessing = true;

    try {
      final items = await _dao.pending();
      for (final item in items) {
        await _processItem(item.id, item.entity, item.action, item.payload);
      }
    } catch (e, st) {
      AppLogger.error('SyncEngine failure', error: e, stack: st);
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processItem(
    int id,
    String entity,
    String actionStr,
    String payloadStr,
  ) async {
    final action = SyncAction.fromString(actionStr);
    final handler = _handlers[entity];

    if (action == null || handler == null) {
      await _dao.markFailed(id, 'No handler for entity=$entity action=$actionStr');
      return;
    }

    await _dao.markSyncing(id);
    try {
      final payload = Map<String, dynamic>.from(
        (const JsonCodec()).decode(payloadStr) as Map,
      );
      await handler(entity: entity, action: action, payload: payload);
      await _dao.markSynced(id);
      await _dao.remove(id);
    } catch (e) {
      await _dao.markFailed(id, e.toString());
      await _dao.incrementRetry(id);
    }
  }
}