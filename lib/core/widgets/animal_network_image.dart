import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:super_adoption/core/extension/ext.dart';
import 'package:super_adoption/core/widgets/animal_image_placeholder.dart';
import 'package:super_adoption/core/widgets/skeleton_box.dart';

// 圖片網址進來
// → 透過 CachedNetworkImageProvider 解析圖片
// → 拿到 image.width / image.height
// → 算 aspectRatio = width / height
// → setState 更新畫面
// → AspectRatio 依圖片比例顯示
class AnimalNetworkImage extends StatefulWidget {
  const AnimalNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? height;
  final BoxFit fit;

  bool get _hasImageUrl => imageUrl.isNotBlank;

  @override
  State<AnimalNetworkImage> createState() => _AnimalNetworkImageState();
}

class _AnimalNetworkImageState extends State<AnimalNetworkImage> {
  static const _placeholderHeight = 220.0;

  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;
  double? _aspectRatio;

  @override
  void initState() {
    super.initState();
    _resolveImageRatio();
  }

  @override
  void didUpdateWidget(covariant AnimalNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imageUrl != widget.imageUrl) {
      _aspectRatio = null;
      _resolveImageRatio();
    }
  }

  @override
  void dispose() {
    _removeImageListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fallbackBackground = const Color(0xFFFAFAFA);

    if (!widget._hasImageUrl) {
      return AnimalImagePlaceholder(
        height: widget.height ?? _placeholderHeight,
      );
    }

    final image = ColoredBox(
      color: fallbackBackground,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        height: widget.height,
        width: double.infinity,
        fit: widget.fit,
        alignment: Alignment.center,
        placeholder: (context, url) => SkeletonShimmer(
          child: SkeletonBox(
            height: widget.height ?? _placeholderHeight,
            radius: 0,
          ),
        ),
        errorWidget: (context, url, error) => AnimalImagePlaceholder(
          height: widget.height ?? _placeholderHeight,
        ),
      ),
    );

    if (widget.height != null) return image;

    final aspectRatio = _aspectRatio;
    if (aspectRatio == null) {
      return SizedBox(
        width: double.infinity,
        height: _placeholderHeight,
        child: image,
      );
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: image,
    );
  }

  void _resolveImageRatio() {
    _removeImageListener();

    if (!widget._hasImageUrl || widget.height != null) return;

    final imageProvider = CachedNetworkImageProvider(widget.imageUrl);
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);

    _imageStreamListener = ImageStreamListener(
      (imageInfo, _) {
        final image = imageInfo.image;
        final width = image.width;
        final height = image.height;

        if (width <= 0 || height <= 0 || !mounted) return;

        setState(() {
          _aspectRatio = width / height;
        });
      },
      onError: (_, _) {
        if (!mounted) return;
        setState(() => _aspectRatio = null);
      },
    );

    _imageStream = imageStream;
    imageStream.addListener(_imageStreamListener!);
  }

  void _removeImageListener() {
    final imageStream = _imageStream;
    final imageStreamListener = _imageStreamListener;

    if (imageStream != null && imageStreamListener != null) {
      imageStream.removeListener(imageStreamListener);
    }

    _imageStream = null;
    _imageStreamListener = null;
  }
}
