import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';

import '../model/animal.dart';

part 'animal_list_state.freezed.dart';

@freezed
abstract class AnimalListState with _$AnimalListState {
  const factory AnimalListState({
    @Default([]) List<Animal> items,
    @Default(AnimalFilter()) AnimalFilter filter,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _AnimalListState;
}