import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:super_adoption/core/constants/animal_filter_options.dart';
import 'package:super_adoption/core/constants/ui_dimensions.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';
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
  bool showAreaOptions = false;
  String get _selectedAreaName => AnimalFilterOptions.getAreaName(draft.areaId);

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
        margin: EdgeInsets.only(top: 80.t),
        padding: EdgeInsets.fromLTRB(
          UIDimensions.pagePadding.t,
          UIDimensions.pagePadding.t,
          UIDimensions.pagePadding.t,
          24.t,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(UIDimensions.sheetRadius.tr),
          ),
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
              ),
              _AreaSelectorSection(
                selectedAreaName: _selectedAreaName,
                isExpanded: showAreaOptions,
                onToggle: () {
                  setState(() => showAreaOptions = !showAreaOptions);
                },
                child: Wrap(
                  spacing: 10.t,
                  runSpacing: 10.t,
                  children: [
                    _sheetChip(
                      '全部地區',
                      draft.areaId == null,
                      () => updateDraft(draft.copyWith(areaId: null)),
                    ),
                    ...AnimalFilterOptions.areaNamesByCode.entries.map(
                      (entry) => _sheetChip(
                        entry.value,
                        draft.areaId == entry.key,
                        () => updateDraft(draft.copyWith(areaId: entry.key)),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(12.t),
              _SheetSection(
                title: '其他偏好',
                child: Wrap(
                  spacing: 10.t,
                  runSpacing: 10.t,
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
                  spacing: 10.t,
                  runSpacing: 10.t,
                  children: [
                    _sheetChip(
                      '全部',
                      draft.kind == null,
                      () => updateDraft(draft.copyWith(kind: null)),
                    ),
                    _sheetChip(
                      '狗狗',
                      draft.kind == AnimalFilterOptions.kindDog,
                      () => updateDraft(
                        draft.copyWith(kind: AnimalFilterOptions.kindDog),
                      ),
                    ),
                    _sheetChip(
                      '貓貓',
                      draft.kind == AnimalFilterOptions.kindCat,
                      () => updateDraft(
                        draft.copyWith(kind: AnimalFilterOptions.kindCat),
                      ),
                    ),
                  ],
                ),
              ),
              _SheetSection(
                title: '性別',
                child: Wrap(
                  spacing: 10.t,
                  runSpacing: 10.t,
                  children: [
                    _sheetChip(
                      '全部',
                      draft.sex == null,
                      () => updateDraft(draft.copyWith(sex: null)),
                    ),
                    _sheetChip(
                      '男生',
                      draft.sex == AnimalFilterOptions.sexMale,
                      () => updateDraft(
                        draft.copyWith(sex: AnimalFilterOptions.sexMale),
                      ),
                    ),
                    _sheetChip(
                      '女生',
                      draft.sex == AnimalFilterOptions.sexFemale,
                      () => updateDraft(
                        draft.copyWith(sex: AnimalFilterOptions.sexFemale),
                      ),
                    ),
                    _sheetChip(
                      '未輸入',
                      draft.sex == AnimalFilterOptions.sexUnknown,
                      () => updateDraft(
                        draft.copyWith(sex: AnimalFilterOptions.sexUnknown),
                      ),
                    ),
                  ],
                ),
              ),
              _SheetSection(
                title: '年齡',
                child: Wrap(
                  spacing: 10.t,
                  runSpacing: 10.t,
                  children: [
                    _sheetChip(
                      '全部',
                      draft.age == null,
                      () => updateDraft(draft.copyWith(age: null)),
                    ),
                    _sheetChip(
                      '幼年',
                      draft.age == AnimalFilterOptions.ageChild,
                      () => updateDraft(
                        draft.copyWith(age: AnimalFilterOptions.ageChild),
                      ),
                    ),
                    _sheetChip(
                      '成年',
                      draft.age == AnimalFilterOptions.ageAdult,
                      () => updateDraft(
                        draft.copyWith(age: AnimalFilterOptions.ageAdult),
                      ),
                    ),
                  ],
                ),
              ),
              _SheetSection(
                title: '體型',
                child: Wrap(
                  spacing: 10.t,
                  runSpacing: 10.t,
                  children: [
                    _sheetChip(
                      '全部',
                      draft.bodyType == null,
                      () => updateDraft(draft.copyWith(bodyType: null)),
                    ),
                    _sheetChip(
                      '小型',
                      draft.bodyType == AnimalFilterOptions.bodySmall,
                      () => updateDraft(
                        draft.copyWith(bodyType: AnimalFilterOptions.bodySmall),
                      ),
                    ),
                    _sheetChip(
                      '中型',
                      draft.bodyType == AnimalFilterOptions.bodyMedium,
                      () => updateDraft(
                        draft.copyWith(
                          bodyType: AnimalFilterOptions.bodyMedium,
                        ),
                      ),
                    ),
                    _sheetChip(
                      '大型',
                      draft.bodyType == AnimalFilterOptions.bodyBig,
                      () => updateDraft(
                        draft.copyWith(bodyType: AnimalFilterOptions.bodyBig),
                      ),
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
                  Gap(12.t),
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
      padding: EdgeInsets.only(bottom: 18.t),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          Gap(12.t),
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
      padding: EdgeInsets.only(bottom: 18.t),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(14.tr),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.t),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 22.t,
                    color: colorScheme.onSurface,
                  ),
                  Gap(10.t),
                  Text('地區', style: theme.textTheme.titleSmall),
                  const Spacer(),
                  Text(
                    selectedAreaName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Gap(8.t),
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
            Gap(14.t),
            Align(alignment: Alignment.centerLeft, child: child),
          ],
        ],
      ),
    );
  }
}
