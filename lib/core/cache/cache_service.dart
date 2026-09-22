import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Simple key-value cache with TTL support.
/// Stores JSON strings — values must be JSON-serializable.
class CacheService {
  CacheService(this._box);

  final Box<String> _box;

  /// Initializes Hive and opens the cache box.
  /// Call once during bootstrap.
  static Future<CacheService> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>('cache_box');
    return CacheService(box);
  }

  /// Write a value with optional TTL.
  Future<void> write(
    String key,
    Object value, {
    Duration? ttl,
  }) async {
    final envelope = _Envelope(
      value: jsonEncode(value),
      expiresAt: ttl == null ? null : DateTime.now().add(ttl).millisecondsSinceEpoch,
    );
    await _box.put(key, jsonEncode(envelope.toJson()));
  }

  /// Read a value. Returns null if missing or expired.
  T? read<T>(String key, T Function(dynamic json) parser) {
    final raw = _box.get(key);
    if (raw == null) return null;

    try {
      final envelope = _Envelope.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );

      if (envelope.isExpired) {
        _box.delete(key);
        return null;
      }

      final decoded = jsonDecode(envelope.value);
      return parser(decoded);
    } catch (_) {
      _box.delete(key);
      return null;
    }
  }

  /// Check if a non-expired value exists.
  bool has(String key) {
    final raw = _box.get(key);
    if (raw == null) return false;
    try {
      final envelope = _Envelope.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (envelope.isExpired) {
        _box.delete(key);
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> remove(String key) => _box.delete(key);

  Future<void> clear() => _box.clear();

  /// Remove all keys with the given prefix.
  Future<void> clearPrefix(String prefix) async {
    final keys = _box.keys.where((k) => k.toString().startsWith(prefix)).toList();
    await _box.deleteAll(keys);
  }
}

/// Internal wrapper storing value + optional expiry.
class _Envelope {
  const _Envelope({required this.value, this.expiresAt});

  final String value;
  final int? expiresAt;

  bool get isExpired =>
      expiresAt != null && DateTime.now().millisecondsSinceEpoch > expiresAt!;

  Map<String, dynamic> toJson() => {
        'value': value,
        if (expiresAt != null) 'expiresAt': expiresAt,
      };

  factory _Envelope.fromJson(Map<String, dynamic> json) => _Envelope(
        value: json['value'] as String,
        expiresAt: json['expiresAt'] as int?,
      );
}