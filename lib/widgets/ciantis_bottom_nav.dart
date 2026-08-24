import 'package:flutter/material.dart';

/// Universal CIANTIS bottom navigation.
///
/// Reference: "Option 1 — Minimal" — a borderless floating pill that sits
/// a small margin above the safe area. On light/ivory/taupe surfaces it
/// renders as a warm ivory pill with thin outline icons in muted
/// brown/bronze, exactly as shown in the reference. On a photographic
/// surface it keeps the same pill geometry but blends into the image with
/// a soft translucent glass tint so it still "dissolves" into the photo,
/// per the CIANTIS bottom-nav-surface rule.
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

  /// The color of whatever sits directly behind the nav. On a plain
  /// surface (white/ivory/taupe/greige/dark) the pill is filled with this
  /// color so it blends in. Over a photograph, pass the dark tone from
  /// the image and set [imageBackground] so the pill becomes a
  /// translucent glass tint instead of a flat fill.
  final Color surfaceColor;
  final bool imageBackground;

  bool get _isLightSurface {
    if (imageBackground) return false;
    return surfaceColor.computeLuminance() > 0.5;
  }

  @override
  Widget build(BuildContext context) {
    // Warm bronze/taupe line color used on light (ivory/cream) surfaces —
    // matches the "Option 1 — Minimal" reference exactly.
    const bronze = Color(0xFF7C6A54);
    // Muted gold used when the pill sits over the dark photographic hero,
    // preserving the locked Image-1 dashboard look.
    const gold = Color(0xFFE5C28A);

    final iconColor = _isLightSurface ? bronze : gold;
    final pillColor = imageBackground
        ? Colors.black.withValues(alpha: 0.30)
        : surfaceColor;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        offset: visible ? Offset.zero : const Offset(0, 1.4),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: visible ? 1 : 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            child: _Pill(
              color: pillColor,
              blurred: imageBackground,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _NavIcon(
                      icon: Icons.crop_square_rounded,
                      index: 0,
                      currentIndex: currentIndex,
                      color: iconColor,
                      onTap: onTap,
                    ),
                    _NavIcon(
                      icon: Icons.calendar_month_outlined,
                      index: 1,
                      currentIndex: currentIndex,
                      color: iconColor,
                      onTap: onTap,
                    ),
                    _CenterButton(
                      selected: currentIndex == 2,
                      color: iconColor,
                      pillColor: pillColor,
                      isLightSurface: _isLightSurface,
                      onTap: () => onTap(2),
                    ),
                    _NavIcon(
                      icon: Icons.article_outlined,
                      index: 3,
                      currentIndex: currentIndex,
                      color: iconColor,
                      onTap: onTap,
                    ),
                    _NavIcon(
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
        ),
      ),
    );
  }
}

/// Borderless rounded pill shell. No outline/border is drawn — depth comes
/// only from a soft shadow, so the icons read as floating on the surface.
class _Pill extends StatelessWidget {
  const _Pill({
    required this.color,
    required this.child,
    required this.blurred,
  });

  final Color color;
  final Widget child;
  final bool blurred;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
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
        width: 40,
        alignment: Alignment.center,
        transform: Matrix4.translationValues(0, selected ? -5 : 0, 0),
        transformAlignment: Alignment.center,
        child: Icon(
          icon,
          size: selected ? 24 : 22,
          color: color.withValues(alpha: selected ? 1 : 0.62),
        ),
      ),
    );
  }
}

/// Center grid/menu button — a thin outline circle (no solid fill change,
/// no heavy ring) with the dot-grid icon, subtly elevated above the pill
/// as in the reference.
class _CenterButton extends StatelessWidget {
  const _CenterButton({
    required this.selected,
    required this.color,
    required this.pillColor,
    required this.isLightSurface,
    required this.onTap,
  });

  final bool selected;
  final Color color;
  final Color pillColor;
  final bool isLightSurface;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fill = isLightSurface
        ? Colors.white.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.10);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 54,
        height: 54,
        margin: EdgeInsets.only(bottom: selected ? 10 : 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fill,
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: _DotGrid(color: color),
      ),
    );
  }
}

class _DotGrid extends StatelessWidget {
  const _DotGrid({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        children: List.generate(
          9,
          (_) => DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
