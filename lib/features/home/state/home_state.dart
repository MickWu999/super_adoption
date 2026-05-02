import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_adoption/core/enum/load_status.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/home/model/home_banner.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  // Needed so computed getters like `hasError` can live on the freezed class.
  // ignore: unused_element
  const HomeState._();

  const factory HomeState({
    @Default(LoadStatus.initial) LoadStatus status,
    String? error,
    @Default([]) List<HomeBanner> banners,
    @Default([]) List<Animal> newAnimals,
    @Default([]) List<Animal> popularAnimals,
  }) = _HomeState;

  bool get isLoading => status == LoadStatus.loading;
  bool get hasError => status == LoadStatus.error && error.isNotBlank;
  bool get hasContent =>
      banners.isNotEmpty || newAnimals.isNotEmpty || popularAnimals.isNotEmpty;
}
