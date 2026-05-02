import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 響應式設計 helper — 針對手機直式
extension ResponsiveExtension on BuildContext {
  /// 屏幕寬度
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 屏幕高度
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 是否小屏幕（< 375dp，例如 iPhone SE）
  bool get isSmallPhone => screenWidth < 375;

  /// 是否標準屏幕（375dp - 430dp）
  bool get isNormalPhone => screenWidth >= 375 && screenWidth < 430;

  /// 是否大屏幕（>= 430dp，例如 iPhone 15 Plus）
  bool get isLargePhone => screenWidth >= 430;

  /// 響應式 padding（根據屏幕寬度調整）
  EdgeInsets get responsivePadding {
    if (isSmallPhone) {
      return const EdgeInsets.symmetric(horizontal: 16);
    } else if (isLargePhone) {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  /// 響應式水平 padding 值
  double get responsivePaddingHorizontal {
    if (isSmallPhone) return 16;
    if (isLargePhone) return 24;
    return 20;
  }

  /// 響應式圓角（大屏幕稍大）
  BorderRadius responsiveRadius(double baseRadius) {
    final multiplier = isLargePhone ? 1.15 : 1.0;
    return BorderRadius.circular(baseRadius * multiplier);
  }

  /// 響應式字體大小
  double responsiveFontSize(double baseSize) {
    return baseSize.sp;
  }
}

/// 數值縮放語法糖：
/// 20.t  -> 以模板寬度為基準縮放（常用）
/// 20.th -> 以模板高度為基準縮放
/// 14.tsp -> 字體縮放
/// 18.tr -> 圓角縮放
extension ScreenUtilNumX on num {
  double get t => w;

  double get th => h;

  double get tsp => sp;

  double get tr => r;
}
