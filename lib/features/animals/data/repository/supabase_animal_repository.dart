import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/data/query/animal_sort_order.dart';
import 'package:super_adoption/features/animals/data/repository/animal_table_columns.dart';
import 'package:super_adoption/features/animals/model/animal.dart';
import 'package:super_adoption/features/animals/data/repository/animal_repository.dart';

class SupabaseAnimalRepository implements AnimalRepository {
  const SupabaseAnimalRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Animal>> fetchAnimals(AnimalFilter filter) async {
    var query = _client
        .from('animals')
        .select()
        .eq(AnimalTableColumns.isInShelter, true);

    if (filter.status != null) {
      query = query.eq(AnimalTableColumns.status, filter.status!);
    }
    if (filter.kind != null) {
      query = query.eq(AnimalTableColumns.kind, filter.kind!);
    }
    if (filter.sex != null) {
      query = query.eq(AnimalTableColumns.sex, filter.sex!);
    }
    if (filter.age != null) {
      query = query.eq(AnimalTableColumns.age, filter.age!);
    }
    if (filter.bodyType != null) {
      query = query.eq(AnimalTableColumns.bodyType, filter.bodyType!);
    }
    if (filter.areaId != null) {
      query = query.eq(AnimalTableColumns.areaId, filter.areaId!);
    }
    if (filter.hasImage) {
      query = query.neq(AnimalTableColumns.hasImage, '');
    }

    final sortColumn = switch (filter.sort.order) {
      AnimalSortOrder.createTime => AnimalTableColumns.createTime,
      // AnimalSortOrder.popularity => AnimalTableColumns.popularity,
    };

    final rows = await query
        .order(sortColumn, ascending: filter.sort.ascending)
        .range(filter.skip, filter.skip + filter.top - 1);

    return rows.map(_rowToAnimal).toList();
  }

  Animal _rowToAnimal(Map<String, dynamic> row) {
    String s(String key) => (row[key] as String?) ?? '';
    int? i(String key) => row[key] as int?;

    return Animal(
      animalId: (row[AnimalTableColumns.id] as int?)?.toString() ?? '',
      animalSubId: s(AnimalTableColumns.subId),
      areaId: i(AnimalTableColumns.areaId),
      shelterId: i(AnimalTableColumns.shelterId),
      place: s(AnimalTableColumns.place),
      kind: s(AnimalTableColumns.kind),
      variety: s(AnimalTableColumns.variety),
      sex: s(AnimalTableColumns.sex),
      bodyType: s(AnimalTableColumns.bodyType),
      color: s(AnimalTableColumns.color),
      age: s(AnimalTableColumns.age),
      sterilization: s(AnimalTableColumns.sterilization),
      bacterin: s(AnimalTableColumns.bacterin),
      foundPlace: s(AnimalTableColumns.foundPlace),
      title: s(AnimalTableColumns.title),
      status: s(AnimalTableColumns.status),
      remark: s(AnimalTableColumns.remark),
      caption: s(AnimalTableColumns.caption),
      openDate: s(AnimalTableColumns.openDate),
      closeDate: s(AnimalTableColumns.closeDate),
      updateDate: s(AnimalTableColumns.updateTime),
      createDate: s(AnimalTableColumns.createTime),
      shelterName: s(AnimalTableColumns.shelterName),
      imageUrl: s(AnimalTableColumns.hasImage),
      albumUpdate: s(AnimalTableColumns.albumUpdate),
      cDate: s(AnimalTableColumns.cDate),
      shelterAddress: s(AnimalTableColumns.shelterAddress),
      shelterTel: s(AnimalTableColumns.shelterTel),
    );
  }
}
