import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/core/network/dio_provider.dart';
import 'package:super_adoption/features/animals/data/repository/gov_animal_repository.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/model/animal.dart';

part 'animal_repository.g.dart';

/// 動物資料來源介面。
///
/// 之後如果資料來源從農業部 OpenData 改成 Supabase，
/// Notifier 不需要改，只要把 [animalRepositoryProvider] 的實作換掉即可。
abstract interface class AnimalRepository {
  Future<List<Animal>> fetchAnimals(AnimalFilter filter);
}

/// Repository 注入點（API 切換點）。
///
/// 目前使用政府 OpenData：[GovAnimalRepository]。
/// 未來若改成 Supabase，只需要改這裡：
/// ```dart
/// return SupabaseAnimalRepository(client: ref.watch(supabaseClientProvider));
/// ```
@riverpod
AnimalRepository animalRepository(Ref ref) {
  // TODO(api): swap to SupabaseAnimalRepository when backend is ready.
  final dio = ref.watch(animalApiClientProvider);
  return GovAnimalRepository(dio);
}
