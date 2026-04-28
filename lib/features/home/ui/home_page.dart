import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _primary = Color(0xFFFF8A00);
  static const _favorite = Color(0xFFFF5A5F);
  static const _bannerBackground = Color(0xFFFFF3E5);
  static const _cardBorder = Color(0xFFEAEAEA);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                            const Icon(
                              Icons.pets_rounded,
                              color: _primary,
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
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded),
                        iconSize: 30,
                      ),
                      Positioned(
                        right: 9,
                        top: 10,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: _primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const _ActivityBanner(),
              const SizedBox(height: 26),
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
              const SizedBox(height: 28),
              Row(
                children: [
                  Text(
                    '今日新增',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: theme.textTheme.bodySmall?.color,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      children: [
                        Text('更多'),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: _demoAnimals.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final animal = _demoAnimals[index];
                    return _AnimalCard(animal: animal);
                  },
                ),
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

class _ActivityBanner extends StatelessWidget {
  const _ActivityBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: HomeScreen._bannerBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home-activity-banner.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          Positioned(
            left: 24,
            top: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '給毛孩一個',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '溫暖的家',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: HomeScreen._primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.favorite_rounded,
                      color: HomeScreen._favorite,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryShortcut extends StatelessWidget {
  const _CategoryShortcut({required this.assetPath, required this.label});

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            padding: const EdgeInsets.all(13),
            decoration: const BoxDecoration(
              color: HomeScreen._bannerBackground,
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

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({required this.animal});

  final _HomeAnimal animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HomeScreen._cardBorder),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                animal.imagePath,
                height: 136,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Icon(
                  animal.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: animal.isFavorite
                      ? HomeScreen._favorite
                      : Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  animal.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        animal.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdoptionReminderCard extends StatelessWidget {
  const _AdoptionReminderCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 18, 20),
      decoration: BoxDecoration(
        color: HomeScreen._bannerBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              color: Color(0xFF8D7A67),
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
                    children: const [
                      TextSpan(text: '認養前'),
                      TextSpan(
                        text: '小提醒',
                        style: TextStyle(color: HomeScreen._primary),
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

class _HomeAnimal {
  const _HomeAnimal({
    required this.name,
    required this.description,
    required this.location,
    required this.imagePath,
    this.isFavorite = false,
  });

  final String name;
  final String description;
  final String location;
  final String imagePath;
  final bool isFavorite;
}

const _demoAnimals = [
  _HomeAnimal(
    name: '黑色米克斯犬',
    description: '女生・中型・成年',
    location: '台中市動物之家',
    imagePath: 'assets/images/home-dog.png',
    isFavorite: true,
  ),
  _HomeAnimal(
    name: '虎斑貓',
    description: '男生・幼年',
    location: '新北市動保處',
    imagePath: 'assets/images/home-dog.png',
  ),
  _HomeAnimal(
    name: '米克斯犬',
    description: '男生・大型・成年',
    location: '桃園市動物保護教育園區',
    imagePath: 'assets/images/home-dog.png',
  ),
];
