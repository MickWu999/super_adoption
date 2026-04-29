import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryShortcut extends StatelessWidget {
  const CategoryShortcut({
    super.key,
    required this.assetPath,
    required this.label,
  });

  static const _radius = 24.0;

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(_radius),
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(assetPath),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
