import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/features/animals/data/repository/animal_repository.dart';
import 'package:super_adoption/features/animals/data/query/animal_filter.dart';
import 'package:super_adoption/features/home/model/home_banner.dart';
import 'package:super_adoption/features/home/state/home_state.dart';

part 'home_repository.g.dart';

abstract interface class HomeRepository {
  Future<HomeState> fetchHome();
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  final animalRepository = ref.watch(animalRepositoryProvider);
  return HomeRepositoryImpl(animalRepository: animalRepository);
}

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({required AnimalRepository animalRepository})
    : _animalRepository = animalRepository;

  final AnimalRepository _animalRepository;

  @override
  Future<HomeState> fetchHome() async {
    final animals = await _animalRepository.fetchAnimals(
      const AnimalFilter(top: 20),
    );

    // TODO: Replace fake banners with backend response once Home API is ready.
    // Expected backend fields:
    // - imageUrl: banner image location
    // - websiteUrl: target web page when user taps the banner
    // The UI already consumes `List<HomeBanner>`, so swapping data source
    // should only require changing this repository.
     List<HomeBanner> banners = [
      HomeBanner(
        imageUrl: 'assets/images/home-activity-banner.png',
        websiteUrl: 'https://www.youtube.com/watch?v=VE5vIgK_RJA',
        title:'4月認養活動',
        description: '讓全台灣找家的毛孩一起等幸福😻  想添加新成員的你就別再猶豫拉～也歡迎大家告知親朋好友多一個人知道就多一份機會！我們一起動起來讓浪浪們早日回家💝讓全台灣找家的毛孩一起等幸福😻  想添加新成員的你就別再猶豫拉～也歡迎大家告知親朋好友多一個人知道就多一份機會！我們一起動起來讓浪浪們早日回家💝讓全台灣找家的毛孩一起等幸福😻  想添加新成員的你就別再猶豫拉～也歡迎大家告知親朋好友多一個人知道就多一份機會！我們一起動起來讓浪浪們早日回家💝讓全台灣找家的毛孩一起等幸福😻  想添加新成員的你就別再猶豫拉～也歡迎大家告知親朋好友多一個人知道就多一份機會！我們一起動起來讓浪浪們早日回家💝讓全台灣找家的毛孩一起等幸福😻  想添加新成員的你就別再猶豫拉～也歡迎大家告知親朋好友多一個人知道就多一份機會！我們一起動起來讓浪浪們早日回家💝',
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
      favoriteAnimals: const [],
    );
  }
}
