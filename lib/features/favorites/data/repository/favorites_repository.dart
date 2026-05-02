import 'package:super_adoption/features/favorites/model/favorite_entry.dart';

/// 收藏功能的資料來源介面。
///
/// 訪客模式：[LocalFavoritesRepository]（SharedPreferences）
/// 帳號模式：未來換成 RemoteFavoritesRepository（API）
/// Notifier 不需改，只換 [favoritesRepositoryProvider] 的回傳實作。
abstract interface class FavoritesRepository {
  /// 取得所有收藏紀錄。
  Future<List<FavoriteEntry>> getAll();

  /// 新增一筆收藏（animalSubId 為唯一識別）。
  Future<FavoriteEntry> add(String animalSubId);

  /// 移除一筆收藏。
  Future<void> remove(String animalSubId);

  /// 是否已收藏。
  Future<bool> isFavorited(String animalSubId);
}
