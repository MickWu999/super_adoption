import 'package:flutter/material.dart';
import 'package:super_adoption/features/animals/model/animal.dart';

class AnimalCardSection extends StatelessWidget {
  const AnimalCardSection({
    super.key,
    required this.title,
    required this.animals,
    required this.onMoreTap,
    this.direction = Axis.horizontal,
  });

  static const _horizontalHeight = 260.0;
  static const _itemSpacing = 12.0;
  static const _headerSpacing = 14.0;

  final String title;
  final List<Animal> animals;
  final VoidCallback onMoreTap;
  final Axis direction;

  bool get _isHorizontal => direction == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        ),
        const SizedBox(height: _headerSpacing),
        if (_isHorizontal)
          SizedBox(
            height: _horizontalHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: animals.length,
              separatorBuilder: (_, _) => const SizedBox(width: _itemSpacing),
              itemBuilder: (context, index) {
                return _AnimalCard(animal: animals[index]);
              },
            ),
          )
        else
          Column(
            children: List.generate(animals.length, (index) {
              final isLast = index == animals.length - 1;

              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : _itemSpacing),
                child: _AnimalCard(
                  animal: animals[index],
                  width: double.infinity,
                ),
              );
            }),
          ),
      ],
    );
  }
}

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({required this.animal, this.width = 180});

  static const _radius = 14.0;
  static const _imageHeight = 136.0;

  final Animal animal;
  final double width;

  bool get _hasImageUrl => animal.imageUrl.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(_radius),
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
              Container(
                height: _imageHeight,
                width: double.infinity,
                color: colorScheme.surfaceContainerHighest,
                child: _hasImageUrl
                    ? Image.network(
                        animal.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) {
                          return _AnimalImagePlaceholder(
                            name: animal.name,
                            height: _imageHeight,
                          );
                        },
                      )
                    : _AnimalImagePlaceholder(
                        name: animal.name,
                        height: _imageHeight,
                      ),
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
    );
  }
}

class _AnimalImagePlaceholder extends StatelessWidget {
  const _AnimalImagePlaceholder({required this.name, required this.height});

  final String name;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.surfaceContainerHighest,
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_rounded,
              size: 34,
              color: colorScheme.primary.withValues(alpha: 0.85),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                name.isEmpty ? '暫無照片' : '$name\n暫無照片',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
