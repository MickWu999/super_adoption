import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.size = 42,
    this.iconSize = 21,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          icon,
          size: iconSize,
          color: onTap == null
              ? colorScheme.onSurface.withValues(alpha: 0.35)
              : (iconColor ?? colorScheme.onSurface),
        ),
      ),
    );
  }
}
