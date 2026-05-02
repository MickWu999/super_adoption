import 'package:dio/dio.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/core/log/app_logger.dart';
import 'package:super_adoption/features/animals/data/dto/gov_animal_dto.dart';
import 'package:super_adoption/features/animals/data/mapper/gov_animal_mapper.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/data/repository/animal_repository.dart';
import 'package:super_adoption/features/animals/model/animal.dart';

/// 農業部動物保護資訊網 OpenData 實作。
///
/// API 文件：https://data.coa.gov.tw/Service/OpenData/TransService.aspx
class GovAnimalRepository implements AnimalRepository {
  GovAnimalRepository(this._dio);

  static const _path = '/Service/OpenData/TransService.aspx';
  static const _unitId = 'QcbUEzN6E6DL';

  final Dio _dio;

  @override
  Future<List<Animal>> fetchAnimals(AnimalFilter filter) async {
    AppLogger.instance.i('fetchAnimals filter=$filter');

    final response = await _dio.get<List<dynamic>>(
      _path,
      queryParameters: _buildQueryParameters(filter),
    );

    final list = response.data ?? const [];

    final animals = list
        .whereType<Map>()
        .map((json) => Map<String, dynamic>.from(json))
        .map((json) => GovAnimalDto.fromJson(json).toDomain())
        .toList();

    AppLogger.instance.i('fetchAnimals success count=${animals.length}');

    return animals;
  }

  Map<String, dynamic> _buildQueryParameters(AnimalFilter filter) {
    return {
      'UnitId': _unitId,
      r'$top': filter.top,
      r'$skip': filter.skip,
      if (filter.kind.isNotBlank) 'animal_kind': filter.kind,
      if (filter.sex.isNotBlank) 'animal_sex': filter.sex,
      if (filter.age.isNotBlank) 'animal_age': filter.age,
      if (filter.bodyType.isNotBlank) 'animal_bodytype': filter.bodyType,
      if (filter.status.isNotBlank) 'animal_status': filter.status,
      if (filter.areaId != null) 'animal_area_pkid': filter.areaId,
    };
  }
}
