import 'package:flutter/material.dart';

/// ColorScheme extension — 統一色碼使用
extension ColorSchemeExtension on ColorScheme {
  /// 地點 icon 顏色（紅色表示位置）
  Color get locationIconColor => const Color(0xFFFF5A5F);

  /// 成功狀態色
  Color get success => const Color(0xFF4CAF50);

  /// 警告狀態色
  Color get warning => const Color(0xFFFFC107);

  /// 禁用色
  Color get disabled => onSurfaceVariant.withValues(alpha: 0.38);

  /// 半透明 overlay（20%）
  Color get overlay20 => shadow.withValues(alpha: 0.20);

  /// 半透明 overlay（12%）
  Color get overlay12 => shadow.withValues(alpha: 0.12);

  /// 半透明 overlay（8%）
  Color get overlay8 => shadow.withValues(alpha: 0.08);
}
