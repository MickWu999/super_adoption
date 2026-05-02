import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/data/query/animal_sort.dart';
import 'package:super_adoption/features/animals/data/query/animal_sort_order.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/quick_filter_chips.dart';

class StickyFilterHeader extends StatelessWidget {
  const StickyFilterHeader({
    super.key,
    required this.filter,
    required this.onChanged,
    required this.onFilterTap,
    required this.onSortOrderChanged,
    required this.onSortDirectionToggle,
  });

  final AnimalFilter filter;
  final ValueChanged<AnimalFilter> onChanged;
  final VoidCallback onFilterTap;
  final ValueChanged<AnimalSortOrder> onSortOrderChanged;
  final VoidCallback onSortDirectionToggle;

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
              sort: filter.sort,
              onFilterTap: onFilterTap,
              onSortOrderChanged: onSortOrderChanged,
              onSortDirectionToggle: onSortDirectionToggle,
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
  const _SortFilterBar({
    required this.filterCount,
    required this.sort,
    required this.onFilterTap,
    required this.onSortOrderChanged,
    required this.onSortDirectionToggle,
  });

  final int filterCount;
  final AnimalSort sort;
  final VoidCallback onFilterTap;
  final ValueChanged<AnimalSortOrder> onSortOrderChanged;
  final VoidCallback onSortDirectionToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        // 排序欄位選單
        PopupMenuButton<AnimalSortOrder>(
          onSelected: onSortOrderChanged,
          offset: const Offset(0, 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: colorScheme.surface,
          elevation: 4,
          itemBuilder: (_) => AnimalSortOrder.values
              .map(
                (order) => PopupMenuItem(
                  value: order,
                  child: Row(
                    children: [
                      Text(order.label, style: theme.textTheme.bodyMedium),
                      if (order == sort.order) ...[
                        const Gap(8),
                        Icon(Icons.check_rounded, size: 16, color: colorScheme.primary),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(sort.order.label, style: theme.textTheme.titleSmall),
              const Gap(2),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ],
          ),
        ),
        const Gap(4),
        // 排序方向切換
        GestureDetector(
          onTap: onSortDirectionToggle,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              sort.ascending
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              key: ValueKey(sort.ascending),
              size: 18,
              color: colorScheme.onSurface,
            ),
          ),
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
            style: theme.textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}
