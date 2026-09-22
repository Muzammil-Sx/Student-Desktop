import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../cache/cache_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({required CacheService cache})
      : _cache = cache,
        super(const ThemeState.initial()) {
    on<LoadTheme>(_onLoad);
    on<SetThemeMode>(_onSet);
    on<ToggleTheme>(_onToggle);
  }

  final CacheService _cache;

  static const _cacheKey = 'theme.mode';

  Future<void> _onLoad(LoadTheme event, Emitter<ThemeState> emit) async {
    final stored = _cache.read<String>(_cacheKey, (j) => j as String);
    emit(state.copyWith(mode: _parse(stored)));
  }

  Future<void> _onSet(SetThemeMode event, Emitter<ThemeState> emit) async {
    if (event.mode == state.mode) return;
    emit(state.copyWith(mode: event.mode));
    await _cache.write(_cacheKey, event.mode.name);
  }

  Future<void> _onToggle(ToggleTheme event, Emitter<ThemeState> emit) async {
    final next = switch (state.mode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
    emit(state.copyWith(mode: next));
    await _cache.write(_cacheKey, next.name);
  }

  ThemeMode _parse(String? value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}