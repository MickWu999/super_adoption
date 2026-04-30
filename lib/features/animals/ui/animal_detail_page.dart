import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:super_adoption/core/widgets/animal_network_image.dart';
import 'package:super_adoption/core/widgets/error_fallback_card.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/state/animal_detail_provider.dart';

class AnimalDetailScreen extends ConsumerWidget {
  const AnimalDetailScreen({super.key, required this.animalId});

  final String animalId;

  static const _imageHeight = 360.0;
  static const _pagePadding = 20.0;
  static const _cardRadius = 26.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final animal = ref.watch(animalDetailProvider(animalId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          if (animal == null)
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const ErrorFallbackCard(),
                        const SizedBox(height: 16),
                        Text(
                          '目前找不到這隻毛孩的詳細資料，請從列表重新進入。',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _DetailHeaderImage(
                    imageUrl: animal.imageUrl,
                    height: _imageHeight,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -28),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        _pagePadding,
                        24,
                        _pagePadding,
                        120,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(_cardRadius),
                        ),
                      ),
                      child: _DetailBody(animal: animal),
                    ),
                  ),
                ),
              ],
            ),
          const _TopActionBar(),
          _BottomActionBar(animal: animal),
        ],
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationText = animal.shelterName.isNotEmpty
        ? animal.shelterName
        : animal.location;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          animal.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoTag(label: animal.gender),
            _InfoTag(label: animal.age),
            _InfoTag(label: animal.bodyType),
            _InfoTag(label: animal.type),
          ],
        ),
        const SizedBox(height: 22),
        _AnimalInfoList(
          rows: [
            _InfoRowData(
              icon: Icons.location_on_outlined,
              label: '收容單位',
              value: locationText,
            ),
            _InfoRowData(
              icon: Icons.place_outlined,
              label: '發現地點',
              value: animal.foundPlace.isNotEmpty ? animal.foundPlace : '未提供',
            ),
            _InfoRowData(
              icon: Icons.call_outlined,
              label: '聯絡電話',
              value: animal.shelterPhone.isNotEmpty
                  ? animal.shelterPhone
                  : '未提供',
            ),
            _InfoRowData(
              icon: Icons.home_outlined,
              label: '收容地址',
              value: animal.shelterAddress.isNotEmpty
                  ? animal.shelterAddress
                  : '未提供',
            ),
            _InfoRowData(
              icon: Icons.medical_information_outlined,
              label: '絕育狀態',
              value: animal.sterilization,
            ),
            _InfoRowData(
              icon: Icons.vaccines_outlined,
              label: '狂犬疫苗',
              value: animal.bacterin,
            ),
            _InfoRowData(
              icon: Icons.event_available_outlined,
              label: '開放認養',
              value: animal.openDate.isNotEmpty ? animal.openDate : '未提供',
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          '詳細介紹',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          animal.remark,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '資料編號：${animal.id}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

class _DetailHeaderImage extends StatelessWidget {
  const _DetailHeaderImage({required this.imageUrl, required this.height});

  final String imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimalNetworkImage(
      imageUrl: imageUrl,
      height: height,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }
}

class _TopActionBar extends StatelessWidget {
  const _TopActionBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            _CircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: context.pop,
            ),
            const Spacer(),
            _CircleIconButton(
              icon: Icons.favorite_rounded,
              iconColor: colorScheme.secondary,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _CircleIconButton(icon: Icons.ios_share_rounded, onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.animal});

  final Animal? animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = animal != null;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isEnabled ? () {} : null,
                icon: const Icon(Icons.call_rounded),
                label: const Text('聯絡電話'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: isEnabled ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: const Text('我要認養'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface.withValues(alpha: 0.88),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            size: 21,
            color: iconColor ?? colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AnimalInfoList extends StatelessWidget {
  const _AnimalInfoList({required this.rows});

  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in rows)
          _InfoRow(
            icon: row.icon,
            label: row.label,
            value: row.value,
            showDivider: row.showDivider,
          ),
      ],
    );
  }
}

class _InfoRowData {
  const _InfoRowData({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = Theme.of(context).colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: dividerColor))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.textTheme.bodySmall?.color),
          const SizedBox(width: 10),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
