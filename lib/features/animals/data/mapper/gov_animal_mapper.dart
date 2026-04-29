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
      gender: _mapGender(sex),
      age: _mapAge(age),
      bodyType: _mapBody(bodyType),
      color: color ?? '',
      shelterName: shelterName ?? '',
      location: place ?? '',
      imageUrl: imageUrl ?? '',
      shelterPhone: shelterTel ?? '',
      shelterAddress: shelterAddress ?? '',
      isFavorite: false,
    );
  }

  String _buildName() {
    if ((title ?? '').isNotEmpty) return title!;
    return '${color ?? ''}${kind ?? ''}';
  }

  String _mapGender(String? v) {
    if (v == 'M') return '公';
    if (v == 'F') return '母';
    return '未知';
  }

  String _mapAge(String? v) {
    if (v == 'CHILD') return '幼年';
    if (v == 'ADULT') return '成年';
    return '未知';
  }

  String _mapBody(String? v) {
    if (v == 'SMALL') return '小型';
    if (v == 'MEDIUM') return '中型';
    if (v == 'BIG') return '大型';
    return '未知';
  }

  String _mapType(String? v) {
    if (v == '狗') return '狗';
    if (v == '貓') return '貓';
    return '其他';
  }
}
