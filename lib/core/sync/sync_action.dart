/// Actions a queued mutation can perform against the server.
enum SyncAction {
  create,
  update,
  delete;

  static SyncAction? fromString(String value) {
    return switch (value.toLowerCase()) {
      'create' => SyncAction.create,
      'update' => SyncAction.update,
      'delete' => SyncAction.delete,
      _ => null,
    };
  }
}

/// Status of a queued item.
enum SyncStatus {
  pending,
  syncing,
  synced,
  failed;

  static SyncStatus fromString(String value) {
    return switch (value.toLowerCase()) {
      'pending' => SyncStatus.pending,
      'syncing' => SyncStatus.syncing,
      'synced' => SyncStatus.synced,
      'failed' => SyncStatus.failed,
      _ => SyncStatus.pending,
    };
  }
}