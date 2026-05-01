import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 全專案共用的 Skeleton shimmer 外層。
///
/// 用途：
/// - 只負責提供 shimmer 動畫效果
/// - 不負責決定頁面骨架排版
///
/// 使用方式：
/// - 在 feature 自己的 loading view 外面包一層 [SkeletonShimmer]
/// - 內部再放多個 [SkeletonBox] 或其他 skeleton widget
///
/// 範例：
/// ```dart
/// SkeletonShimmer(
///   child: Column(
///     children: const [
///       SkeletonBox(height: 120, radius: 16),
///       Gap(12),
///       SkeletonBox(width: 80, height: 14, radius: 8),
///     ],
///   ),
/// )
/// ```
///
/// 規則：
/// - `core/widgets` 只放這種 base skeleton 能力
/// - 各 feature 的骨架版型請放在自己的 `ui/widgets/...loading_view.dart`
class SkeletonShimmer extends StatelessWidget {
  const SkeletonShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 稍微提高亮面對比，讓使用者更明顯感受到載入中。
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      period: const Duration(milliseconds: 1350),
      direction: ShimmerDirection.ltr,
      enabled: true,
      child: child,
    );
  }
}

/// 全專案共用的骨架方塊。
///
/// 用途：
/// - 表示尚未載入完成的區塊、文字列、圖片區、按鈕區
/// - 專門給各 feature 的 loading view 組裝使用
///
/// 常見對應：
/// - banner / image：高度大、圓角較大
/// - title / text line：高度小、寬度較短
/// - avatar / icon placeholder：寬高相同，radius 設成一半做圓形
///
/// 範例：
/// ```dart
/// const SkeletonBox(height: 150, radius: 18); // Banner
/// const SkeletonBox(width: 96, height: 16, radius: 8); // 文字列
/// const SkeletonBox(width: 62, height: 62, radius: 31); // 圓形 icon
/// ```
///
/// 建議：
/// - `width` / `height` / `radius` 由 feature skeleton 自己決定
/// - 不要把頁面版型邏輯寫進這個 base widget
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
