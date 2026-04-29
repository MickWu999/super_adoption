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
    const banners = [
      HomeBanner(
        imageUrl: 'assets/images/home-activity-banner.png',
        websiteUrl: 'https://example.com/adoption-campaign',
        title: '給毛孩一個',
        subtitle: '溫暖的家',
      ),
      HomeBanner(
        imageUrl: 'assets/images/home-activity-banner.png',
        websiteUrl: 'https://example.com/pet-care',
        title: '認養不棄養',
        subtitle: '一起成為好家人',
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
