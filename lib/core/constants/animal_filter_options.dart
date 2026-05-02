/// 動物篩選選項常數
class AnimalFilterOptions {
  AnimalFilterOptions._();

  /// 台灣行政區代碼 → 名稱映射
  static const Map<int, String> areaNamesByCode = {
    2: '台北市',
    3: '新北市',
    4: '基隆市',
    5: '宜蘭縣',
    6: '桃園縣',
    7: '新竹縣',
    8: '新竹市',
    9: '苗栗縣',
    10: '台中市',
    11: '彰化縣',
    12: '南投縣',
    13: '雲林縣',
    14: '嘉義縣',
    15: '嘉義市',
    16: '台南市',
    17: '高雄市',
    18: '屏東縣',
    19: '花蓮縣',
    20: '台東縣',
    21: '澎湖縣',
    22: '金門縣',
    23: '連江縣',
  };

  /// 取得地區名稱
  static String getAreaName(int? areaId) {
    if (areaId == null) return '全部地區';
    return areaNamesByCode[areaId] ?? '全部地區';
  }

  // ============= Kind =============

  static const String kindDog = '狗';
  static const String kindCat = '貓';

  /// 種類 label 映射
  static const Map<String, String> kindLabels = {
    kindDog: '狗狗',
    kindCat: '貓貓',
  };

  // ============= Sex =============

  static const String sexMale = 'M';
  static const String sexFemale = 'F';
  static const String sexUnknown = 'N';

  /// 性別 label 映射
  static const Map<String, String> sexLabels = {
    sexMale: '男生',
    sexFemale: '女生',
    sexUnknown: '未輸入',
  };

  // ============= Age =============

  static const String ageChild = 'CHILD';
  static const String ageAdult = 'ADULT';

  /// 年齡 label 映射
  static const Map<String, String> ageLabels = {
    ageChild: '幼年',
    ageAdult: '成年',
  };

  // ============= Body Type =============

  static const String bodySmall = 'SMALL';
  static const String bodyMedium = 'MEDIUM';
  static const String bodyBig = 'BIG';

  /// 體型 label 映射
  static const Map<String, String> bodyTypeLabels = {
    bodySmall: '小型',
    bodyMedium: '中型',
    bodyBig: '大型',
  };
}
