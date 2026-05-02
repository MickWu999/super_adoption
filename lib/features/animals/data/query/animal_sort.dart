import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_adoption/features/animals/data/query/animal_sort_order.dart';

part 'animal_sort.freezed.dart';

@freezed
abstract class AnimalSort with _$AnimalSort {
  const factory AnimalSort({
    /// 排序欄位。
    @Default(AnimalSortOrder.createTime) AnimalSortOrder order,

    /// 排序方向：false = 降序（預設，最新在前），true = 升序（最舊在前）。
    @Default(false) bool ascending,
  }) = _AnimalSort;
}
