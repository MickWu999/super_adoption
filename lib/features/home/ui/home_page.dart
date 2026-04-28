import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:super_adoption/core/router/app_router.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_card_section.dart';
import 'package:super_adoption/features/home/ui/widgets/activity_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '超級認養',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.pets_rounded,
                              color: colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '給牠一個家，牠會用一生愛你',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.push(AppRoutes.notifications);
                        },
                        icon: const Icon(Icons.notifications_none_rounded),
                        iconSize: 30,
                      ),
                      Positioned(
                        right: 9,
                        top: 10,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const ActivityBanner(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _CategoryShortcut(
                    assetPath: 'assets/svgs/dog.svg',
                    label: '狗狗',
                  ),
                  _CategoryShortcut(
                    assetPath: 'assets/svgs/cat.svg',
                    label: '貓貓',
                  ),
                  _CategoryShortcut(
                    assetPath: 'assets/svgs/dog.svg',
                    label: '幼年',
                  ),
                  _CategoryShortcut(
                    assetPath: 'assets/svgs/dog.svg',
                    label: '成犬',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimalCardSection(
                title: '本週新毛孩',

                animals: _demoAnimals,

                direction: Axis.horizontal,

                onMoreTap: () {
                  context.push(AppRoutes.animals);
                },
              ),
              const SizedBox(height: 14),
              AnimalCardSection(
                title: '熱門毛孩',
                animals: _demoAnimals,
                direction: Axis.horizontal,
                onMoreTap: () {
                  context.push(AppRoutes.animals);
                },
              ),
              const SizedBox(height: 28),
              const _AdoptionReminderCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryShortcut extends StatelessWidget {
  const _CategoryShortcut({required this.assetPath, required this.label});

  static const _radius = 24.0;

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(_radius),
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(assetPath),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdoptionReminderCard extends StatelessWidget {
  const _AdoptionReminderCard();

  static const _radius = 18.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 18, 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              color: colorScheme.tertiary,
              size: 40,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      const TextSpan(text: '認養前'),
                      TextSpan(
                        text: '小提醒',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '認養是一輩子的承諾，\n請先了解認養流程與注意事項喔！',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.primary,
            size: 28,
          ),
        ],
      ),
    );
  }
}

const _demoAnimals = [
  HomeAnimal(
    name: '黑色米克斯犬',
    description: '女生・中型・成年',
    location: '台中市動物之家',
    imagePath: 'assets/images/home-dog.png',
    isFavorite: true,
  ),
  HomeAnimal(
    name: '虎斑貓',
    description: '男生・幼年',
    location: '新北市動保處',
    imagePath: 'assets/images/home-dog.png',
  ),
  HomeAnimal(
    name: '米克斯犬',
    description: '男生・大型・成年',
    location: '桃園市動物保護教育園區',
    imagePath: 'assets/images/home-dog.png',
  ),
];
