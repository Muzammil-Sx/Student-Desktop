/// Composable validators — return error string or null.
/// Usage: `validator: (v) => Validators.required(v) ?? Validators.email(v)`
abstract final class Validators {
  Validators._();

  static String? required(String? value, {String message = 'Required'}) =>
      (value == null || value.trim().isEmpty) ? message : null;

  static String? email(String? value, {String message = 'Invalid email'}) {
    if (value == null || value.isEmpty) return null;
    final pattern = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    return pattern.hasMatch(value.trim()) ? null : message;
  }

  static String? minLength(String? value, int min, {String? message}) {
    if (value == null || value.isEmpty) return null;
    return value.length < min ? (message ?? 'Minimum $min characters') : null;
  }

  static String? maxLength(String? value, int max, {String? message}) {
    if (value == null || value.isEmpty) return null;
    return value.length > max ? (message ?? 'Maximum $max characters') : null;
  }

  static String? phone(String? value, {String message = 'Invalid phone'}) {
    if (value == null || value.isEmpty) return null;
    final pattern = RegExp(r'^\+?[0-9\s\-]{7,15}$');
    return pattern.hasMatch(value.trim()) ? null : message;
  }

  static String? Function(String?) combine(
    List<String? Function(String?)> rules,
  ) {
    return (value) {
      for (final rule in rules) {
        final result = rule(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}