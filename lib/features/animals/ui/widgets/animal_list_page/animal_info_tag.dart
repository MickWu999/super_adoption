import 'package:flutter/material.dart';

class AnimalInfoTag extends StatelessWidget {
  const AnimalInfoTag({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.padding,
    this.backgroundOpacity = 0.12,
    this.textStyle,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double backgroundOpacity;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = label.trim();

    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    final resolvedStyle =
        textStyle ?? theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        );

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
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(text, style: resolvedStyle),
        ],
      ),
    );
  }
}
