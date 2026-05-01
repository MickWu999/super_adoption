/// String? 常用工具。
///
/// 用於：
/// - 去除前後空白
/// - 判斷是否有文字內容
/// - 空值時提供預設文字
extension NullableStringX on String? {
  /// 去除前後空白，null 轉成空字串。
  ///
  /// Example:
  /// title.safe
  /// '  小黑  ' -> '小黑'
  /// null -> ''
  String get safe => this?.trim() ?? '';

  /// 是否有文字內容（trim 後非空）。
  ///
  /// Example:
  /// title.isNotBlank
  bool get isNotBlank => safe.isNotEmpty;

  /// 是否為空字串 / null / 純空白。
  ///
  /// Example:
  /// title.isBlank
  bool get isBlank => !isNotBlank;

  /// 若字串為空，回傳 fallback 預設值。
  ///
  /// Example:
  /// title.or('未命名')
  /// remark.or('尚無說明')
  String or(String fallback) {
    final text = safe;
    return text.isEmpty ? fallback : text;
  }
}


/// Iterable? 常用工具。
///
/// 用於 List / Set / Iterable 是否有資料。
extension NullableIterableX<T> on Iterable<T>? {
  /// 是否非 null 且有資料。
  ///
  /// Example:
  /// animals.isNotNullOrEmpty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// 是否為 null 或沒有資料。
  ///
  /// Example:
  /// animals.isNullOrEmpty
  bool get isNullOrEmpty => !isNotNullOrEmpty;
}

