import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:super_adoption/core/widgets/animal_image_placeholder.dart';
import 'package:super_adoption/core/widgets/skeleton_box.dart';

class AnimalNetworkImage extends StatelessWidget {
  const AnimalNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.fit = BoxFit.contain,
  });

  final String imageUrl;
  final double height;
  final BoxFit fit;

  bool get _hasImageUrl => imageUrl.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final fallbackBackground = const Color(0xFFFAFAFA);

    if (!_hasImageUrl) {
      return AnimalImagePlaceholder(height: height);
    }

    return ColoredBox(
      color: fallbackBackground,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: double.infinity,
        fit: fit,
        alignment: Alignment.center,
        placeholder: (context, url) =>
            SkeletonShimmer(child: SkeletonBox(height: height, radius: 0)),
        errorWidget: (context, url, error) =>
            AnimalImagePlaceholder(height: height),
      ),
    );
  }
}
