import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdoptionReminderCard extends StatelessWidget {
  const AdoptionReminderCard({super.key});

  static const _radius = 18.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 18, 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              color: colorScheme.tertiary,
              size: 40,
            ),
          ),
          const Gap(18),
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
                const Gap(8),
                Text(
                  '認養是一輩子的承諾，\n請先了解認養流程與注意事項喔！',
                  style: theme.textTheme.bodyMedium
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.primary,
            size: 28,
          ),
        ],
      ),
    );
  }
}
