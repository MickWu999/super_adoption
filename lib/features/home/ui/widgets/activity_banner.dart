import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool get _isLoading => status == LoadStatus.loading;
  bool get _isError => status == LoadStatus.error;
  @override
  State<ActivityBanner> createState() => _ActivityBannerState();
}

class _ActivityBannerState extends State<ActivityBanner> {
  static const _radius = 18.0;
  static const _height = 160.0;
  final _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _showBannerSheet(HomeBanner banner) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => _BannerInfoSheet(banner: banner),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;

    if (widget._isLoading) {
      return const SkeletonShimmer(
        child: SkeletonBox(height: _height, radius: _radius),
      );
    }

    if (widget._isError) {
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
          height: _height,
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

                return InkWell(
                  onTap: () async {
                    widget.onTap?.call(banner);
                    await _showBannerSheet(banner);
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        if (banners.length > 1) ...[
          const Gap(10),
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

class _BannerInfoSheet extends StatelessWidget {
  const _BannerInfoSheet({required this.banner});

  final HomeBanner banner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasDate = banner.displayDate.hasValue;
    final linkUrl = banner.websiteUrl;
    final linkUri = linkUrl.hasValue ? Uri.tryParse(linkUrl!) : null;
    final hasLink = linkUri != null && linkUri.hasScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        banner.imageUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.campaign_rounded,
                        color: colorScheme.primary,
                        size: 26,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title ?? '最新活動',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            '活動資訊',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (hasDate) ...[
                  const Gap(18),
                  _BannerInfoTile(
                    icon: Icons.event_available_rounded,
                    title: '活動期間',
                    value: banner.displayDate!,
                  ),
                ],
                const Gap(18),
                Text(
                  '活動說明',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(8),
                Text(
                  banner.description ?? '查看更多活動資訊與認養消息。',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                    color: colorScheme.onSurface.withValues(alpha: 0.82),
                  ),
                ),
                const Gap(24),
                if (hasLink)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        await launchUrl(linkUri, mode: LaunchMode.inAppWebView);
                      },
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('查看活動'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BannerInfoTile extends StatelessWidget {
  const _BannerInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(3),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
