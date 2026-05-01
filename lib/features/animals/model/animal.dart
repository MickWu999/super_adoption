import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal.freezed.dart';

@freezed
abstract class Animal with _$Animal {
  const factory Animal({
    required String id,
    required String name,
    required String type,
    @Default('') String variety,
    required String gender,
    required String age,
    required String bodyType,
    required String color,
    required String shelterName,
    required String location,
    required String imageUrl,
    required String shelterPhone,
    required String shelterAddress,
    @Default('') String foundPlace,
    @Default('') String sterilization,
    @Default('') String bacterin,
    @Default('') String openDate,
    @Default('') String createdDate,
    @Default('') String status,
    @Default('') String updateDate,
    @Default('') String remark,
    required bool isFavorite,
  }) = _Animal;
}
