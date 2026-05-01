import 'package:flutter/material.dart';

// Theme Guide
// UI 只能從 Theme.of(context) 取樣式。
// UI 不直接使用 AppColors。
// UI 不直接寫色碼，例如 Color(0xFF...)。
// 顏色優先使用 colorScheme。
// surface：主要背景 / 卡片背景。
// surfaceContainerHighest：次層背景，例如搜尋框、Chip、柔和容器。
// onSurface：主要文字 / 主要 icon。
// onSurfaceVariant：次要文字 / 輔助 icon / hint 類文字。
// primary：品牌主色，例如 CTA、選中狀態。
// onPrimary：放在 primary 上的文字 / icon。
// primaryContainer：品牌主色的淡背景，例如選中 Chip 背景。
// onPrimaryContainer：放在 primaryContainer 上的文字 / icon。
// secondary：輔助強調色，例如收藏。
// onSecondary：放在 secondary 上的文字 / icon。
// tertiary：第三輔助色，例如插圖或特殊裝飾。
// error：錯誤 / 危險狀態。
// onError：放在 error 上的文字 / icon。
// outlineVariant：邊框 / 分隔線。
// 文字樣式優先使用 textTheme。
// 按鈕、輸入框、卡片樣式優先沿用 ThemeData 裡已定義的 theme。
// 只有版面常數可以留在頁面內，例如局部圓角、單一區塊高度、padding。
// 如果同一個數值在 3 個以上地方重複出現，才考慮抽進 theme。
// AppColors 只存在於 app_theme.dart (line 1)，不外流到 feature UI。
// 新增視覺需求時，先問自己能不能塞進 ColorScheme / TextTheme，不夠再擴充 theme。
class AppColors {
  static const primary = Color(0xFFFF8A00);
  static const primaryDark = Color(0xFFE67600);
  static const primaryLight = Color(0xFFFFF3E5);
  static const background = Colors.white;
  static const surface = Color(0xFFF8F8F8);

  static const textPrimary = Color(0xFF3A342F);
  static const textSecondary = Color(0xFF6B6258);
  static const textMute = Color(0xFF8A8075);
  static const textHint = Color(0xFFA79D92);

  static const border = Color(0xFFEFE7DD);
  static const favorite = Color(0xFFFF5A5F);
  static const illustrationTint = Color(0xFF8D7A67);
  static const danger = Color(0xFFE53935);

  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkSurfaceSoft = Color(0xFF2A2A2A);
  static const darkTextPrimary = Color(0xFFFFF8F1);
  static const darkTextSecondary = Color(0xFFE4D8CA);
  static const darkTextMute = Color(0xFFC2B5A6);
  static const darkTextHint = Color(0xFF9D8F80);
  static const darkBorder = Color(0xFF3A332D);
  static const darkIllustrationTint = Color(0xFFD3B898);
}

class AppTheme {
  // 排版定義集中在此，顏色交由 colorScheme 決定，dark/light 共用。
  static const _textTheme = TextTheme(
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, height: 1.25),
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, height: 1.3),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  );

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'NotoSansTC',
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.favorite,
        onSecondary: Colors.white,
        tertiary: AppColors.darkIllustrationTint,
        onTertiary: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkSurfaceSoft,
        onSurfaceVariant: AppColors.darkTextSecondary,
        outline: AppColors.darkTextHint,
        outlineVariant: AppColors.darkBorder,
        error: AppColors.danger,
        onError: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 0.6,
        space: 1,
      ),
      shadowColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: _textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(color: AppColors.darkBorder),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: AppColors.darkTextHint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'NotoSansTC',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.favorite,
        onSecondary: Colors.white,
        tertiary: AppColors.illustrationTint,
        onTertiary: AppColors.background,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.primaryLight,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.textHint,
        outlineVariant: AppColors.border,
        error: AppColors.danger,
        onError: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 0.6,
        space: 1,
      ),
      shadowColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: _textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: AppColors.textHint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}
