import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/constants/ui_dimensions.dart';
import 'package:super_adoption/core/extension/color_scheme_extension.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/anima_gender_tag.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_info_tag.dart';

class AnimalCardContent extends StatelessWidget {
  const AnimalCardContent({super.key, required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createdDateLabel = animal.createDate.isNotBlank
      ? '${animal.createDate} 上架'
        : '近期上架';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                animal.displayName.or('待認養毛孩'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
            ),
            Gap(UIDimensions.gapSmall.t),
            AnimalGenderTag(animal: animal),
          ],
        ),
        Gap(UIDimensions.gapSmall.t),
        Wrap(
          spacing: UIDimensions.gapSmall.t,
          runSpacing: UIDimensions.gapSmall.t,
          children: [
            AnimalInfoTag(
              label: animal.variety,
              color: theme.colorScheme.primary,
            ),
            AnimalInfoTag(
              label: animal.displayBodyType,
              color: theme.colorScheme.secondary,
            ),
            AnimalInfoTag(label: animal.displayAge, color: theme.colorScheme.tertiary),
          ],
        ),
        Gap(UIDimensions.gapSmall.t),
        Row(
          children: [
            Icon(Icons.location_on_rounded, size: UIDimensions.iconSizeXSmall.t, color: Theme.of(context).colorScheme.locationIconColor,),
            Gap(UIDimensions.gapXSmall.t),
            Expanded(
              child: Text(
                animal.displayAreaName.or('地點未提供'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Gap(UIDimensions.gapSmall.t),
            Icon(
              Icons.schedule_rounded,
              size: UIDimensions.iconSizeMini.t,
              color: theme.colorScheme.outline,
            ),
            Gap(UIDimensions.gapXSmall.t),
            Text(
              createdDateLabel,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
