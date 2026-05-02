import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  static const Map<int, String> _areaOptions = {
    2: '台北市',
    3: '新北市',
    4: '基隆市',
    5: '宜蘭縣',
    6: '桃園縣',
    7: '新竹縣',
    8: '新竹市',
    9: '苗栗縣',
    10: '台中市',
    11: '彰化縣',
    12: '南投縣',
    13: '雲林縣',
    14: '嘉義縣',
    15: '嘉義市',
    16: '台南市',
    17: '高雄市',
    18: '屏東縣',
    19: '花蓮縣',
    20: '台東縣',
    21: '澎湖縣',
    22: '金門縣',
    23: '連江縣',
  };

  late AnimalFilter draft;
  bool showAreaOptions = false;
  String get _selectedAreaName {
    final areaId = draft.areaId;
    if (areaId == null) return '全部地區';
    return _areaOptions[areaId] ?? '全部地區';
  }

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('篩選條件', style: theme.textTheme.titleLarge),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),              _AreaSelectorSection(
                selectedAreaName: _selectedAreaName,
                isExpanded: showAreaOptions,
                onToggle: () {
                  setState(() => showAreaOptions = !showAreaOptions);
                },
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _sheetChip(
                      '全部地區',
                      draft.areaId == null,
                      () => updateDraft(draft.copyWith(areaId: null)),
                    ),
                    ..._areaOptions.entries.map(
                      (entry) => _sheetChip(
                        entry.value,
                        draft.areaId == entry.key,
                        () => updateDraft(draft.copyWith(areaId: entry.key)),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              _SheetSection(
                title: '其他偏好',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _sheetChip(
                      '有照片',
                      draft.hasImage,
                      () => updateDraft(
                        draft.copyWith(hasImage: !draft.hasImage),
                      ),
                    ),
                  ],
                ),
              ),
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
                title: '性別',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _sheetChip(
                      '全部',
                      draft.sex == null,
                      () => updateDraft(draft.copyWith(sex: null)),
                    ),
                    _sheetChip(
                      '男生',
                      draft.sex == 'M',
                      () => updateDraft(draft.copyWith(sex: 'M')),
                    ),
                    _sheetChip(
                      '女生',
                      draft.sex == 'F',
                      () => updateDraft(draft.copyWith(sex: 'F')),
                    ),
                    _sheetChip(
                      '未輸入',
                      draft.sex == 'N',
                      () => updateDraft(draft.copyWith(sex: 'N')),
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
              _SheetSection(
                title: '體型',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _sheetChip(
                      '全部',
                      draft.bodyType == null,
                      () => updateDraft(draft.copyWith(bodyType: null)),
                    ),
                    _sheetChip(
                      '小型',
                      draft.bodyType == 'SMALL',
                      () => updateDraft(draft.copyWith(bodyType: 'SMALL')),
                    ),
                    _sheetChip(
                      '中型',
                      draft.bodyType == 'MEDIUM',
                      () => updateDraft(draft.copyWith(bodyType: 'MEDIUM')),
                    ),
                    _sheetChip(
                      '大型',
                      draft.bodyType == 'BIG',
                      () => updateDraft(draft.copyWith(bodyType: 'BIG')),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onReset,
                      child: const Text('重設'),
                    ),
                  ),
                  const Gap(12),
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
          Text(title, style: theme.textTheme.titleSmall),
          const Gap(12),
          child,
        ],
      ),
    );
  }
}

class _AreaSelectorSection extends StatelessWidget {
  const _AreaSelectorSection({
    required this.selectedAreaName,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });

  final String selectedAreaName;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 22,
                    color: colorScheme.onSurface,
                  ),
                  const Gap(10),
                  Text('地區', style: theme.textTheme.titleSmall),
                  const Spacer(),
                  Text(
                    selectedAreaName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Gap(8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          if (isExpanded) ...[
            const Gap(14),
            Align(
              alignment: Alignment.centerLeft,
              child: child,
            ),
          ],
        ],
      ),
    );
  }
}
