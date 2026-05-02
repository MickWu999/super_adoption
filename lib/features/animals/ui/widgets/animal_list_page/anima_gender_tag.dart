import 'package:flutter/material.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_info_tag.dart';

class AnimalGenderTag extends StatelessWidget {
  const AnimalGenderTag({
    super.key,
    required this.animal,
    this.showLabel = true,
    this.horizontalPadding = 12,
    this.verticalPadding = 8,
  });

  final Animal animal;
  final bool showLabel;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = animal.isFemale
        ? Colors.pink
        : animal.isMale
            ? Colors.blue
            : theme.colorScheme.outline;

    final icon = animal.isFemale
        ? Icons.female_rounded
        : animal.isMale
            ? Icons.male_rounded
            : Icons.help_outline_rounded;

    return AnimalInfoTag(
      label: showLabel ? animal.displayGender : '',
      color: color,
      icon: icon,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
    );
  }
}