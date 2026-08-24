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
    const gold = Color(0xFFE5C28A);

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        offset: visible ? Offset.zero : const Offset(0, 1.25),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: visible ? 1 : 0,
          child: Container(
            height: 64,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              gradient: imageBackground
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        surfaceColor.withValues(alpha: 0.60),
                        surfaceColor.withValues(alpha: 0.94),
                      ],
                    )
                  : null,
              color: imageBackground ? null : surfaceColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _NavIcon(
                  icon: Icons.crop_square_rounded,
                  index: 0,
                  currentIndex: currentIndex,
                  color: gold,
                  onTap: onTap,
                ),
                _NavIcon(
                  icon: Icons.calendar_month_outlined,
                  index: 1,
                  currentIndex: currentIndex,
                  color: gold,
                  onTap: onTap,
                ),
                _CenterButton(
                  selected: currentIndex == 2,
                  color: gold,
                  surfaceColor: surfaceColor,
                  onTap: () => onTap(2),
                ),
                _NavIcon(
                  icon: Icons.article_outlined,
                  index: 3,
                  currentIndex: currentIndex,
                  color: gold,
                  onTap: onTap,
                ),
                _NavIcon(
                  icon: Icons.settings_outlined,
                  index: 4,
                  currentIndex: currentIndex,
                  color: gold,
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

class _NavIcon extends StatelessWidget {
  const _NavIcon({
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
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 48,
        height: selected ? 54 : 47,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: selected ? 27 : 25,
          color: color.withValues(alpha: selected ? 1 : 0.88),
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({
    required this.selected,
    required this.color,
    required this.surfaceColor,
    required this.onTap,
  });

  final bool selected;
  final Color color;
  final Color surfaceColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: selected ? 56 : 52,
        height: selected ? 58 : 52,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF2A251F).withValues(alpha: 0.98),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(Icons.apps_rounded, size: 29, color: color),
      ),
    );
  }
}
