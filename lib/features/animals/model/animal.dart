import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal.freezed.dart';

@freezed
abstract class Animal with _$Animal {
  const Animal._();

  const factory Animal({
  required String id,

  @Default('') String name,
  @Default('') String type,
  @Default('') String variety,
  @Default('') String gender,
  @Default('') String age,
  @Default('') String bodyType,
  @Default('') String color,
  @Default('') String shelterName,
  @Default('') String location,
  @Default('') String areaName,
  @Default('') String imageUrl,
  @Default('') String shelterPhone,
  @Default('') String shelterAddress,
  @Default('') String foundPlace,
  @Default('') String sterilization,
  @Default('') String bacterin,
  @Default('') String openDate,
  @Default('') String createdDate,
  @Default('') String status,
  @Default('') String updateDate,
  @Default('') String remark,

  @Default(false) bool isFavorite,
}) = _Animal;

  bool get isFemale => gender == '女生';
}
