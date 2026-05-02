/// 收藏紀錄。
///
/// 訪客模式：id 由本地產生（UUID），user_id 固定為 'guest'。
/// 帳號模式：id 與 user_id 由 API 回傳。
class FavoriteEntry {
  const FavoriteEntry({
    required this.id,
    required this.userId,
    required this.animalSubId,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String animalSubId;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'animal_subid': animalSubId,
        'created_at': createdAt.toIso8601String(),
      };

  factory FavoriteEntry.fromJson(Map<String, dynamic> json) => FavoriteEntry(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        animalSubId: json['animal_subid'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
