/// 動物表格的資料庫欄位名常數
class AnimalTableColumns {
  AnimalTableColumns._();

  // 主鍵及基本
  static const String id = 'latest_animal_id';
  static const String subId = 'sub_id';
  static const String shelterId = 'animal_shelter_pkid';
  static const String areaId = 'animal_area_pkid';

  // 狀態與篩選
  static const String status = 'status';
  static const String kind = 'kind';
  static const String sex = 'sex';
  static const String age = 'age';
  static const String bodyType = 'body_type';
  static const String isInShelter = 'is_in_shelter';
  static const String hasImage = 'image_url';

  // 詳細資料
  static const String variety = 'variety';
  static const String color = 'color';
  static const String sterilization = 'sterilization';
  static const String bacterin = 'bacterin';

  // 位置與地點
  static const String place = 'animal_place';
  static const String foundPlace = 'found_place';
  static const String shelterName = 'shelter_name';
  static const String shelterAddress = 'shelter_address';
  static const String shelterTel = 'shelter_tel';

  // 時間相關
  static const String createTime = 'animal_create_time';
  static const String updateTime = 'animal_update';
  static const String openDate = 'open_date';
  static const String closeDate = 'closed_date';
  static const String cDate = 'cdate';
  static const String albumUpdate = 'album_update';

  // 描述
  static const String title = 'title';
  static const String remark = 'remark';
  static const String caption = 'caption';
}
