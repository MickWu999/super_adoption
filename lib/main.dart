import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_adoption/core/router/app_router.dart';
import 'package:super_adoption/core/theme/app_theme.dart';

void main() {
  runApp(ProviderScope(child: const SuperAdoptionApp()));
}

class SuperAdoptionApp extends ConsumerWidget {
  const SuperAdoptionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {    
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: '超級認養',
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    );
  }
}
