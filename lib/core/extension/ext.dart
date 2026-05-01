extension NullableX on Object? {
  bool get hasValue {
    final value = this;

    if (value == null) return false;

    if (value is String) {
      return value.trim().isNotEmpty;
    }

    return true;
  }

  String get safe {
    final value = this;

    if (value == null) return '';

    if (value is String) return value.trim();

    return value.toString();
  }

  String or(String fallback) {
    final text = safe;

    return text.isEmpty ? fallback : text;
  }
}
