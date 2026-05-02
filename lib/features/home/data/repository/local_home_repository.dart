import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/animals/data/repository/animal_repository.dart';
import 'package:super_adoption/features/home/data/repository/home_repository.dart';
import 'package:super_adoption/features/home/model/home_banner.dart';
import 'package:super_adoption/features/home/state/home_state.dart';

/// 暫時實作：banner 用假資料，動物清單來自政府 OpenData。
///
/// 未來後端提供 Home API 後，建立 RemoteHomeRepository 取代此類。
class LocalHomeRepository implements HomeRepository {
  const LocalHomeRepository({required AnimalRepository animalRepository})
      : _animalRepository = animalRepository;

  final AnimalRepository _animalRepository;

  @override
  Future<HomeState> fetchHome() async {
    final animals = await _animalRepository.fetchAnimals(
      const AnimalFilter(top: 20),
    );

    // TODO(api): Replace with backend response once Home API is ready.
    // Expected fields: imageUrl, websiteUrl, title, description, startAt, endAt, displayDate
    final banners = [
      HomeBanner(
        imageUrl: 'assets/images/home-activity-banner.png',
        websiteUrl: 'https://www.youtube.com/watch?v=VE5vIgK_RJA',
        title: '4月認養活動',
        description:
            '讓全台灣找家的毛孩一起等幸福😻  想添加新成員的你就別再猶豫拉～也歡迎大家告知親朋好友多一個人知道就多一份機會！我們一起動起來讓浪浪們早日回家💝',
        startAt: DateTime.parse("2027-04-30T09:00:00+08:00"),
        endAt: DateTime.parse("2027-05-01T18:00:00+08:00"),
        displayDate: '04/30 - 05/01',
      ),
      HomeBanner(
        imageUrl: 'assets/images/home-activity-banner.png',
        websiteUrl: 'https://www.youtube.com/watch?v=VE5vIgK_RJA',
        title: '認養不棄養',
        description: '一起成為好家人',
        startAt: DateTime.parse("2027-05-05T09:00:00+08:00"),
        endAt: DateTime.parse("2027-05-08T18:00:00+08:00"),
        displayDate: '05/05 - 05/08',
      ),
    ];

    return HomeState(
      banners: banners,
      newAnimals: animals.take(10).toList(),
      popularAnimals: animals.skip(10).take(10).toList(),
    );
  }
}
