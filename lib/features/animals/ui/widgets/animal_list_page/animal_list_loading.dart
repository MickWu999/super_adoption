import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/widgets/skeleton_box.dart';

class AnimalListLoadingSliver extends StatelessWidget {
  const AnimalListLoadingSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: 3,
      itemBuilder: (context, index) => const _AnimalLargeCardSkeleton(),
      separatorBuilder: (context, index) => const Gap(18),
    );
  }
}

class _AnimalLargeCardSkeleton extends StatelessWidget {
  const _AnimalLargeCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(height: 230, radius: 22),
          const Gap(14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 132, height: 20, radius: 8),
                Gap(10),
                Row(
                  children: [
                    SkeletonBox(width: 56, height: 28, radius: 999),
                    Gap(8),
                    SkeletonBox(width: 56, height: 28, radius: 999),
                    Gap(8),
                    SkeletonBox(width: 56, height: 28, radius: 999),
                  ],
                ),
                Gap(12),
                SkeletonBox(width: 170, height: 16, radius: 8),
                Gap(8),
                SkeletonBox(width: 92, height: 14, radius: 8),
              ],
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
