import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/core/supabase/supabase_client_provider.dart';
import 'package:super_adoption/features/animals/data/repository/supabase_animal_repository.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/model/animal.dart';

part 'animal_repository.g.dart';

/// 動物資料來源介面。
abstract interface class AnimalRepository {
  Future<List<Animal>> fetchAnimals(AnimalFilter filter);
  Future<Animal?> fetchAnimalById(String animalId);
}

@riverpod
AnimalRepository animalRepository(Ref ref) {

  //  final dio = ref.watch(animalApiClientProvider);
  // return GovAnimalRepository(dio);
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAnimalRepository(client);
}
