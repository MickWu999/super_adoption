  
import 'package:flutter/material.dart';

enum InfoBarType { info, success, warning, error }

class AppInfoBar extends StatelessWidget {
  const AppInfoBar({
    super.key,
    required this.message,
    this.type = InfoBarType.info,
    this.icon,
    this.actionLabel,
    this.onActionTap,
  });

  final String message;
  final InfoBarType type;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final style = _resolveStyle(colorScheme, type);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: style.borderColor),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? style.icon,
            color: style.foregroundColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: style.foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (actionLabel != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                foregroundColor: style.foregroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }

  _InfoBarStyle _resolveStyle(ColorScheme colorScheme, InfoBarType type) {
    switch (type) {
      case InfoBarType.success:
        return _InfoBarStyle(
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.primary.withValues(alpha: 0.10),
          borderColor: colorScheme.primary.withValues(alpha: 0.18),
          icon: Icons.check_circle_rounded,
        );
      case InfoBarType.warning:
        return _InfoBarStyle(
          foregroundColor: colorScheme.tertiary,
          backgroundColor: colorScheme.tertiary.withValues(alpha: 0.10),
          borderColor: colorScheme.tertiary.withValues(alpha: 0.18),
          icon: Icons.warning_amber_rounded,
        );
      case InfoBarType.error:
        return _InfoBarStyle(
          foregroundColor: colorScheme.error,
          backgroundColor: colorScheme.error.withValues(alpha: 0.10),
          borderColor: colorScheme.error.withValues(alpha: 0.18),
          icon: Icons.error_outline_rounded,
        );
      case InfoBarType.info:
        return _InfoBarStyle(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: colorScheme.surfaceContainerHighest,
          borderColor: colorScheme.outlineVariant,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _InfoBarStyle {
  const _InfoBarStyle({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;
}