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
  ], animalId);
}

@riverpod
List<Animal> relatedAnimals(Ref ref, String animalId) {
  final current = ref.watch(animalDetailProvider(animalId));
  if (current == null) return const [];

  final animalState = ref.watch(animalProvider);
  final homeState = ref.watch(homeProvider);

  final merged = [
    ...animalState.items,
    ...homeState.newAnimals,
    ...homeState.popularAnimals,
  ];

  final related = <String, Animal>{};

  for (final animal in merged) {
    if (animal.animalId == animalId) continue;
    if (animal.kind != current.kind) continue;
    related[animal.animalId] = animal;
  }

  return related.values.take(6).toList();
}

Animal? _findById(List<Animal> animals, String animalId) {
  for (final animal in animals) {
    if (animal.animalId == animalId) return animal;
  }
  return null;
}
