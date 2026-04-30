import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/state/animal_list_state.dart';
import 'package:super_adoption/features/animals/state/animal_list_provider.dart';
import 'package:super_adoption/core/widgets/error_fallback_card.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_filter_sheet.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_list_header.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_list_loading.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_large_card.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/sticky_filter_header.dart';

class AnimalListScreen extends ConsumerStatefulWidget {
  const AnimalListScreen({super.key, this.initialKind, this.initialAge});

  final String? initialKind;
  final String? initialAge;

  @override
  ConsumerState<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends ConsumerState<AnimalListScreen> {
  final _scrollController = ScrollController();

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
        return AnimalFilterSheet(
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
                sliver: SliverToBoxAdapter(child: AnimalListHeader()),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyHeaderDelegate(
                  height: 116,
                  child: StickyFilterHeader(
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

  Widget _buildBodySliver(ThemeData theme, AnimalListState state) {
    if (state.isLoading && !state.hasContent) {
      return const AnimalListLoadingSliver();
    }

    if (state.showFullscreenError) {
      return const SliverToBoxAdapter(
        child: ErrorFallbackCard(message: '資料暫時無法載入，請稍後再試。'),
      );
    }

    if (state.isEmpty) {
      return const SliverToBoxAdapter(
        child: ErrorFallbackCard(message: '目前沒有符合條件的毛孩。'),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverList.separated(
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            return AnimalLargeCard(animal: state.items[index]);
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
