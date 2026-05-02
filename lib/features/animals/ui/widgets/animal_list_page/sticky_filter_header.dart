import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/constants/ui_dimensions.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';
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
        padding: EdgeInsets.fromLTRB(
          UIDimensions.pagePadding.t,
          UIDimensions.filterHeaderPaddingTop.t,
          UIDimensions.pagePadding.t,
          UIDimensions.filterHeaderPaddingBottom.t,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuickFilterChips(filter: filter, onChanged: onChanged),
            Gap(14.t),
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
                  blurRadius: 10.t,
                  offset: Offset(0, 4.t),
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
          offset: Offset(0, 32.t),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.tr),
          ),
          color: colorScheme.surface,
          elevation: 4.t,
          itemBuilder: (_) => AnimalSortOrder.values
              .map(
                (order) => PopupMenuItem(
                  value: order,
                  child: Row(
                    children: [
                      Text(order.label, style: theme.textTheme.bodyMedium),
                      if (order == sort.order) ...[
                        Gap(8.t),
                        Icon(
                          Icons.check_rounded,
                          size: 16.t,
                          color: colorScheme.primary,
                        ),
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
              Gap(2.t),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20.t,
                color: colorScheme.onSurface,
              ),
            ],
          ),
        ),
        Gap(4.t),
        // 排序方向切換
        GestureDetector(
          onTap: onSortDirectionToggle,
          child: AnimatedSwitcher(
            duration: UIDimensions.animationNormal,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              sort.ascending
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              key: ValueKey(sort.ascending),
              size: 18.t,
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
            minimumSize: Size(0, 32.t),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          iconAlignment: IconAlignment.end,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.tune_rounded, size: 18.t),
              if (filterCount > 0)
                Positioned(
                  right: -4.t,
                  top: -4.t,
                  child: Container(
                    width: 8.t,
                    height: 8.t,
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
