import 'package:flutter/material.dart';
import 'package:super_adoption/core/enum/load_status.dart';
import 'package:super_adoption/core/widgets/error_fallback_card.dart';
import 'package:super_adoption/core/widgets/skeleton_box.dart';
import 'package:super_adoption/features/home/model/home_banner.dart';

class ActivityBanner extends StatefulWidget {
  const ActivityBanner({
    super.key,
    required this.banners,
    required this.status,
    this.onTap,
  });

  final List<HomeBanner> banners;
  final LoadStatus status;
  final ValueChanged<HomeBanner>? onTap;

  @override
  State<ActivityBanner> createState() => _ActivityBannerState();
}

class _ActivityBannerState extends State<ActivityBanner> {
  static const _radius = 18.0;
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;

    if (widget.status == LoadStatus.loading) {
      return const SkeletonShimmer(
        child: SkeletonBox(height: 150, radius: _radius),
      );
    }

    if (widget.status == LoadStatus.error) {
      return const ErrorFallbackCard();
    }

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final banner = banners[index];

                return Material(
                  color: colorScheme.surfaceContainerHighest,
                  child: InkWell(
                    onTap: widget.onTap == null
                        ? null
                        : () => widget.onTap!(banner),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            banner.imageUrl,
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        Positioned(
                          left: 24,
                          top: 28,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.title ?? '',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    banner.subtitle ?? '',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: colorScheme.primary,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.favorite_rounded,
                                    color: colorScheme.secondary,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (banners.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: index == _currentIndex ? 18 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
