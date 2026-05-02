import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/core/enum/load_status.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/home/data/repository/home_repository.dart';
import 'package:super_adoption/features/home/state/home_state.dart';

part 'home_provider.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    Future.microtask(load);
    return const HomeState(status: LoadStatus.loading);
  }

  Future<void> load() async {
    state = state.copyWith(status: LoadStatus.loading, error: null);

    try {
      final repo = ref.read(homeRepositoryProvider);
      final data = await repo.fetchHome();
      final hasContent =
          data.banners.isNotEmpty ||
          data.newAnimals.isNotEmpty ||
          data.popularAnimals.isNotEmpty ||
          data.favoriteAnimals.isNotEmpty;

      state = data.copyWith(
        status: hasContent ? LoadStatus.success : LoadStatus.empty,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(status: LoadStatus.error, error: e.toString());
    }
  }

  Future<void> refresh() async {
    await load();
  }

  void toggleFavorite(String animalId) {
    Animal update(Animal animal) => animal.id == animalId
        ? animal.copyWith(isFavorite: !animal.isFavorite)
        : animal;

    final nextNewAnimals = state.newAnimals.map(update).toList();
    final nextPopularAnimals = state.popularAnimals.map(update).toList();

    final mergedFavorites = [
      ...nextNewAnimals.where((animal) => animal.isFavorite),
      ...nextPopularAnimals.where((animal) => animal.isFavorite),
      ...state.favoriteAnimals.map(update).where((animal) => animal.isFavorite),
    ];

    final uniqueFavorites = <String, Animal>{};
    for (final animal in mergedFavorites) {
      uniqueFavorites[animal.id] = animal;
    }

    state = state.copyWith(
      newAnimals: nextNewAnimals,
      popularAnimals: nextPopularAnimals,
      favoriteAnimals: uniqueFavorites.values.toList(),
    );
  }
}
