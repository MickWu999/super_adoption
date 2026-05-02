import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';

class CategoryShortcut extends StatelessWidget {
  const CategoryShortcut({
    super.key,
    required this.assetPath,
    required this.label,
    this.onTap,
  });

  static const _radius = 24.0;

  final String assetPath;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(_radius.tr),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 62.t,
            height: 62.t,
            padding: EdgeInsets.all(13.t),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(assetPath),
          ),
          Gap(8.t),
          Text(
            label,
            style: theme.textTheme.titleMedium
          ),
        ],
      ),
    );
  }
}
