import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/core/log/app_logger.dart';

import '../data/query/animal_filter.dart';
import '../data/repository/animal_repository.dart';
import 'animal_list_state.dart';

part 'animal_list_provider.g.dart';

@Riverpod(keepAlive: true)
class AnimalNotifier extends _$AnimalNotifier {
  late final AnimalRepository _repo;

  @override
  AnimalListState build() {
    _repo = ref.watch(animalRepositoryProvider);
    Future.microtask(load);
    AppLogger.instance.i('AnimalNotifier build');

    return AnimalListState(filter: AnimalFilter.initial(), isLoading: true);
  }

  Future<void> load() async {
    final filter = AnimalFilter.initial();
    AppLogger.instance.i('AnimalNotifier load filter=$filter');

    state = state.copyWith(
      items: [],
      filter: filter,
      isLoading: true,
      isLoadingMore: false,
      error: null,
    );

    try {
      final items = await _repo.fetchAnimals(filter);

      state = state.copyWith(
        items: items,
        filter: filter.copyWith(skip: items.length),
        isLoading: false,
        hasMore: items.length == filter.top,
      );
      AppLogger.instance.i('AnimalNotifier load success count=${items.length}');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      AppLogger.instance.e(
        'AnimalNotifier load failed',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> refresh() async {
    await applyFilter(state.filter.resetPaging());
  }

  Future<void> applyFilter(AnimalFilter filter) async {
    final nextFilter = filter.resetPaging();
    AppLogger.instance.i('AnimalNotifier applyFilter filter=$nextFilter');

    state = state.copyWith(
      filter: nextFilter,
      isLoading: true,
      isLoadingMore: false,
      error: null,
    );

    try {
      final items = await _repo.fetchAnimals(nextFilter);

      state = state.copyWith(
        items: items,
        filter: nextFilter.copyWith(skip: items.length),
        isLoading: false,
        hasMore: items.length == nextFilter.top,
      );
      AppLogger.instance.i(
        'AnimalNotifier applyFilter success count=${items.length}',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      AppLogger.instance.e(
        'AnimalNotifier applyFilter failed',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> clearFilters() async {
    await applyFilter(state.filter.clearFilters());
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    final nextFilter = state.filter;
    AppLogger.instance.i('AnimalNotifier loadMore filter=$nextFilter');

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final items = await _repo.fetchAnimals(nextFilter);

      state = state.copyWith(
        items: [...state.items, ...items],
        filter: nextFilter.copyWith(skip: nextFilter.skip + items.length),
        isLoadingMore: false,
        hasMore: items.length == nextFilter.top,
      );
      AppLogger.instance.i(
        'AnimalNotifier loadMore success added=${items.length} total=${state.items.length}',
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
      AppLogger.instance.e(
        'AnimalNotifier loadMore failed',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }
}
