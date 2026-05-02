import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/features/auth/data/auth_repository.dart';

part 'auth_provider.g.dart';

/// ═══════════════════════════════════════════════════════
/// API 切換點：未來接帳號系統只需要改這裡。
///
///   1. 建立 RemoteAuthRepository implements AuthRepository
///   2. 把下方 return 改為：
///        return RemoteAuthRepository(ref.watch(supabaseClientProvider));
///   3. [favoritesRepositoryProvider] 會自動感知 isLoggedIn，
///      切換為 RemoteFavoritesRepository，其他程式碼完全不動。
/// ═══════════════════════════════════════════════════════
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  // TODO(api): swap to RemoteAuthRepository when account mode is ready.
  return const GuestAuthRepository();
}
