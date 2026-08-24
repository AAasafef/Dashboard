import 'package:flutter/material.dart';

class CiantisBottomNav extends StatelessWidget {
  const CiantisBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.visible,
    required this.surfaceColor,
    this.imageBackground = false,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool visible;
  final Color surfaceColor;
  final bool imageBackground;

  @override
  Widget build(BuildContext context) {
    final isDark =
        ThemeData.estimateBrightnessForColor(surfaceColor) == Brightness.dark;
    final iconColor = isDark
        ? const Color(0xFFF0D4A5)
        : const Color(0xFF746C60);

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        offset: visible ? Offset.zero : const Offset(0, 1.35),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: visible ? 1 : 0,
          child: Container(
            height: 62,
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            decoration: BoxDecoration(
              color: imageBackground ? null : surfaceColor.withValues(alpha: 0.96),
              gradient: imageBackground
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        surfaceColor.withValues(alpha: 0.42),
                        surfaceColor.withValues(alpha: 0.86),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                  color: Colors.black.withValues(alpha: 0.045),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.crop_square_rounded,
                  index: 0,
                  currentIndex: currentIndex,
                  color: iconColor,
                  onTap: onTap,
                ),
                _NavItem(
                  icon: Icons.calendar_month_outlined,
                  index: 1,
                  currentIndex: currentIndex,
                  color: iconColor,
                  onTap: onTap,
                ),
                _CenterGridButton(
                  color: iconColor,
                  surfaceColor: surfaceColor,
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: Icons.article_outlined,
                  index: 3,
                  currentIndex: currentIndex,
                  color: iconColor,
                  onTap: onTap,
                ),
                _NavItem(
                  icon: Icons.settings_outlined,
                  index: 4,
                  currentIndex: currentIndex,
                  color: iconColor,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final int index;
  final int currentIndex;
  final Color color;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final selected = index == currentIndex;
    return IconButton(
      tooltip: '',
      splashRadius: 23,
      onPressed: () => onTap(index),
      icon: Icon(
        icon,
        size: 24,
        color: color.withValues(alpha: selected ? 1 : 0.78),
      ),
    );
  }
}

class _CenterGridButton extends StatelessWidget {
  const _CenterGridButton({
    required this.color,
    required this.surfaceColor,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final Color surfaceColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: surfaceColor.withValues(alpha: 0.97),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: selected ? 0.12 : 0.08),
            ),
          ],
        ),
        child: Icon(Icons.apps_rounded, size: 27, color: color),
      ),
    );
  }
}
