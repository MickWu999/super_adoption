import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/core/router/app_router.dart';
import 'package:super_adoption/core/widgets/animal_network_image.dart';
import 'package:super_adoption/core/widgets/circle_icon_button.dart';
import 'package:super_adoption/core/widgets/error_fallback_card.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/state/animal_detail_provider.dart';
import 'package:super_adoption/features/favorites/state/favorites_provider.dart';
import 'package:super_adoption/features/home/ui/widgets/animal_card_section.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final relatedAnimals = ref.watch(relatedAnimalsProvider(animalId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          if (animal == null)
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: Gap(120)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const ErrorFallbackCard(),
                        const Gap(16),
                        Text(
                          '目前找不到這隻毛孩的詳細資料，請從列表重新進入。',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
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
                  child: AnimalNetworkImage(
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
                      child: _DetailBody(
                        animal: animal,
                        relatedAnimals: relatedAnimals,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          _TopActionBar(
            animal: animal,
            onFavoriteTap: animal == null
                ? null
                : () => ref
                      .read(favoritesProvider.notifier)
                      .toggle(animal.animalSubId),
          ),
          _BottomActionBar(animal: animal),
        ],
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.animal, required this.relatedAnimals});

  final Animal animal;
  final List<Animal> relatedAnimals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                animal.displayName,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            const Gap(12),
            _StatusTag(status: animal.displayStatus),
          ],
        ),
        const Gap(12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoTag(label: animal.displayGender),
            _InfoTag(label: animal.age),
            _InfoTag(label: animal.bodyType),
            _InfoTag(label: animal.kind),
          ],
        ),
        const Gap(18),
        _ShelterInfoCard(animal: animal),
        const Gap(18),
        const _AdoptionReminderCard(),
        const Gap(24),
        Text('詳細介紹', style: theme.textTheme.titleMedium),
        const Gap(10),
        Text(
          animal.remark,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
        const Gap(24),
        _AnimalInfoList(
          rows: [
            _InfoRowData(
              icon: Icons.location_on_outlined,
              label: '收容單位',
              value: animal.shelterName,
            ),
            _InfoRowData(
              icon: Icons.place_outlined,
              label: '發現地點',
              value: animal.foundPlace,
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
              label: '開放日期',
              value: animal.openDate,
              showDivider: false,
            ),
          ],
        ),
        if (relatedAnimals.isNotEmpty) ...[
          const Gap(28),
          AnimalCardSection(
            title: '你可能也喜歡',
            animals: relatedAnimals,
            onMoreTap: () => context.push(AppRoutes.animals),
            onAnimalTap: (animal) {
              context.push(AppRoutes.animalDetail(animal.animalId));
            },
          ),
        ],
      ],
    );
  }
}

class _TopActionBar extends ConsumerWidget {
  const _TopActionBar({required this.animal, required this.onFavoriteTap});

  final Animal? animal;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFavorite = animal != null
        ? ref.watch(favoritesProvider).contains(animal!.animalSubId)
        : false;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            CircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: context.pop,
            ),
            const Spacer(),
            CircleIconButton(
              icon: Icons.search_rounded,
              onTap: animal == null
                  ? null
                  : () => _launchUri(
                      context,
                      _officialAdoptionUri,
                      errorMessage: '目前無法開啟官方詳細資訊頁。',
                    ),
            ),
            const Gap(10),
            CircleIconButton(
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              iconColor: isFavorite
                  ? colorScheme.secondary
                  : colorScheme.onSurfaceVariant,
              onTap: onFavoriteTap,
            ),
            const Gap(10),
            CircleIconButton(icon: Icons.ios_share_rounded, onTap: () {}),
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
                onPressed: isEnabled
                    ? () => _callShelter(context, animal!.shelterTel)
                    : null,
                icon: const Icon(Icons.call_rounded),
                label: const Text('聯絡電話'),
              ),
            ),
            const Gap(12),
            Expanded(
              child: ElevatedButton(
                onPressed: isEnabled
                    ? () => _showAdoptionConfirmSheet(context, animal!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: theme.textTheme.titleSmall,
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

class _ShelterInfoCard extends StatelessWidget {
  const _ShelterInfoCard({required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.home_work_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  '收容所資訊卡',
                  style: theme.textTheme.titleMedium?.copyWith(),
                ),
              ),
              TextButton.icon(
                onPressed: () => _openMap(context, animal.shelterAddress),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text('查看地圖'),
              ),
            ],
          ),
          const Gap(12),
          _CardInfoRow(label: '地址', value: animal.shelterAddress.or('未提供')),
          _CardInfoRow(label: '電話', value: animal.shelterTel.or('未提供')),
          const _CardInfoRow(
            label: '開放時間',
            value: '請依各收容所現場公告與官方頁面為準',
            showDivider: false,
          ),
          const Gap(14),
          FilledButton.tonalIcon(
            onPressed: () => _launchUri(
              context,
              _officialShelterUri,
              errorMessage: '目前無法開啟收容所資訊頁。',
            ),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('查看更多收容所資訊'),
          ),
        ],
      ),
    );
  }
}

