import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/features/animals/data/repository/animal_repository.dart';
import 'package:super_adoption/features/home/data/repository/local_home_repository.dart';
import 'package:super_adoption/features/home/state/home_state.dart';

part 'home_repository.g.dart';

abstract interface class HomeRepository {
  Future<HomeState> fetchHome();
}

/// Repository 注入點（API 切換點）。
///
/// 目前使用 [HomeRepositoryImpl]（假 banner + 政府 OpenData 動物）。
/// 未來接上後端 Home API 時，只需要改這裡：
/// ```dart
/// return RemoteHomeRepository(dio: ref.watch(dioProvider));
/// ```
@riverpod
HomeRepository homeRepository(Ref ref) {
  // TODO(api): swap to RemoteHomeRepository when Home API is ready.
  final animalRepository = ref.watch(animalRepositoryProvider);
  return LocalHomeRepository(animalRepository: animalRepository);
}
