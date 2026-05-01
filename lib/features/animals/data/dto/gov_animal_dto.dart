import 'package:freezed_annotation/freezed_annotation.dart';

part 'gov_animal_dto.freezed.dart';
part 'gov_animal_dto.g.dart';

// Gov API JSON
// -> GovAnimalDto
// -> GovAnimalMapper
// -> Animal
// -> AnimalListState / HomeState
// -> UI
@freezed
abstract class GovAnimalDto with _$GovAnimalDto {
  const factory GovAnimalDto({
    @JsonKey(name: 'animal_id') int? animalId,
    @JsonKey(name: 'animal_subid') String? animalSubId,
    @JsonKey(name: 'animal_area_pkid') int? areaId,
    @JsonKey(name: 'animal_shelter_pkid') int? shelterId,
    @JsonKey(name: 'animal_place') String? place,
    @JsonKey(name: 'animal_kind') String? kind,
    @JsonKey(name: 'animal_Variety') String? variety,
    @JsonKey(name: 'animal_sex') String? sex,
    @JsonKey(name: 'animal_bodytype') String? bodyType,
    @JsonKey(name: 'animal_colour') String? color,
    @JsonKey(name: 'animal_age') String? age,
    @JsonKey(name: 'animal_sterilization') String? sterilization,
    @JsonKey(name: 'animal_bacterin') String? bacterin,
    @JsonKey(name: 'animal_foundplace') String? foundPlace,
    @JsonKey(name: 'animal_title') String? title,
    @JsonKey(name: 'animal_status') String? status,
    @JsonKey(name: 'animal_remark') String? remark,
    @JsonKey(name: 'animal_caption') String? caption,
    @JsonKey(name: 'animal_opendate') String? openDate,
    @JsonKey(name: 'animal_closeddate') String? closeDate,
    @JsonKey(name: 'animal_update') String? updateDate,
    @JsonKey(name: 'animal_createtime') String? createDate,
    @JsonKey(name: 'shelter_name') String? shelterName,
    @JsonKey(name: 'album_file') String? imageUrl,
    @JsonKey(name: 'album_update') String? albumUpdate,
    @JsonKey(name: 'cDate') String? cDate,
    @JsonKey(name: 'shelter_address') String? shelterAddress,
    @JsonKey(name: 'shelter_tel') String? shelterTel,
  }) = _GovAnimalDto;

  factory GovAnimalDto.fromJson(Map<String, dynamic> json) =>
      _$GovAnimalDtoFromJson(json);
}
