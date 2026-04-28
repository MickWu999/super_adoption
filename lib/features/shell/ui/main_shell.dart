import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom Navigation 外殼。
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const double _navHeight = 74;
  static const double _borderWidth = 0.25;
  static const double _itemRadius = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderColor = colorScheme.outlineVariant.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.32 : 0.55,
    );
    final shadowColor = theme.shadowColor.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.18 : 0.06,
    );
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _PetCenterButton(
        selected: navigationShell.currentIndex == 1,
        onTap: () => _go(1),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: borderColor, width: _borderWidth),
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: _navHeight,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: '首頁',
                  selected: navigationShell.currentIndex == 0,
                  onTap: () => _go(0),
                ),
                _NavItem(
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map_rounded,
                  label: '地圖',
                  selected: navigationShell.currentIndex == 2,
                  onTap: () => _go(2),
                ),
                const SizedBox(width: 76),
                _NavItem(
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: '收藏',
                  selected: navigationShell.currentIndex == 3,
                  onTap: () => _go(3),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: '我的',
                  selected: navigationShell.currentIndex == 4,
                  onTap: () => _go(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _PetCenterButton extends StatelessWidget {
  const _PetCenterButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final shadowColor = theme.shadowColor.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.26 : 0.16,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(top: 18),
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: AnimatedScale(
          scale: selected ? 1.08 : 1,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.pets_rounded, color: Colors.white, size: 26)],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final selectedBackground = primaryColor.withValues(alpha: 0.10);
    final inactiveColor =
        theme.textTheme.bodySmall?.color ?? theme.disabledColor;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MainShell._itemRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? selectedBackground : Colors.transparent,
            borderRadius: BorderRadius.circular(MainShell._itemRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.08 : 1,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: Icon(
                  selected ? activeIcon : icon,
                  size: _iconSize,
                  color: selected ? primaryColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? primaryColor : inactiveColor,
                  height: 1,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
