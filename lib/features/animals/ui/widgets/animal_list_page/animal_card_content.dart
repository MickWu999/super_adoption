import 'package:flutter/material.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/ui/widgets/animal_list_page/animal_info_tag.dart';

enum AnimalCardContentVariant { compact, detailed }

class AnimalCardContent extends StatelessWidget {
  const AnimalCardContent({
    super.key,
    required this.animal,
    required this.colorScheme,
    this.variant = AnimalCardContentVariant.detailed,
  });

  final Animal animal;
  final ColorScheme colorScheme;

  final AnimalCardContentVariant variant;

  bool get _isCompact => variant == AnimalCardContentVariant.compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final genderText = _genderText(animal.gender);
    final isFemale = genderText == '女生';
    final listedDate = animal.createdDate.isNotEmpty
        ? '${animal.createdDate} 上架'
        : '近期上架';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                animal.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimalInfoTag(
              label: genderText,
              color: isFemale ? Colors.pink : Colors.blue,
              icon: isFemale ? Icons.female_rounded : Icons.male_rounded,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ],
        ),

        SizedBox(height: _isCompact ? 8 : 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AnimalInfoTag(
              label: animal.bodyType,
              color: colorScheme.secondary,
              padding: EdgeInsets.symmetric(
                horizontal: _isCompact ? 9 : 10,
                vertical: _isCompact ? 4 : 5,
              ),
            ),
            AnimalInfoTag(
              label: animal.age,
              color: colorScheme.tertiary,
              padding: EdgeInsets.symmetric(
                horizontal: _isCompact ? 9 : 10,
                vertical: _isCompact ? 4 : 5,
              ),
            ),
          ],
        ),
        SizedBox(height: _isCompact ? 10 : 12),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 15, color: Colors.red),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                _isCompact
                    ? _shortLocation(
                        animal.shelterName.isNotEmpty
                            ? animal.shelterName
                            : animal.location,
                      )
                    : (animal.shelterName.isNotEmpty
                        ? animal.shelterName
                        : animal.location),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (_isCompact
                        ? theme.textTheme.bodySmall
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        if (!_isCompact) ...[
          const SizedBox(height: 8),
          Text(
            listedDate,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  String _genderText(String gender) {
    final text = gender.trim().toUpperCase();

    if (text == 'F' || text == '女生' || text == '母') return '女生';
    if (text == 'M' || text == '男生' || text == '公') return '男生';

    return '';
  }

  String _shortLocation(String location) {
    final text = location.trim();

    if (text.isEmpty) return '位置未提供';
    if (text.contains('台北')) return '台北市';
    if (text.contains('新北')) return '新北市';
    if (text.contains('桃園')) return '桃園市';
    if (text.contains('台中') || text.contains('臺中')) return '台中市';
    if (text.contains('台南') || text.contains('臺南')) return '台南市';
    if (text.contains('高雄')) return '高雄市';

    return text.length > 8 ? text.substring(0, 8) : text;
  }
}
