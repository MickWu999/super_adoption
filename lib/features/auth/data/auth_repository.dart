/// 帳號驗證的資料來源介面。
///
/// 訪客模式：[GuestAuthRepository]（永遠未登入）
/// 帳號模式：未來換成 RemoteAuthRepository（JWT / Supabase / Google）
///
/// ─── API 切換點 ───────────────────────────────────────────
/// 只需要改 [authRepositoryProvider] 回傳的實作，其他程式碼不動。
/// ─────────────────────────────────────────────────────────
abstract interface class AuthRepository {
  /// 是否已登入。
  bool get isLoggedIn;

  /// 登入帳號的 user ID；訪客為 null。
  String? get userId;
}

/// 訪客模式實作：永遠未登入。
class GuestAuthRepository implements AuthRepository {
  const GuestAuthRepository();

  @override
  bool get isLoggedIn => false;

  @override
  String? get userId => null;
}
