import 'package:super_adoption/core/extension/ext.dart';

import '../../model/animal.dart';
import '../dto/gov_animal_dto.dart';

extension GovAnimalMapper on GovAnimalDto {
  Animal toDomain() {
    return Animal(
      id:
          animalId?.toString() ??
          '', // API 回傳的 ID 是 int，但我們 domain model 定義為 String。
      name: _buildName(),
      type: _mapType(kind),
      variety: _mapVariety(variety),
      gender: _mapGender(sex),
      age: _mapAge(age),
      bodyType: _mapBody(bodyType),
      color: color.safe,
      shelterName: shelterName.safe,
      location: place.safe,
      areaName: _mapAreaName(areaId),
      imageUrl: imageUrl.safe,
      shelterPhone: shelterTel.safe,
      shelterAddress: shelterAddress.safe,
      foundPlace: foundPlace.safe,
      sterilization: _mapSterilization(sterilization),
      bacterin: _mapBacterin(bacterin),
      openDate: openDate.safe,
      createdDate: createDate.safe,
      status: _mapStatus(status),
      updateDate: updateDate.safe,
      remark: remark.safe,
      isFavorite: false,
    );
  }

  String _buildName() {
    final normalizedTitle = title.safe;
    if (normalizedTitle.isNotBlank) return normalizedTitle;

    final typeName = _mapType(kind);
    final colorName = color.safe;
    final colorWithType = '$colorName$typeName'.trim();
    if (colorName.isNotBlank && typeName.isNotBlank) return colorWithType;

    final varietyName = _mapVariety(variety);
    final varietyWithType = '$varietyName$typeName'.trim();
    if (varietyName.isNotBlank && typeName.isNotBlank) return varietyWithType;

    if (varietyName.isNotBlank) return varietyName;
    if (typeName.isNotBlank) return typeName;
    if (colorName.isNotBlank) return colorName;

    return '';
  }

  String _mapGender(String? v) {
    final value = v.safe.toUpperCase();

    if (value == 'M') return '男生';
    if (value == 'F') return '女生';
    if (value == 'N') return '未輸入';
    return '';
  }

  String _mapAge(String? v) {
    final value = v.safe.toUpperCase();

    if (value == 'CHILD') return '幼年';
    if (value == 'ADULT') return '成年';
    return '';
  }

  String _mapBody(String? v) {
    final value = v.safe.toUpperCase();

    if (value == 'SMALL') return '小型';
    if (value == 'MEDIUM') return '中型';
    if (value == 'BIG') return '大型';
    return '';
  }

  String _mapType(String? v) {
    final value = v.safe;

    if (value == '狗') return '狗';
    if (value == '貓') return '貓';
    return value.safe;
  }

  String _mapVariety(String? v) {
    return v.safe.replaceAll(RegExp(r'\s+'), '');
  }

  String _mapSterilization(String? v) {
    final value = v.safe.toUpperCase();

    if (value == 'T') return '已絕育';
    if (value == 'F') return '未絕育';
    if (value == 'N') return '未輸入';
    return '';
  }

  String _mapBacterin(String? v) {
    final value = v.safe.toUpperCase();

    if (value == 'T') return '已施打';
    if (value == 'F') return '未施打';
    if (value == 'N') return '未輸入';
    return '';
  }

  String _mapStatus(String? v) {
    final value = v.safe.toUpperCase();

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
        return value.safe;
    }
  }

  String _mapAreaName(int? areaId) {
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

    return areaCodeMap[areaId] ?? '';
  }
}
