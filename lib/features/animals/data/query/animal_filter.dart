import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_adoption/core/extension/ext.dart';

part 'animal_filter.freezed.dart';

@freezed
abstract class AnimalFilter with _$AnimalFilter {
  const AnimalFilter._();

  const factory AnimalFilter({
    /// 每次查詢筆數。
    @Default(20) int top,

    /// 跳過筆數，用於分頁載入更多。
    @Default(0) int skip,

    /// 動物狀態，讓使用者也可以關注還沒開放的可追蹤資訊
    String? status,

    /// 動物種類：[狗 | 貓 | 鳥 ...]
    String? kind,

    /// 動物性別：[M | F | N]
    String? sex,

    /// 動物年紀：[CHILD | ADULT]
    String? age,

    /// 動物體型：[SMALL | MEDIUM | BIG]
    String? bodyType,

    /// 動物所屬縣市代碼。
    int? areaId,

    // 以下是官方 API 支援，但目前 App 暫不開放給使用者篩選的欄位。
    // 先保留註解，未來若要做進階搜尋可以再打開。
    // String? animalId,
    // String? animalSubId,
    // String? place,
    // String? variety,
    // String? color,
    // String? sterilization,
    // String? bacterin,
    // String? foundPlace,
    // String? openDate,
    // String? shelterName,
  }) = _AnimalFilter;

  /// 預設篩選條件：抓取前 20 筆資料，不限制動物狀態。
  factory AnimalFilter.initial() {
    return const AnimalFilter();
  }

  // 統一管理會被視為「使用者篩選條件」的欄位。
  List<Object?> get _filterFields => [status, kind, sex, age, bodyType, areaId];

  /// 是否有套用使用者篩選條件。
  ///
  /// top / skip / 不算使用者篩選，因為它們通常是列表預設條件與分頁條件。
  bool get hasFilter => _filterFields.any((e) => e.hasValue);

  /// 目前有幾個篩選條件。
  ///
  /// 可用於篩選按鈕 badge，例如顯示「已套用 3 個條件」。
  int get filterCount => _filterFields.where((e) => e.hasValue).length;

  /// 清除使用者篩選條件，但保留列表預設條件。
  AnimalFilter clearFilters() {
    return copyWith(
      skip: 0,
      status: null,
      kind: null,
      sex: null,
      age: null,
      bodyType: null,
      areaId: null,
    );
  }

  /// 重設分頁，通常用在重新整理或套用新篩選時。
  AnimalFilter resetPaging() {
    return copyWith(skip: 0);
  }

  /// 下一頁查詢條件。
  AnimalFilter nextPage() {
    return copyWith(skip: skip + top);
  }

  /// 轉成路由 query parameters，供頁面導頁使用。
  ///
  /// 只包含目前會影響畫面篩選的欄位，不包含分頁參數。
  Map<String, String> toQueryParameters() {
    return {
      if (status.hasValue) 'status': status!,
      if (kind.hasValue) 'kind': kind!,
      if (sex.hasValue) 'sex': sex!,
      if (age.hasValue) 'age': age!,
      if (bodyType.hasValue) 'bodyType': bodyType!,
      if (areaId != null) 'areaId': areaId.toString(),
    };
  }
}
