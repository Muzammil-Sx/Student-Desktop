import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cache/cache_service.dart';
import '../connectivity/connectivity_service.dart';
import '../constants/app_urls.dart';
import '../database/app_database.dart';
import '../database/daos/sync_queue_dao.dart';
import '../network/api_client.dart';
import '../sync/sync_engine.dart';

// ============================================================
// Core Infrastructure
// ============================================================

final cacheServiceProvider = Provider<CacheService>((ref) {
  throw UnimplementedError('cacheServiceProvider must be overridden in main()');
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  throw UnimplementedError(
    'connectivityServiceProvider must be overridden in main()',
  );
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('appDatabaseProvider must be overridden in main()');
});

final syncQueueDaoProvider = Provider<SyncQueueDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.syncQueueDao;
});

final authTokenProvider = Provider<Future<String?> Function()>((ref) {
  return () async => null;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: AppUrls.baseUrl,
    tokenProvider: ref.watch(authTokenProvider),
  );
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(
    dao: ref.watch(syncQueueDaoProvider),
    connectivity: ref.watch(connectivityServiceProvider),
  );
  ref.onDispose(engine.dispose);
  return engine;
});

// ============================================================
// UI / Theme
// ============================================================

const _themeModeKey = 'theme.mode';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final cache = ref.watch(cacheServiceProvider);
    final stored = cache.read<String>(_themeModeKey, (j) => j as String);
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(cacheServiceProvider).write(_themeModeKey, mode.name);
  }

  Future<void> toggle() async {
    final next = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
    await set(next);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);