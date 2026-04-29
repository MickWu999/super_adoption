import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_adoption/features/animals/state/animal_list_provider.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_card_section.dart';

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

    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(animalProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final state = ref.watch(animalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('毛孩列表')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(animalProvider.notifier).refresh(),
        child: ListView(
          controller: _scrollController,
          key: const PageStorageKey('animal-list-scroll-position'),
          padding: const EdgeInsets.all(20),
          children: [
            if (state.isLoading && !state.hasContent)
              const _StatusPanel(
                icon: Icons.hourglass_top_rounded,
                title: '載入中',
                message: '正在整理最新的可認養毛孩資料。',
              )
            else if (state.showFullscreenError)
              _StatusPanel(
                icon: Icons.error_outline_rounded,
                title: '載入失敗',
                message: state.error ?? '資料暫時無法載入，請稍後再試。',
              )
            else if (state.isEmpty)
              const _StatusPanel(
                icon: Icons.search_off_rounded,
                title: '沒有資料',
                message: '目前沒有符合條件的毛孩。',
              )
            else
              AnimalCardSection(
                title: '可認養毛孩',
                animals: state.items,
                direction: Axis.vertical,
                onMoreTap: () {},
              ),
            if (state.isLoadingMore) ...[
              const SizedBox(height: 16),
              Center(
                child: Text('載入更多中...', style: theme.textTheme.bodyMedium),
              ),
            ],
          ],
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
