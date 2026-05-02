import 'package:super_adoption/core/extension/ext.dart';

import '../../model/animal.dart';
import '../dto/gov_animal_dto.dart';

extension GovAnimalMapper on GovAnimalDto {
  Animal toDomain() {
    return Animal(
      animalId:
          animalId?.toString() ??
          '', // API 回傳的 ID 是 int，但我們 domain model 定義為 String。
      animalSubId: animalSubId.safe,
      areaId: areaId,
      shelterId: shelterId,
      place: place.safe,
      kind: _mapType(kind),
      variety: _mapVariety(variety),
      sex: sex.safe,
      bodyType: _mapBody(bodyType),
      color: color.safe,
      age: _mapAge(age),
      sterilization: _mapSterilization(sterilization),
      bacterin: _mapBacterin(bacterin),
      foundPlace: foundPlace.safe,
      title: title.safe,
      status: status.safe,
      remark: remark.safe,
      caption: caption.safe,
      openDate: openDate.safe,
      closeDate: closeDate.safe,
      updateDate: updateDate.safe,
      createDate: createDate.safe,
      shelterName: shelterName.safe,
      imageUrl: imageUrl.safe,
      albumUpdate: albumUpdate.safe,
      cDate: cDate.safe,
      shelterAddress: shelterAddress.safe,
      shelterTel: shelterTel.safe,
    );
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
}
