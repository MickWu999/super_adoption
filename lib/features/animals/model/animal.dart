import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal.freezed.dart';

@freezed
abstract class Animal with _$Animal {
  const Animal._();

  const factory Animal({
    required String animalId,
    @Default('') String animalSubId,
    int? areaId,
    int? shelterId,
    @Default('') String place,
    @Default('') String kind,
    @Default('') String variety,
    @Default('') String sex,
    @Default('') String bodyType,
    @Default('') String color,
    @Default('') String age,
    @Default('') String sterilization,
    @Default('') String bacterin,
    @Default('') String foundPlace,
    @Default('') String title,
    @Default('') String status,
    @Default('') String remark,
    @Default('') String caption,
    @Default('') String openDate,
    @Default('') String closeDate,
    @Default('') String updateDate,
    @Default('') String createDate,
    @Default('') String shelterName,
    @Default('') String imageUrl,
    @Default('') String albumUpdate,
    @Default('') String cDate,
    @Default('') String shelterAddress,
    @Default('') String shelterTel,
  }) = _Animal;

  String get displayName => _buildName();
  String get displayGender => _mapGender(sex);
  String get displayAreaName => _mapAreaName(areaId);
  String get displayStatus => _mapStatus(status);

  bool get isFemale => sex.trim().toUpperCase() == 'F';

  String _buildName() {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isNotEmpty) return normalizedTitle;

    final kindName = kind.trim();
    final colorName = color.trim();
    final colorWithKind = '$colorName$kindName'.trim();
    if (colorName.isNotEmpty && kindName.isNotEmpty) return colorWithKind;

    final varietyName = variety.replaceAll(RegExp(r'\s+'), '').trim();
    final varietyWithKind = '$varietyName$kindName'.trim();
    if (varietyName.isNotEmpty && kindName.isNotEmpty) return varietyWithKind;

    if (varietyName.isNotEmpty) return varietyName;
    if (kindName.isNotEmpty) return kindName;
    if (colorName.isNotEmpty) return colorName;
    return '';
  }

  String _mapGender(String v) {
    final value = v.trim().toUpperCase();
    if (value == 'M') return '男生';
    if (value == 'F') return '女生';
    if (value == 'N') return '未輸入';
    return '';
  }

  String _mapStatus(String v) {
    final value = v.trim().toUpperCase();
    switch (value) {
      case 'OPEN':
        return '開放認養中';
      case 'ADOPTED':
        return '已被認養';
      case 'NONE':
        return '未公告';
      case 'OTHER':
        return '其他';
      case 'DEAD':
        return '死亡';
      case 'CLOSE':
      case 'CLOSED':
        return '暫停開放';
      default:
        return v.trim();
    }
  }

  String _mapAreaName(int? rawAreaId) {
    const areaCodeMap = {
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

    return areaCodeMap[rawAreaId] ?? '';
  }
}
