import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnimalImagePlaceholder extends StatelessWidget {
  const AnimalImagePlaceholder({
    super.key,
    this.height,
    this.message = '此毛孩沒有照片',
  });

  final double? height;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final child = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surfaceContainerHighest,
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pets_rounded,
              size: 34,
              color: colorScheme.primary.withValues(alpha: 0.85),
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (height != null) {
      return SizedBox(width: double.infinity, height: height, child: child);
    }

    return SizedBox.expand(child: child);
  }
}
