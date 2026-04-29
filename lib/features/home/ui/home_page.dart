import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:super_adoption/core/router/app_router.dart';
import 'package:super_adoption/core/widgets/app_info_bar.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final homeState = ref.watch(homeProvider);
    final newAnimals = homeState.newAnimals;
    final popularAnimals = homeState.popularAnimals;
    final banners = homeState.banners;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              if (homeState.hasError)
                AppInfoBar(
                  type: InfoBarType.error,
                  message: '資料暫時無法更新，請稍後再試',
                  actionLabel: '重試',
                  onActionTap: () {
                    ref.read(homeProvider.notifier).refresh();
                  },
                ),

              const SizedBox(height: 20),
              ActivityBanner(
                banners: banners,
                status: homeState.status,
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
                isLoading: homeState.isLoading,
                onMoreTap: () {
                  context.push(AppRoutes.animals);
                },
              ),
              const SizedBox(height: 14),
              AnimalCardSection(
                title: '熱門毛孩',
                animals: popularAnimals,
                direction: Axis.horizontal,
                isLoading: homeState.isLoading,
                onMoreTap: () {
                  context.push(AppRoutes.animals);
                },
              ),
              const SizedBox(height: 28),
              const AdoptionReminderCard(),
            ],
          ),
        ),
      ),
    );
  }
}
