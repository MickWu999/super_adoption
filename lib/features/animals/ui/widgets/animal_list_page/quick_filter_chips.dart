import 'package:flutter/material.dart';
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
            selected: filter.kind == '狗',
            onTap: () => onChanged(AnimalFilter.initial().copyWith(kind: '狗')),
          ),
          FilterChipButton(
            label: '貓貓',
            selected: filter.kind == '貓',
            onTap: () => onChanged(AnimalFilter.initial().copyWith(kind: '貓')),
          ),
          FilterChipButton(
            label: '幼年',
            selected: filter.age == 'CHILD',
            onTap: () =>
                onChanged(AnimalFilter.initial().copyWith(age: 'CHILD')),
          ),
          FilterChipButton(
            label: '成年',
            selected: filter.age == 'ADULT',
            onTap: () =>
                onChanged(AnimalFilter.initial().copyWith(age: 'ADULT')),
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
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.14)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.32)
                  : colorScheme.outlineVariant,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
