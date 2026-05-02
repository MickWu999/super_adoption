import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/constants/ui_dimensions.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';

class AdoptionReminderCard extends StatelessWidget {
  const AdoptionReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.t, vertical: 20.t),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18.tr),
      ),
      child: Row(
        children: [
          Container(
            width: 72.t,
            height: 72.t,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(18.tr),
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              color: colorScheme.tertiary,
              size: 40.t,
            ),
          ),
          Gap(18.t),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.titleMedium,
                    children: [
                      const TextSpan(text: '認養前'),
                      TextSpan(
                        text: '小提醒',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                const Gap(UIDimensions.gapSmall),
                Text(
                  '認養是一輩子的承諾，請先了解認養流程與注意事項喔！',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.primary,
            size: UIDimensions.sheetRadius.t,
          ),
        ],
      ),
    );
  }
}
