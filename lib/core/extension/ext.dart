extension NullableX on Object? {
  bool get hasValue {
    final value = this;

    if (value == null) return false;

    if (value is String) {
      return value.trim().isNotEmpty;
    }

    return true;
  }
}