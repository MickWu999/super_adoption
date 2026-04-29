import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:super_adoption/core/router/app_router.dart';
import 'package:super_adoption/core/widgets/error_view.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_card_section.dart';
import 'package:super_adoption/features/home/state/home_provider.dart';
import 'package:super_adoption/features/home/ui/widgets/activity_banner.dart';
import 'package:super_adoption/features/home/ui/widgets/adoption_reminder_card.dart';
import 'package:super_adoption/features/home/ui/widgets/category_shortcut.dart';
import 'package:super_adoption/features/home/ui/widgets/home_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: homeState.when(
          loading: () => const SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(),
                SizedBox(height: 20),
                _HomeStatusCard(
                  icon: Icons.hourglass_top_rounded,
                  title: '正在載入首頁資料',
                  message: '正在整理 banner 與最新毛孩資料。',
                ),
              ],
            ),
          ),
          error: (error, stackTrace) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SizedBox(height: 20),
                ErrorView(
                  message: error.toString(),
                  onRetry: () {
                    ref.read(homeProvider.notifier).refresh();
                  },
                ),
              ],
            ),
          ),
          data: (data) {
            final newAnimals = data.newAnimals;
            final popularAnimals = data.popularAnimals;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 20),
                  ActivityBanner(
                    banners: data.banners,
                    onTap: (banner) {
                      // TODO: Open banner.websiteUrl when web deep-link behavior is ready.
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CategoryShortcut(
                        assetPath: 'assets/svgs/dog.svg',
                        label: '狗狗',
                      ),
                      CategoryShortcut(
                        assetPath: 'assets/svgs/cat.svg',
                        label: '貓貓',
                      ),
                      CategoryShortcut(
                       assetPath: 'assets/svgs/dog.svg',
                        label: '幼年',
                      ),
                      CategoryShortcut(
                        assetPath: 'assets/svgs/dog.svg',
                        label: '成犬',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimalCardSection(
                    title: '本週新毛孩',
                    animals: newAnimals,
                    direction: Axis.horizontal,
                    onMoreTap: () {
                      context.push(AppRoutes.animals);
                    },
                  ),
                  const SizedBox(height: 14),
                  if (newAnimals.isNotEmpty || popularAnimals.isNotEmpty)
                    AnimalCardSection(
                      title: '熱門毛孩',
                      animals: popularAnimals.isEmpty
                          ? newAnimals
                          : popularAnimals,
                      direction: Axis.horizontal,
                      onMoreTap: () {
                        context.push(AppRoutes.animals);
                      },
                    ),
                  const SizedBox(height: 28),
                  const AdoptionReminderCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


class _HomeStatusCard extends StatelessWidget {
  const _HomeStatusCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


