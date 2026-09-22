import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the persisted theme mode from cache.
final class LoadTheme extends ThemeEvent {
  const LoadTheme();
}

/// Sets a specific [ThemeMode] and persists it.
final class SetThemeMode extends ThemeEvent {
  const SetThemeMode(this.mode);

  final ThemeMode mode;

  @override
  List<Object?> get props => [mode];
}

/// Toggles between light and dark.
/// From `system`, switches to dark (deterministic behaviour).
final class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}