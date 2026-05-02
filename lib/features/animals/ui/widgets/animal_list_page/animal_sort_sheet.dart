import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/features/animals/data/query/animal_sort_order.dart';

class AnimalSortSheet extends StatelessWidget {
  const AnimalSortSheet({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final AnimalSortOrder current;
  final ValueChanged<AnimalSortOrder> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('排序方式', style: theme.textTheme.titleMedium),
            ),
            const Gap(8),
            for (final order in AnimalSortOrder.values)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(order.label),
                trailing: current == order
                    ? Icon(Icons.check_rounded, color: colorScheme.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onSelected(order);
                },
              ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
