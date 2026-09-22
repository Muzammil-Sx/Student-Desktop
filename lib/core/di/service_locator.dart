import 'package:get_it/get_it.dart';
import 'package:student_desktop/features/courses/domain/repositories/courses_repository_impl.dart';

import '../../features/courses/domain/repositories/courses_repository.dart';
import '../../features/courses/presentation/bloc/courses_bloc.dart';
import '../cache/cache_service.dart';
import '../connectivity/connectivity_service.dart';
import '../constants/app_urls.dart';
import '../database/app_database.dart';
import '../database/daos/sync_queue_dao.dart';
import '../network/api_client.dart';
import '../sync/sync_engine.dart';
import '../theme/bloc/theme_bloc.dart';

/// Global service locator.
final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ---------- Storage & Cache ----------
  final cache = await CacheService.init();
  serviceLocator.registerSingleton<CacheService>(cache);

  // ---------- Connectivity ----------
  final connectivity = ConnectivityService();
  await connectivity.start();
  serviceLocator.registerSingleton<ConnectivityService>(connectivity);

  // ---------- Database ----------
  final database = AppDatabase();
  serviceLocator.registerSingleton<AppDatabase>(database);
  serviceLocator.registerSingleton<SyncQueueDao>(database.syncQueueDao);

  // ---------- Network ----------
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: AppUrls.baseUrl,
      tokenProvider: () async => null,
    ),
  );

  // ---------- Sync Engine ----------
  serviceLocator.registerLazySingleton<SyncEngine>(
    () => SyncEngine(
      dao: serviceLocator<SyncQueueDao>(),
      connectivity: serviceLocator<ConnectivityService>(),
    ),
  );
  serviceLocator<SyncEngine>().start();

  // ---------- Repositories ----------
  serviceLocator.registerLazySingleton<CoursesRepository>(
    () => const CoursesRepositoryImpl(),
  );

  // ---------- Blocs ----------
  serviceLocator.registerFactory<ThemeBloc>(
    () => ThemeBloc(cache: serviceLocator<CacheService>()),
  );
  serviceLocator.registerFactory<CoursesBloc>(
    () => CoursesBloc(repository: serviceLocator<CoursesRepository>()),
  );
}

Future<void> disposeServiceLocator() async {
  await serviceLocator<SyncEngine>().dispose();
  await serviceLocator<ConnectivityService>().dispose();
  await serviceLocator.reset();
}