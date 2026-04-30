import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/state/animal_list_provider.dart';
import 'package:super_adoption/core/widgets/error_fallback_card.dart';

class AnimalListScreen extends ConsumerStatefulWidget {
  const AnimalListScreen({super.key, this.initialKind, this.initialAge});

  final String? initialKind;
  final String? initialAge;

  @override
  ConsumerState<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends ConsumerState<AnimalListScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _syncInitialShortcutFilter();
  }

  @override
  void didUpdateWidget(covariant AnimalListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialKind != widget.initialKind ||
        oldWidget.initialAge != widget.initialAge) {
      _syncInitialShortcutFilter();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 320) {
      ref.read(animalProvider.notifier).loadMore();
    }
  }

  Future<void> _applyQuickFilter(AnimalFilter filter) {
    return ref.read(animalProvider.notifier).applyFilter(filter);
  }

  void _syncInitialShortcutFilter() {
    if (widget.initialKind == null && widget.initialAge == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(animalProvider.notifier)
          .applyFilter(
            AnimalFilter.initial().copyWith(
              kind: widget.initialKind,
              age: widget.initialAge,
            ),
          );
    });
  }

  Future<void> _openFilterSheet() async {
    final current = ref.read(animalProvider).filter;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AnimalFilterSheet(
          filter: current,
          onApply: (filter) async {
            Navigator.pop(context);
            await ref.read(animalProvider.notifier).applyFilter(filter);
          },
          onReset: () async {
            Navigator.pop(context);
            await ref
                .read(animalProvider.notifier)
                .applyFilter(AnimalFilter.initial());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(animalProvider);
    final filter = state.filter;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(animalProvider.notifier).refresh(),
          child: CustomScrollView(
            controller: _scrollController,
            key: const PageStorageKey('animal-list-scroll-position'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(child: _AnimalListHeader()),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  height: 116,
                  child: _StickyFilterHeader(
                    filter: filter,
                    onChanged: _applyQuickFilter,
                    onFilterTap: _openFilterSheet,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
                sliver: _buildBodySliver(theme, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodySliver(ThemeData theme, dynamic state) {
    if (state.isLoading && !state.hasContent) {
      return const SliverToBoxAdapter(
        child: _StatusPanel(
          icon: Icons.hourglass_top_rounded,
          title: '載入中',
          message: '正在整理最新的可認養毛孩資料。',
        ),
      );
    }

    if (state.showFullscreenError) {
      return const SliverToBoxAdapter(
        child: ErrorFallbackCard(
          message: '資料暫時無法載入，請稍後再試。',
        ),
      );
    }

    if (state.isEmpty) {
      return const SliverToBoxAdapter(
        child: ErrorFallbackCard(
          message: '目前沒有符合條件的毛孩。',
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverList.separated(
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            return _AnimalLargeCard(animal: state.items[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 18),
        ),
        if (state.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Center(
                child: Text(
                  '載入更多中...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AnimalListHeader extends StatelessWidget {
  const _AnimalListHeader();

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
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ),
      ],
    );
  }
}

class _QuickFilterChips extends StatelessWidget {
  const _QuickFilterChips({required this.filter, required this.onChanged});

  final AnimalFilter filter;
  final ValueChanged<AnimalFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChipButton(
            label: '全部',
            selected: !filter.hasFilter,
            onTap: () => onChanged(AnimalFilter.initial()),
          ),
          _FilterChipButton(
            label: '狗狗',
            selected: filter.kind == '狗',
            onTap: () => onChanged(AnimalFilter.initial().copyWith(kind: '狗')),
          ),
          _FilterChipButton(
            label: '貓貓',
            selected: filter.kind == '貓',
            onTap: () => onChanged(AnimalFilter.initial().copyWith(kind: '貓')),
          ),
          _FilterChipButton(
            label: '幼年',
            selected: filter.age == 'CHILD',
            onTap: () =>
                onChanged(AnimalFilter.initial().copyWith(age: 'CHILD')),
          ),
          _FilterChipButton(
            label: '成年',
            selected: filter.age == 'ADULT',
            onTap: () =>
                onChanged(AnimalFilter.initial().copyWith(age: 'ADULT')),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.14)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.32)
                  : colorScheme.outlineVariant,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _SortFilterBar extends StatelessWidget {
  const _SortFilterBar({required this.filterCount, required this.onFilterTap});

  final int filterCount;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Text(
          '最新上架',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 20,
          color: colorScheme.onSurface,
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onFilterTap,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          iconAlignment: IconAlignment.end,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.tune_rounded, size: 18),
              if (filterCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: Text(
            filterCount > 0 ? '篩選條件 $filterCount' : '篩選條件',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _StickyFilterHeader extends StatelessWidget {
  const _StickyFilterHeader({
    required this.filter,
    required this.onChanged,
    required this.onFilterTap,
  });

  final AnimalFilter filter;
  final ValueChanged<AnimalFilter> onChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _QuickFilterChips(filter: filter, onChanged: onChanged),
            const SizedBox(height: 14),
            _SortFilterBar(
              filterCount: filter.filterCount,
              onFilterTap: onFilterTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

class _AnimalLargeCard extends StatelessWidget {
  const _AnimalLargeCard({required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.18 : 0.07,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _AnimalCoverImage(imageUrl: animal.imageUrl),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.90),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    animal.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: animal.isFavorite
                        ? colorScheme.secondary
                        : colorScheme.onSurface,
                    size: 23,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (animal.gender.isNotEmpty)
                      _AnimalTag(
                        label: animal.gender,
                        color: colorScheme.primary,
                      ),
                    if (animal.bodyType.isNotEmpty)
                      _AnimalTag(
                        label: animal.bodyType,
                        color: colorScheme.secondary,
                      ),
                    if (animal.age.isNotEmpty)
                      _AnimalTag(
                        label: animal.age,
                        color: colorScheme.tertiary,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        animal.shelterName.isNotEmpty
                            ? animal.shelterName
                            : animal.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '近期上架',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimalCoverImage extends StatelessWidget {
  const _AnimalCoverImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (imageUrl.isEmpty) {
      return const _AnimalImageFallback();
    }

    return Image.network(
      imageUrl,
      height: 230,
      width: double.infinity,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          height: 230,
          color: colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const _AnimalImageFallback();
      },
    );
  }
}

class _AnimalImageFallback extends StatelessWidget {
  const _AnimalImageFallback();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/error_fallback.png',
      height: 230,
      width: double.infinity,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}

class _AnimalTag extends StatelessWidget {
  const _AnimalTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AnimalFilterSheet extends StatefulWidget {
  const _AnimalFilterSheet({
    required this.filter,
    required this.onApply,
    required this.onReset,
  });

  final AnimalFilter filter;
  final ValueChanged<AnimalFilter> onApply;
  final VoidCallback onReset;

  @override
  State<_AnimalFilterSheet> createState() => _AnimalFilterSheetState();
}

class _AnimalFilterSheetState extends State<_AnimalFilterSheet> {
  late AnimalFilter draft;

  @override
  void initState() {
    super.initState();
    draft = widget.filter;
  }

  void updateDraft(AnimalFilter value) {
    setState(() => draft = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 80),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '篩選條件',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SheetSection(
              title: '種類',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _sheetChip(
                    '全部',
                    draft.kind == null,
                    () => updateDraft(draft.copyWith(kind: null)),
                  ),
                  _sheetChip(
                    '狗狗',
                    draft.kind == '狗',
                    () => updateDraft(draft.copyWith(kind: '狗')),
                  ),
                  _sheetChip(
                    '貓貓',
                    draft.kind == '貓',
                    () => updateDraft(draft.copyWith(kind: '貓')),
                  ),
                ],
              ),
            ),
            _SheetSection(
              title: '年齡',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _sheetChip(
                    '全部',
                    draft.age == null,
                    () => updateDraft(draft.copyWith(age: null)),
                  ),
                  _sheetChip(
                    '幼年',
                    draft.age == 'CHILD',
                    () => updateDraft(draft.copyWith(age: 'CHILD')),
                  ),
                  _sheetChip(
                    '成年',
                    draft.age == 'ADULT',
                    () => updateDraft(draft.copyWith(age: 'ADULT')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onReset,
                    child: const Text('重設'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => widget.onApply(draft),
                    child: const Text('套用篩選'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetChip(String label, bool selected, VoidCallback onTap) {
    return _FilterChipButton(label: label, selected: selected, onTap: onTap);
  }
}

class _SheetSection extends StatelessWidget {
  const _SheetSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
