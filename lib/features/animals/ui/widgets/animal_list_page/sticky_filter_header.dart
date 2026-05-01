import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/quick_filter_chips.dart';

class StickyFilterHeader extends StatelessWidget {
  const StickyFilterHeader({
    super.key,
    required this.filter,
    required this.onChanged,
    required this.onFilterTap,
  });

  final AnimalFilter filter;
  final ValueChanged<AnimalFilter> onChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuickFilterChips(filter: filter, onChanged: onChanged),
            const Gap(14),
            _SortFilterBar(
              filterCount: filter.filterCount,
              onFilterTap: onFilterTap,
            ),
          ],
        ),
      ),
    );
  }
}

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const StickyHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant StickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

class _SortFilterBar extends StatelessWidget {
  const _SortFilterBar({required this.filterCount, required this.onFilterTap});

  final int filterCount;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Text(
          '最新上架',
          style: theme.textTheme.titleSmall
        ),
        const Gap(4),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 20,
          color: colorScheme.onSurface,
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onFilterTap,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          iconAlignment: IconAlignment.end,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.tune_rounded, size: 18),
              if (filterCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: Text(
            filterCount > 0 ? '篩選條件 $filterCount' : '篩選條件',
            style: theme.textTheme.titleSmall
          ),
        ),
      ],
    );
  }
}
