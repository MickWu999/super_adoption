import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_adoption/features/auth/state/auth_provider.dart';
import 'package:super_adoption/features/favorites/data/repository/favorites_repository.dart';
import 'package:super_adoption/features/favorites/model/favorite_entry.dart';
import 'package:uuid/uuid.dart';

part 'local_favorites_repository.g.dart';

/// ═══════════════════════════════════════════════════════
/// API 切換點：這裡是收藏功能唯一要改的地方。
///
/// 目前：訪客模式 → LocalFavoritesRepository（SharedPreferences）
/// 未來：帳號模式 → RemoteFavoritesRepository（API）
///
///   步驟：
///   1. 建立 RemoteFavoritesRepository implements FavoritesRepository
///   2. 取消下方 if 區塊的註解，填入你的 Dio / API client provider
///   3. 所有 UI / Notifier 零改動
/// ═══════════════════════════════════════════════════════
@riverpod
FavoritesRepository favoritesRepository(Ref ref) {
  final auth = ref.watch(authRepositoryProvider);

  if (auth.isLoggedIn) {
    // TODO(api): return RemoteFavoritesRepository(ref.watch(dioProvider));
    // RemoteFavoritesRepository 實作 FavoritesRepository 介面，
    // 呼叫後端 GET/POST/DELETE /api/favorites。
  }

  return const LocalFavoritesRepository(); // 訪客模式
}

class LocalFavoritesRepository implements FavoritesRepository {
  const LocalFavoritesRepository();

  static const _key = 'guest_favorites';
  static const _guestUserId = 'guest';
  static const _uuid = Uuid();

  @override
  Future<List<FavoriteEntry>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .cast<Map<String, dynamic>>()
        .map(FavoriteEntry.fromJson)
        .toList();
  }

  @override
  Future<FavoriteEntry> add(String animalSubId) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAll();

    // 防止重複
    if (all.any((e) => e.animalSubId == animalSubId)) {
      return all.firstWhere((e) => e.animalSubId == animalSubId);
    }

    final entry = FavoriteEntry(
      id: _uuid.v4(),
      userId: _guestUserId,
      animalSubId: animalSubId,
      createdAt: DateTime.now().toUtc(),
    );

    final updated = [...all, entry];
    await prefs.setString(_key, jsonEncode(updated.map((e) => e.toJson()).toList()));
    return entry;
  }

  @override
  Future<void> remove(String animalSubId) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAll();
    final updated = all.where((e) => e.animalSubId != animalSubId).toList();
    await prefs.setString(_key, jsonEncode(updated.map((e) => e.toJson()).toList()));
  }

  @override
  Future<bool> isFavorited(String animalSubId) async {
    final all = await getAll();
    return all.any((e) => e.animalSubId == animalSubId);
  }

  /// 帳號模式登入後：把訪客收藏的 subId 清單提供給帳號 repository 同步。
  Future<List<String>> getGuestSubIds() async {
    final all = await getAll();
    return all.map((e) => e.animalSubId).toList();
  }

  /// 帳號登入成功，已同步至遠端後清除本地資料。
  Future<void> clearGuestFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
