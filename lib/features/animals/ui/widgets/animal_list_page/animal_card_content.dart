import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_info_tag.dart';

class AnimalCardContent extends StatelessWidget {
  const AnimalCardContent({super.key, required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createdDateLabel = animal.createdDate.isNotBlank
        ? '${animal.createdDate} 上架'
        : '近期上架';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                animal.name.or('待認養毛孩'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
            ),
            const Gap(8),
            AnimalInfoTag(
              label: animal.gender,
              color: animal.isFemale ? Colors.pink : Colors.blue,
              icon: animal.isFemale ? Icons.female_rounded : Icons.male_rounded,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ],
        ),
        const Gap(8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AnimalInfoTag(
              label: animal.variety,
              color: theme.colorScheme.primary,
            ),
            AnimalInfoTag(
              label: animal.bodyType,
              color: theme.colorScheme.secondary,
            ),
            AnimalInfoTag(label: animal.age, color: theme.colorScheme.tertiary),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 15, color: Colors.red),
            const Gap(4),
            Expanded(
              child: Text(
                animal.areaName.or('地點未提供'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            const Gap(8),
            Icon(
              Icons.schedule_rounded,
              size: 14,
              color: theme.colorScheme.outline,
            ),
            const Gap(4),
            Text(
              createdDateLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
