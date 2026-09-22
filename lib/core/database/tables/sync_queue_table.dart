import 'package:drift/drift.dart';

/// Queue of local mutations waiting to be synced to the server.
/// Written to whenever the user does something offline (or optimistically).
@DataClassName('SyncQueueEntry')
class SyncQueueTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Entity name — e.g., 'course', 'student', 'enrollment'.
  TextColumn get entity => text().withLength(min: 1, max: 64)();

  /// Action to perform — 'create' | 'update' | 'delete'.
  TextColumn get action => text().withLength(min: 1, max: 16)();

  /// JSON-encoded payload for the mutation.
  TextColumn get payload => text()();

  /// Sync status — 'pending' | 'syncing' | 'synced' | 'failed'.
  TextColumn get status =>
      text().withDefault(const Constant('pending')).withLength(max: 16)();

  /// Number of retry attempts made.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// Last failure reason (if any).
  TextColumn get lastError => text().nullable()();

  /// When the entry was created locally.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last attempt timestamp (nullable).
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
}