import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
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
        .eq('is_in_shelter', true);

    if (filter.status != null) {
      query = query.eq('status', filter.status!);
    }
    if (filter.kind != null) {
      query = query.eq('kind', filter.kind!);
    }
    if (filter.sex != null) {
      query = query.eq('sex', filter.sex!);
    }
    if (filter.age != null) {
      query = query.eq('age', filter.age!);
    }
    if (filter.bodyType != null) {
      query = query.eq('body_type', filter.bodyType!);
    }
    if (filter.areaId != null) {
      query = query.eq('animal_area_pkid', filter.areaId!);
    }

    final rows = await query
        .order('animal_create_time', ascending: false)
        .range(filter.skip, filter.skip + filter.top - 1);

    return rows.map(_rowToAnimal).toList();
  }

  Animal _rowToAnimal(Map<String, dynamic> row) {
    String s(String key) => (row[key] as String?) ?? '';
    int? i(String key) => row[key] as int?;

    return Animal(
      animalId: (row['latest_animal_id'] as int?)?.toString() ?? '',
      animalSubId: s('sub_id'),
      areaId: i('animal_area_pkid'),
      shelterId: i('animal_shelter_pkid'),
      place: s('animal_place'),
      kind: s('kind'),
      variety: s('variety'),
      sex: s('sex'),
      bodyType: s('body_type'),
      color: s('color'),
      age: s('age'),
      sterilization: s('sterilization'),
      bacterin: s('bacterin'),
      foundPlace: s('found_place'),
      title: s('title'),
      status: s('status'),
      remark: s('remark'),
      caption: s('caption'),
      openDate: s('open_date'),
      closeDate: s('closed_date'),
      updateDate: s('animal_update'),
      createDate: s('animal_create_time'),
      shelterName: s('shelter_name'),
      imageUrl: s('image_url'),
      albumUpdate: s('album_update'),
      cDate: s('cdate'),
      shelterAddress: s('shelter_address'),
      shelterTel: s('shelter_tel'),
    );
  }
}