class _AdoptionReminderCard extends StatelessWidget {
  const _AdoptionReminderCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
              const Gap(10),
              Text('認養提醒', style: theme.textTheme.titleMedium),
            ],
          ),
          const Gap(12),
          _ReminderLine(text: '請攜帶身分證件，現場通常會進行基本資料核對。'),
          _ReminderLine(text: '收容單位可能安排現場評估，包含環境與照護認知。'),
          _ReminderLine(text: '認養前請再次確認時間、醫療、活動與終養能力。'),
        ],
      ),
    );
  }
}

class _DataMetaCard extends StatelessWidget {
  const _DataMetaCard({required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('資料來源與更新', style: theme.textTheme.titleSmall),
          const Gap(10),
          _CardInfoRow(label: '照片來源', value: '農業部動物保護資訊網 / 政府開放資料'),
          _CardInfoRow(
            label: '更新時間',
            value: animal.updateDate.or('未提供'),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOpen = status.contains('開放');
    final isAdopted = status.contains('已被認養');
    final Color color = isOpen
        ? Colors.green
        : isAdopted
        ? colorScheme.secondary
        : colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: theme.textTheme.bodySmall?.copyWith(color: color),
      ),
    );
  }
}

class _ReminderLine extends StatelessWidget {
  const _ReminderLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: colorScheme.primary,
          ),
          const Gap(8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _CardInfoRow extends StatelessWidget {
  const _CardInfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = Theme.of(context).colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: dividerColor))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
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
        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary),
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
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const Gap(10),
          SizedBox(
            width: 72,
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showAdoptionConfirmSheet(
  BuildContext context,
  Animal animal,
) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('聯絡前確認', style: theme.textTheme.titleLarge),
            const Gap(10),
            Text(
              '建議先確認自身照護能力、可投入時間與費用，再與收容單位聯繫安排後續認養流程。',
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: colorScheme.onSurface.withValues(alpha: 0.78),
              ),
            ),
            const Gap(16),
            const _ReminderLine(text: '請準備可核對身份的證件。'),
            const _ReminderLine(text: '現場通常需要進行認養評估與說明。'),
            const _ReminderLine(text: '若家中已有寵物，請先評估相處與隔離安排。'),
            const Gap(18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _launchUri(
                        context,
                        _officialAdoptionUri,
                        errorMessage: '目前無法開啟官方認養資訊頁。',
                      );
                    },
                    child: const Text('官方資訊'),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _callShelter(context, animal.shelterTel);
                    },
                    child: const Text('撥打電話'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _callShelter(BuildContext context, String phone) async {
  final sanitized = phone.replaceAll(RegExp(r'[^0-9,+]'), '');
  if (sanitized.isEmpty) {
    _showSnackBar(context, '目前沒有可聯繫的電話資訊。');
    return;
  }

  final uri = Uri(scheme: 'tel', path: sanitized);
  await _launchUri(context, uri, errorMessage: '目前無法撥打電話。');
}

Future<void> _openMap(BuildContext context, String address) async {
  if (address.isEmpty) {
    _showSnackBar(context, '目前沒有可查看的地址資訊。');
    return;
  }

  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
  );
  await _launchUri(context, uri, errorMessage: '目前無法開啟地圖。');
}

Future<void> _launchUri(
  BuildContext context,
  Uri uri, {
  required String errorMessage,
}) async {
  final didLaunch = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  if (!didLaunch && context.mounted) {
    _showSnackBar(context, errorMessage);
  }
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

final _officialAdoptionUri = Uri.parse(
  'https://animal.moa.gov.tw/Frontend/AdoptSearch/AdoptInfo',
);

final _officialShelterUri = Uri.parse(
  'https://animal.moa.gov.tw/Frontend/PublicShelter',
);
