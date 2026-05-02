import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_adoption/core/env/env.dart';
import 'package:super_adoption/core/router/app_router.dart';
import 'package:super_adoption/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase DB schema 建議放在專案 db/migrations/*.sql 管理。
  // 使用者帳號由 Supabase Auth 的 auth.users 管理，App 端資料放 public.profiles / public.animal_favorites。
  try {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  } catch (error, stackTrace) {
    debugPrint('Supabase initialize failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    rethrow;
  }

  runApp(ProviderScope(child: const SuperAdoptionApp()));
}

class SuperAdoptionApp extends ConsumerWidget {
  const SuperAdoptionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp.router(
        title: '超級認養',
        routerConfig: router,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
