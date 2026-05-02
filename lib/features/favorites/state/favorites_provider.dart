import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/features/favorites/data/repository/favorites_repository.dart';
import 'package:super_adoption/features/favorites/data/repository/local_favorites_repository.dart';
import 'package:super_adoption/features/favorites/model/favorite_entry.dart';

part 'favorites_provider.g.dart';

/// 全域唯一的收藏狀態。
///
/// 所有頁面（Home、List、Detail）都從這裡讀取 isFavorited，
/// 不再讓各頁自行維護 isFavorite 欄位的版本，避免不同步。
///
/// 讀取：
///   final ids = ref.watch(favoritesProvider);
///   final isFav = ids.contains(animal.subId);
///
/// 切換：
///   ref.read(favoritesProvider.notifier).toggle(animal.subId);
@Riverpod(keepAlive: true)
class Favorites extends _$Favorites {
  late final FavoritesRepository _repo;

  @override
  Set<String> build() {
    _repo = ref.watch(favoritesRepositoryProvider);
    Future.microtask(_hydrate);
    return const {};
  }

  /// 從 SharedPreferences（或未來的 API）載入已收藏的 subId 集合。
  Future<void> _hydrate() async {
    final entries = await _repo.getAll();
    state = entries.map((e) => e.animalSubId).toSet();
  }

  /// 是否已收藏。
  bool isFavorited(String animalSubId) => state.contains(animalSubId);

  /// 切換收藏狀態（optimistic update：先更新 UI，再寫入 repository）。
  Future<void> toggle(String animalSubId) async {
    final wasFavorited = state.contains(animalSubId);

    // Optimistic update
    if (wasFavorited) {
      state = Set.unmodifiable(state.difference({animalSubId}));
    } else {
      state = Set.unmodifiable(state.union({animalSubId}));
    }

    try {
      if (wasFavorited) {
        await _repo.remove(animalSubId);
      } else {
        await _repo.add(animalSubId);
      }
    } catch (_) {
      // Rollback on failure
      if (wasFavorited) {
        state = Set.unmodifiable(state.union({animalSubId}));
      } else {
        state = Set.unmodifiable(state.difference({animalSubId}));
      }
      rethrow;
    }
  }

  /// 未來帳號登入後，批次同步訪客收藏。
  Future<void> syncGuestFavoritesToAccount(
    Future<void> Function(List<FavoriteEntry> entries) uploadFn,
  ) async {
    final entries = await _repo.getAll();
    await uploadFn(entries);
    if (_repo is LocalFavoritesRepository) {
      await _repo.clearGuestFavorites();
    }
    await _hydrate();
  }
}
