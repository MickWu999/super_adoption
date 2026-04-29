import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/features/home/data/repository/home_repository.dart';
import 'package:super_adoption/features/home/state/home_state.dart';

part 'home_provider.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<HomeState> build() async {
    final repo = ref.watch(homeRepositoryProvider);

    return repo.fetchHome();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(homeRepositoryProvider);
      return repo.fetchHome();
    });
  }
}
