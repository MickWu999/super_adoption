/// UI 版面常數 — 統一所有 padding、radius、height、gap 等
class UIDimensions {
  UIDimensions._();

  // ============= Padding =============
  
  /// 標準頁面邊距
  static const double pagePadding = 20.0;
  
  /// 卡片內邊距
  static const double cardPaddingH = 16.0;
  static const double cardPaddingV = 14.0;
  
  /// 過濾 header padding
  static const double filterHeaderPaddingTop = 12.0;
  static const double filterHeaderPaddingBottom = 14.0;
  
  /// 列表底部安全距離（容納 FAB 等）
  static const double listBottomPadding = 120.0;
  
  /// 列表項間距
  static const double listItemSpacing = 18.0;
  
  // ============= Radius =============
  
  /// 卡片圓角
  static const double cardRadius = 22.0;
  
  /// 按鈕圓角
  static const double buttonRadius = 999.0;
  
  /// 圖片圓角
  static const double imageRadius = 18.0;
  
  /// 篩選 Sheet 圓角
  static const double sheetRadius = 28.0;
  
  // ============= Height =============
  
  /// 列表圖片高度
  static const double cardImageHeight = 240.0;
  
  /// 詳情頁頂部圖片高度
  static const double detailImageHeight = 360.0;
  
  /// 按鈕最小高度
  static const double buttonMinHeight = 32.0;
  
  /// Chip 高度
  static const double chipHeight = 10.0;
  
  // ============= Icon Size =============
  
  /// 大 icon
  static const double iconSizeLarge = 24.0;
  
  /// 標準 icon
  static const double iconSizeMedium = 20.0;
  
  /// 小 icon
  static const double iconSizeSmall = 18.0;
  
  /// 超小 icon
  static const double iconSizeXSmall = 15.0;
  
  /// 微小 icon（特殊用途）
  static const double iconSizeMini = 14.0;
  
  // ============= Shadow =============
  
  /// 標準陰影
  static const double shadowBlur = 12.0;
  static const double shadowOffsetY = 6.0;
  
  /// 卡片陰影
  static const double cardShadowBlur = 18.0;
  static const double cardShadowOffsetY = 8.0;
  
  // ============= Gap (Spacing) =============
  
  /// 超小間隔
  static const double gapXSmall = 4.0;
  
  /// 小間隔
  static const double gapSmall = 8.0;
  
  /// 標準間隔
  static const double gapMedium = 12.0;
  
  /// 大間隔
  static const double gapLarge = 16.0;
  
  /// 超大間隔
  static const double gapXLarge = 20.0;
  
  // ============= 動畫時長 =============
  
  /// 快速動畫（150ms）
  static const Duration animationFast = Duration(milliseconds: 150);
  
  /// 標準動畫（200ms）
  static const Duration animationNormal = Duration(milliseconds: 200);
  
  /// 緩慢動畫（300ms）
  static const Duration animationSlow = Duration(milliseconds: 300);
}
