import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_adoption/core/enum/load_status.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';

import '../model/animal.dart';

part 'animal_list_state.freezed.dart';

@freezed
abstract class AnimalListState with _$AnimalListState {
  const AnimalListState._();

  const factory AnimalListState({
    @Default([]) List<Animal> items,
    @Default(AnimalFilter()) AnimalFilter filter,
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _AnimalListState;

  bool get isLoading => status == LoadStatus.loading;
  bool get hasError => status == LoadStatus.error && error.isNotBlank;
  bool get isEmpty => status == LoadStatus.empty;
  bool get hasContent => items.isNotEmpty;
  bool get showFullscreenError => hasError && !hasContent;
}
