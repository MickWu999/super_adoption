import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/ui/animal_detail_page.dart';
import 'package:super_adoption/features/animals/ui/animal_list_page.dart';
import 'package:super_adoption/features/home/ui/home_page.dart';
import 'package:super_adoption/features/map/ui/map_scree.dart';
import 'package:super_adoption/features/profile/ui/profile_screen.dart';
import 'package:super_adoption/features/favorites/ui/favorite_page.dart';
import 'package:super_adoption/features/shell/ui/main_shell.dart';

import '../../features/start/ui/start_screen.dart';

part 'app_router.g.dart';

/// App route paths 統一管理。
class AppRoutes {
  const AppRoutes._();

  static const start = '/start';
  static const home = '/home';
  static const animals = '/animals';
  static const notifications = '/notifications';
  static const favorites = '/favorites';
  static const map = '/map';
  static const profile = '/profile';

  static String animalDetail(String animalId) => '/animals/$animalId';

  static Uri animalsUri(AnimalFilter filter) {
    return Uri(path: animals, queryParameters: filter.toQueryParameters());
  }
}

/// 你的 App 是 Bottom Tab 架構，建議使用 StatefulShellRoute.indexedStack。
///
/// 好處：
/// - 切換 tab 不會銷毀頁面。
/// - 毛孩列表滑到第 N 筆，切出去再切回來仍保留位置。
/// - Riverpod provider 若不是 autoDispose，也不會因為 tab 切換重新抓資料。
/// - 每個 tab 都能保留自己的 navigation stack。
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.start,
    routes: [
      GoRoute(
        path: AppRoutes.start,
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.animals,
                builder: (context, state) {
                  final kind = state.uri.queryParameters['kind'];
                  final age = state.uri.queryParameters['age'];

                  return AnimalListScreen(initialKind: kind, initialAge: age);
                },
                routes: [
                  GoRoute(
                    path: ':animalId',
                    builder: (context, state) {
                      final animalId = state.pathParameters['animalId']!;
                      return AnimalDetailScreen(animalId: animalId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.map,
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                builder: (context, state) => const FavoritePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('通知')));
  }
}
