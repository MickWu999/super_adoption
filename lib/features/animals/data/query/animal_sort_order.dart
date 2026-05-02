/// 排序欄位（依哪個維度排序）。
/// 排序方向（升序/降序）由 [AnimalFilter.sortAscending] 控制。
enum AnimalSortOrder {
  /// 依上架時間排序
  createTime,

  // /// 熱門度（未來實作）
  // popularity,
  ;

  String get label => switch (this) {
        AnimalSortOrder.createTime => '最新上架',
      };
}
