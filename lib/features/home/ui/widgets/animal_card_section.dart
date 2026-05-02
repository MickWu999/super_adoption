import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/enum/load_status.dart';
import 'package:super_adoption/core/widgets/circle_icon_button.dart';
import 'package:super_adoption/core/widgets/error_fallback_card.dart';
import 'package:super_adoption/core/widgets/animal_network_image.dart';
import 'package:super_adoption/core/widgets/skeleton_box.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_info_tag.dart';
import 'package:super_adoption/features/favorites/state/favorites_provider.dart';

class _AnimalCardTokens {
  const _AnimalCardTokens._();

  // Section layout sizes
  static const horizontalHeight = 300.0; // 橫向列表高度
  static const itemSpacing = 12.0; // 卡片之間間距
  static const headerSpacing = 14.0; // 標題與內容距離

  // Card sizes
  static const defaultWidth = 180.0; // 預設卡片寬度
  static const radius = 14.0; // 卡片圓角
  static const imageHeight = 200.0; // 卡片圖片高度
}

class AnimalCardSection extends StatelessWidget {
  const AnimalCardSection({
    super.key,
    required this.title,
    required this.animals,
    required this.onMoreTap,
    this.status = LoadStatus.success,
    this.onAnimalTap,
  });

  final String title;
  final List<Animal> animals;
  final VoidCallback onMoreTap;
  final LoadStatus status;
  final ValueChanged<Animal>? onAnimalTap;
  bool get _isLoading => status == LoadStatus.loading;
  bool get _isError => status == LoadStatus.error;

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return const ErrorFallbackCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title, onMoreTap: onMoreTap),
        const Gap(_AnimalCardTokens.headerSpacing),
        if (_isLoading)
          const _LoadingBody()
        else
          SizedBox(
            height: _AnimalCardTokens.horizontalHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: animals.length,
              separatorBuilder: (_, _) =>
                  const Gap(_AnimalCardTokens.itemSpacing),
              itemBuilder: (context, index) {
                final animal = animals[index];

                return _AnimalCard(
                  animal: animal,
                  onTap: onAnimalTap == null
                      ? null
                      : () => onAnimalTap!(animal),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onMoreTap});

  final String title;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const Spacer(),
        TextButton(
          onPressed: onMoreTap,
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurfaceVariant,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Row(
            children: [
              Text('更多'),
              Gap(2),
              Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _AnimalCardTokens.horizontalHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: 2,
        separatorBuilder: (_, _) => const Gap(_AnimalCardTokens.itemSpacing),
        itemBuilder: (context, index) {
          return const _AnimalCardSkeleton();
        },
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({required this.animal, this.onTap});

  final Animal animal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: _AnimalCardTokens.defaultWidth,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(_AnimalCardTokens.radius),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.18 : 0.06,
            ),
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
              InkWell(
                onTap: onTap,
                child: AnimalNetworkImage(
                  imageUrl: animal.imageUrl,
                  height: _AnimalCardTokens.imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: AnimalCardContent(animal: animal, theme: theme),
          ),
        ],
      ),
    );
  }
}

class AnimalCardContent extends ConsumerWidget {
  const AnimalCardContent({
    super.key,
    required this.animal,
    required this.theme,
  });

  final Animal animal;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final detailText = '${animal.bodyType}・${animal.age}';
    final isFavorite = ref.watch(favoritesProvider).contains(animal.animalSubId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                animal.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            ),
            CircleIconButton(
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              iconColor: isFavorite
                  ? colorScheme.secondary
                  : colorScheme.onSurfaceVariant,
              iconSize: 16,
              size: 32,
              onTap: () =>
                  ref.read(favoritesProvider.notifier).toggle(animal.animalSubId),
            ),
          ],
        ),
        const Gap(4),
        Row(
          children: [
            AnimalInfoTag(
              color: animal.isFemale ? Colors.pink : Colors.blue,
              icon: animal.isFemale ? Icons.female_rounded : Icons.male_rounded,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            ),
            const Gap(6),
            Expanded(
              child: Text(
                detailText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),

        const Gap(8),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 15, color: Colors.red),
            const Gap(4),
            Expanded(
              child: Text(
                '${animal.displayAreaName}・3.2 km',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimalCardSkeleton extends StatelessWidget {
  const _AnimalCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: SizedBox(
        width: _AnimalCardTokens.defaultWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 對應 AnimalNetworkImage(height: imageHeight)
            const SkeletonBox(
              height: _AnimalCardTokens.imageHeight,
              radius: _AnimalCardTokens.radius,
            ),
            // 對應 Padding(EdgeInsets.fromLTRB(12, 10, 12, 10))
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 對應 Row([Text(name), Gap(8), AnimalInfoTag])
                  // tag 高度 = icon(15) + padding(v:4×2) = 23px，決定 Row 高度
                  Row(
                    children: const [
                      Expanded(
                        flex: 3,
                        child: SkeletonBox(height: 18, radius: 8),
                      ),
                      Gap(8),
                      SkeletonBox(width: 35, height: 23, radius: 999),
                    ],
                  ),
                  // 對應 Gap(6) + Text(detailText, bodyMedium≈14px)
                  const Gap(6),
                  const SkeletonBox(width: 128, height: 14, radius: 8),
                  // 對應 Gap(8) + Row(location, icon size 15)
                  const Gap(8),
                  const SkeletonBox(height: 15, radius: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
