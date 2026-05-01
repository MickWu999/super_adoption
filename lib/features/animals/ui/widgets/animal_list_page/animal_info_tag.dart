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
    this.iconSize = 16,
    this.iconWeight = 700,
    this.fontSize,
    this.fontWeight = FontWeight.w900,
    this.backgroundOpacity = 0.12,
    this.gap = 4,
  });

  final String? label;
  final Color color;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  final double iconSize;
  final double iconWeight;
  final double? fontSize;
  final FontWeight fontWeight;
  final double backgroundOpacity;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text = label.safe;
    final hasText = text.hasValue;
    final hasIcon = icon != null;

    if (!hasText && !hasIcon) {
      return const SizedBox.shrink();
    }

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: backgroundOpacity),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIcon)
            Icon(icon, size: iconSize, color: color, weight: iconWeight),
          if (hasIcon && hasText) Gap(gap),
          if (hasText)
            Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
        ],
      ),
    );
  }
}
