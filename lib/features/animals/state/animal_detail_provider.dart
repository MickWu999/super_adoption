import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/data/repository/animal_repository.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/state/animal_list_provider.dart';
import 'package:super_adoption/features/home/state/home_provider.dart';

part 'animal_detail_provider.g.dart';

/// Cache-first: 先從記憶體 cache 找，找不到再直接打 DB。
/// 支援 deep link / cold start 場景。
@riverpod
Future<Animal?> animalDetail(Ref ref, String animalId) async {
  final animalState = ref.watch(animalProvider);
  final fromList = _findById(animalState.items, animalId);
  if (fromList != null) return fromList;

  final homeState = ref.watch(homeProvider);
  final fromHome = _findById([
    ...homeState.newAnimals,
    ...homeState.popularAnimals,
  ], animalId);
  if (fromHome != null) return fromHome;

  // Cache miss（例如 deep link / cold start）→ 直接打 DB
  final repo = ref.watch(animalRepositoryProvider);
  return repo.fetchAnimalById(animalId);
}

@riverpod
Future<List<Animal>> relatedAnimals(Ref ref, String animalId) async {
  final current = ref.watch(animalDetailProvider(animalId)).asData?.value;
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

  if (related.isNotEmpty) return related.values.take(6).toList();

  // Cache miss（cold start）→ 用 kind 直接查 DB
  final repo = ref.watch(animalRepositoryProvider);
  final fromDb = await repo.fetchAnimals(
    AnimalFilter(kind: current.kind, top: 6),
  );
  return fromDb.where((a) => a.animalId != animalId).toList();
}

Animal? _findById(List<Animal> animals, String animalId) {
  for (final animal in animals) {
    if (animal.animalId == animalId) return animal;
  }
  return null;
}
