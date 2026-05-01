import 'package:flutter/material.dart';

class AnimalListHeader extends StatelessWidget {
  const AnimalListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Text(
            '毛孩列表',
            style: theme.textTheme.titleLarge?.copyWith(
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
