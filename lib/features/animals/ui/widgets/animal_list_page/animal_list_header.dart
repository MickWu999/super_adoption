import 'package:flutter/material.dart';

class AnimalListHeader extends StatelessWidget {
  const AnimalListHeader();

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
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
