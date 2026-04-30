import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/state/animal_list_provider.dart';
import 'package:super_adoption/features/home/state/home_provider.dart';

part 'animal_detail_provider.g.dart';

@riverpod
Animal? animalDetail(Ref ref, String animalId) {
  final animalState = ref.watch(animalProvider);
  final fromList = _findById(animalState.items, animalId);
  if (fromList != null) return fromList;

  final homeState = ref.watch(homeProvider);

  return _findById([
    ...homeState.newAnimals,
    ...homeState.popularAnimals,
    ...homeState.favoriteAnimals,
  ], animalId);
}

Animal? _findById(List<Animal> animals, String animalId) {
  for (final animal in animals) {
    if (animal.id == animalId) return animal;
  }
  return null;
}
