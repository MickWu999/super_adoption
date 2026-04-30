import 'package:flutter/material.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/quick_filter_chips.dart';

class AnimalFilterSheet extends StatefulWidget {
  const AnimalFilterSheet({
    super.key,
    required this.filter,
    required this.onApply,
    required this.onReset,
  });

  final AnimalFilter filter;
  final ValueChanged<AnimalFilter> onApply;
  final VoidCallback onReset;

  @override
  State<AnimalFilterSheet> createState() => _AnimalFilterSheetState();
}

class _AnimalFilterSheetState extends State<AnimalFilterSheet> {
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
    return FilterChipButton(label: label, selected: selected, onTap: onTap);
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
