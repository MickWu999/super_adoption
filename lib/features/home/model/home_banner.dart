import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_banner.freezed.dart';

@freezed
abstract class HomeBanner with _$HomeBanner {
  const factory HomeBanner({
    required String imageUrl,
    String? websiteUrl,
    String? title,
    String? description,
    DateTime? startAt,
    DateTime? endAt,
    String? displayDate,
  }) = _HomeBanner;
}
