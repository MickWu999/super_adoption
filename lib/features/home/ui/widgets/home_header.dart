import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';
import 'package:super_adoption/core/router/app_router.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '超級認養',
                style: theme.textTheme.headlineMedium?.copyWith(
                  letterSpacing: 1,
                ),
              ),
              Gap(8.t),
              Row(
                children: [
                  Icon(
                    Icons.pets_rounded,
                    color: colorScheme.primary,
                    size: 18.t,
                  ),
                  Gap(6.t),
                  Text(
                    '給牠一個家，牠會用一生愛你',
                    style: theme.textTheme.bodyMedium
                  ),
                ],
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {
                context.push(AppRoutes.notifications);
              },
              icon: const Icon(Icons.notifications_none_rounded),
              iconSize: 30.t,
            ),
            Positioned(
              right: 9.t,
              top: 10.t,
              child: Container(
                width: 9.t,
                height: 9.t,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
