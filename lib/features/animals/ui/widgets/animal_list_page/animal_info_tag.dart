import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/extension/ext.dart';

class AnimalInfoTag extends StatelessWidget {
  const AnimalInfoTag({
    super.key,
    this.label,
    required this.color,
    this.icon,
    this.padding,
  });

  final String? label;
  final Color color;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text = label.safe;
    final hasText = text.isNotBlank;
    final hasIcon = icon != null;
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIcon)
            Icon(icon, size: 16, color: color, weight: 700),
          if (hasIcon && hasText) const Gap(4),
          if (hasText)
            Text(
              text,
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
        ],
      ),
    );
  }
}
