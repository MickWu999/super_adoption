import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';
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
          height: _height.t,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius.tr),
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
          Gap(10.t),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: index == _currentIndex ? 18.t : 6.t,
                height: 6.t,
                margin: EdgeInsets.symmetric(horizontal: 3.t),
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(99.tr),
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
    final hasDate = banner.displayDate.isNotBlank;
    final linkUrl = banner.websiteUrl;
    final linkUri = linkUrl.isNotBlank ? Uri.tryParse(linkUrl!) : null;
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.tr)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(20.t, 6.t, 20.t, 24.t),
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
                Gap(20.t),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46.t,
                      height: 46.t,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16.tr),
                      ),
                      child: Icon(
                        Icons.campaign_rounded,
                        color: colorScheme.primary,
                        size: 26.t,
                      ),
                    ),
                    Gap(12.t),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title ?? '最新活動',
                            style: theme.textTheme.titleLarge?.copyWith(
                              height: 1.2,
                            ),
                          ),
                          Gap(6.t),
                          Text(
                            '活動資訊',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (hasDate) ...[
                  Gap(18.t),
                  _BannerInfoTile(
                    icon: Icons.event_available_rounded,
                    title: '活動期間',
                    value: banner.displayDate!,
                  ),
                ],
                Gap(18.t),
                Text(
                  '活動說明',
                  style: theme.textTheme.titleSmall,
                ),
                Gap(8.t),
                Text(
                  banner.description ?? '查看更多活動資訊與認養消息。',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Gap(24.t),
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
      padding: EdgeInsets.all(14.t),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.tr),
        // border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 38.t,
            height: 38.t,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20.t),
          ),
          Gap(12.t),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Gap(3.t),
              Text(
                value,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
