import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueueTable])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  /// Insert a new pending mutation.
  Future<int> enqueue({
    required String entity,
    required String action,
    required String payload,
  }) =>
      into(syncQueueTable).insert(
        SyncQueueTableCompanion.insert(
          entity: entity,
          action: action,
          payload: payload,
        ),
      );

  /// Fetch pending items ordered by creation time.
  Future<List<SyncQueueEntry>> pending({int limit = 50}) =>
      (select(syncQueueTable)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
            ..limit(limit))
          .get();

  /// Mark an entry as currently syncing.
  Future<void> markSyncing(int id) =>
      (update(syncQueueTable)..where((t) => t.id.equals(id))).write(
        SyncQueueTableCompanion(
          status: const Value('syncing'),
          lastAttemptAt: Value(DateTime.now()),
        ),
      );

  /// Mark an entry as successfully synced.
  Future<void> markSynced(int id) =>
      (update(syncQueueTable)..where((t) => t.id.equals(id))).write(
        const SyncQueueTableCompanion(status: Value('synced')),
      );

  /// Mark as failed and increment retry count.
  Future<void> markFailed(int id, String error) =>
      (update(syncQueueTable)..where((t) => t.id.equals(id))).write(
        SyncQueueTableCompanion(
          status: const Value('failed'),
          retryCount: const Value.absent(),
          lastError: Value(error),
          lastAttemptAt: Value(DateTime.now()),
        ),
      );

  /// Increment retry count for a failed entry.
  Future<void> incrementRetry(int id) async {
    final entry = await (select(syncQueueTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (entry == null) return;
    await (update(syncQueueTable)..where((t) => t.id.equals(id))).write(
      SyncQueueTableCompanion(
        retryCount: Value(entry.retryCount + 1),
      ),
    );
  }

  /// Delete a synced entry.
  Future<int> remove(int id) =>
      (delete(syncQueueTable)..where((t) => t.id.equals(id))).go();

  /// How many items are pending?
  Future<int> pendingCount() async {
    final count = syncQueueTable.id.count();
    final query = selectOnly(syncQueueTable)
      ..addColumns([count])
      ..where(syncQueueTable.status.equals('pending'));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  /// Watch pending count for UI badges.
  Stream<int> watchPendingCount() {
    final count = syncQueueTable.id.count();
    final query = selectOnly(syncQueueTable)
      ..addColumns([count])
      ..where(syncQueueTable.status.equals('pending'));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }
}