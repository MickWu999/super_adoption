import 'package:flutter/material.dart';
import 'package:super_adoption/core/constants/animal_filter_options.dart';
import 'package:super_adoption/core/constants/ui_dimensions.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';

class QuickFilterChips extends StatelessWidget {
  const QuickFilterChips({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  final AnimalFilter filter;
  final ValueChanged<AnimalFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChipButton(
            label: '全部',
            selected: !filter.hasFilter,
            onTap: () => onChanged(AnimalFilter.initial()),
          ),
          FilterChipButton(
            label: '狗狗',
            selected: filter.kind == AnimalFilterOptions.kindDog,
            onTap: () => onChanged(
              AnimalFilter.initial().copyWith(
                kind: AnimalFilterOptions.kindDog,
              ),
            ),
          ),
          FilterChipButton(
            label: '貓貓',
            selected: filter.kind == AnimalFilterOptions.kindCat,
            onTap: () => onChanged(
              AnimalFilter.initial().copyWith(
                kind: AnimalFilterOptions.kindCat,
              ),
            ),
          ),
          FilterChipButton(
            label: '幼年',
            selected: filter.age == AnimalFilterOptions.ageChild,
            onTap: () => onChanged(
              AnimalFilter.initial().copyWith(
                age: AnimalFilterOptions.ageChild,
              ),
            ),
          ),
          FilterChipButton(
            label: '成年',
            selected: filter.age == AnimalFilterOptions.ageAdult,
            onTap: () => onChanged(
              AnimalFilter.initial().copyWith(
                age: AnimalFilterOptions.ageAdult,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipButton extends StatelessWidget {
  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(right: 10.t),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIDimensions.buttonRadius.tr),
        child: AnimatedContainer(
          duration: UIDimensions.animationFast,
          padding: EdgeInsets.symmetric(horizontal: 18.t, vertical: 10.t),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.14)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(UIDimensions.buttonRadius.tr),
            border: Border.all(
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.32)
                  : colorScheme.outlineVariant,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: UIDimensions.shadowBlur.t,
                      offset: Offset(0, UIDimensions.shadowOffsetY.t),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
