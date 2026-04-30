import 'package:flutter/material.dart';
import 'package:super_adoption/core/enum/load_status.dart';
import 'package:super_adoption/core/widgets/error_fallback_card.dart';
import 'package:super_adoption/core/widgets/animal_network_image.dart';
import 'package:super_adoption/core/widgets/skeleton_box.dart';
import 'package:super_adoption/features/animals/model/animal.dart';

class _AnimalCardTokens {
  const _AnimalCardTokens._();

  // Section layout sizes
  static const horizontalHeight = 260.0; // 橫向列表高度
  static const itemSpacing = 12.0; // 卡片之間間距
  static const headerSpacing = 14.0; // 標題與內容距離

  // Card sizes
  static const defaultWidth = 180.0; // 預設卡片寬度
  static const radius = 14.0; // 卡片圓角
  static const imageHeight = 136.0; // 卡片圖片高度
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
        const SizedBox(height: _AnimalCardTokens.headerSpacing),
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
                  const SizedBox(width: _AnimalCardTokens.itemSpacing),
              itemBuilder: (context, index) {
                return _AnimalCard(
                  animal: animals[index],
                  onTap: onAnimalTap == null
                      ? null
                      : () => onAnimalTap!(animals[index]),
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
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onMoreTap,
          style: TextButton.styleFrom(
            foregroundColor: theme.textTheme.bodyMedium?.color,
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
        separatorBuilder: (_, _) =>
            const SizedBox(width: _AnimalCardTokens.itemSpacing),
        itemBuilder: (context, index) {
          return const _AnimalCardSkeleton();
        },
      ),
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
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(height: 136, radius: 14),
            SizedBox(height: 10),
            SkeletonBox(width: 96, height: 16, radius: 8),
            SizedBox(height: 8),
            SkeletonBox(width: 128, height: 14, radius: 8),
            SizedBox(height: 8),
            SkeletonBox(width: 110, height: 12, radius: 8),
          ],
        ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(_AnimalCardTokens.radius),
        onTap: onTap,
        child: Container(
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
                  AnimalNetworkImage(
                    imageUrl: animal.imageUrl,
                    height: _AnimalCardTokens.imageHeight,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Icon(
                      animal.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: animal.isFavorite
                          ? colorScheme.secondary
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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${animal.gender}・${animal.bodyType}・${animal.age}',
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
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
