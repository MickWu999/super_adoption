import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/core/log/app_logger.dart';
import 'package:super_adoption/core/network/dio_provider.dart';

import '../../model/animal.dart';
import '../dto/gov_animal_dto.dart';
import '../mapper/gov_animal_mapper.dart';
import '../query/animal_filter.dart';

part 'animal_repository.g.dart';

/// 動物資料來源介面。
///
/// 之後如果資料來源從農業部 OpenData 改成 Supabase，
/// Notifier 不需要改，只要把 [animalRepositoryProvider] 的實作換掉即可。
abstract interface class AnimalRepository {
  Future<List<Animal>> fetchAnimals(AnimalFilter filter);
}

/// Repository 注入點。
///
/// 目前使用政府 OpenData。
/// 未來若改成 Supabase，只需要改這裡：
/// ```dart
/// return SupabaseAnimalRepository(client: ref.watch(supabaseClientProvider));
/// ```
@riverpod
AnimalRepository animalRepository(Ref ref) {
  final dio = ref.watch(animalApiClientProvider);
  return GovAnimalRepository(dio);
}

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
