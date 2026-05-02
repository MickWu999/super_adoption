import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_adoption/core/constants/ui_dimensions.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';
import 'package:super_adoption/core/widgets/animal_network_image.dart';
import 'package:super_adoption/core/widgets/circle_icon_button.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_card_content.dart';
import 'package:super_adoption/features/favorites/state/favorites_provider.dart';

class AnimalLargeCard extends ConsumerWidget {
  const AnimalLargeCard({super.key, required this.animal, this.onTap});

  final Animal animal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFavorite = ref
        .watch(favoritesProvider)
        .contains(animal.animalSubId);

    return InkWell(
      borderRadius: BorderRadius.circular(UIDimensions.cardRadius.tr),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(UIDimensions.cardRadius.tr),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.18 : 0.07,
              ),
              blurRadius: UIDimensions.cardShadowBlur.t,
              offset: Offset(0, UIDimensions.cardShadowOffsetY.t),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AnimalNetworkImage(imageUrl: animal.imageUrl),
                Positioned(
                  right: 12.t,
                  top: 12.t,
                  child: CircleIconButton(
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: isFavorite
                        ? colorScheme.secondary
                        : colorScheme.onSurface,
                    iconSize: UIDimensions.iconSizeMedium.t,
                    size: 40.t,
                    onTap: () => ref
                        .read(favoritesProvider.notifier)
                        .toggle(animal.animalSubId),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                UIDimensions.cardPaddingH.t,
                UIDimensions.cardPaddingV.t,
                UIDimensions.cardPaddingH.t,
                UIDimensions.cardPaddingH.t,
              ),
              child: AnimalCardContent(animal: animal),
            ),
          ],
        ),
      ),
    );
  }
}
