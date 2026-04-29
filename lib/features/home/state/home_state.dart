import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/home/model/home_banner.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<HomeBanner> banners,
    @Default([]) List<Animal> favoriteAnimals,
    @Default([]) List<Animal> newAnimals,
    @Default([]) List<Animal> popularAnimals,
  }) = _HomeState;
}
