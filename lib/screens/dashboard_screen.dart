import 'dart:ui';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _gold = Color(0xFFE0B96D);
  static const _ivory = Color(0xFFF2ECE5);
  static const _ink = Color(0xFF211C18);

  int _flowIndex = 0;
  int _navIndex = 0;

  static const _photo =
      'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1400&q=95';

  String _dateText() {
    final n = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[n.weekday - 1]}, ${months[n.month - 1]} ${n.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          final sx = w / 390.0;
          final sy = h / 844.0;

          double x(double v) => v * sx;
          double y(double v) => v * sy;
          double f(double v) => v * sx;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                _photo,
                fit: BoxFit.cover,
                alignment: const Alignment(0.08, 0),
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xFF3A2B22),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, .28, .58, .82, 1],
                    colors: [
                      Color(0x66000000),
                      Color(0x11000000),
                      Color(0x08000000),
                      Color(0x33000000),
                      Color(0xB0000000),
                    ],
                  ),
                ),
              ),

              // Greeting — sized and positioned to match the reference.
              Positioned(
                left: x(27),
                top: y(92),
                width: x(300),
                child: const Text(
                  'Good morning,\nShaverian',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 32,
                    height: .98,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -.6,
                    color: Color(0xFFF4EFE8),
                  ),
                ),
              ),
              Positioned(
                left: x(27),
                top: y(166),
                child: Text(
                  _dateText(),
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: f(15.5),
                    height: 1,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFFEDE3D7),
                  ),
                ),
              ),
              Positioned(
                left: x(27),
                top: y(197),
                child: Container(
                  width: x(29),
                  height: 1.4,
                  color: _gold,
                ),
              ),

              // TODAY'S FLOW.
              Positioned(
                left: x(16),
                right: x(16),
                top: y(279),
                height: y(121),
                child: ClipPath(
                  clipper: _FlowClipper(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      color: const Color(0xFF15120F).withValues(alpha: .94),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: x(30),
                top: y(294),
                child: Text(
                  "TODAY'S FLOW",
                  style: TextStyle(
                    color: const Color(0xFFE8D7BB),
                    fontSize: f(8.2),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Positioned(
                left: x(20),
                right: x(20),
                top: y(322),
                height: y(68),
                child: Row(
                  children: [
                    _flowItem(Icons.wb_sunny_outlined, 'Morning', 0, f),
                    _flowItem(Icons.light_mode_outlined, 'Afternoon', 1, f),
                    _flowItem(Icons.wb_twilight_outlined, 'Evening', 2, f),
                    _flowItem(Icons.dark_mode_outlined, 'Night', 3, f),
                  ],
                ),
              ),
              Positioned(
                left: x(33),
                top: y(394),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: x(31),
                  height: 1.4,
                  color: _flowIndex == 0 ? _gold : Colors.transparent,
                ),
              ),

              // Main ivory agenda card.
              Positioned(
                left: x(16),
                right: x(16),
                top: y(408),
                height: y(246),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(x(6)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _ivory.withValues(alpha: .975),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .25),
                          width: .5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              _label('NEXT APPOINTMENT', x(30), y(429), f),
              Positioned(
                left: x(30),
                top: y(449),
                child: Row(
                  children: [
                    Text(
                      '10:00 AM',
                      style: _serif(f(15.5), FontWeight.w400),
                    ),
                    SizedBox(width: x(12)),
                    Container(
                      width: .7,
                      height: y(14),
                      color: const Color(0xFFBEB4AA),
                    ),
                    SizedBox(width: x(12)),
                    Text(
                      'Strategy Call',
                      style: _serif(f(15.5), FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: x(30),
                top: y(438),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: x(18.5),
                  color: _ink,
                ),
              ),
              _divider(x, y(486)),

              _label('SCHOOL ASSIGNMENT', x(30), y(503), f),
              Positioned(
                left: x(30),
                top: y(524),
                child: Text(
                  'Brand Positioning Draft',
                  style: _serif(f(14.5), FontWeight.w400),
                ),
              ),
              Positioned(
                right: x(61),
                top: y(525),
                child: Text(
                  'Due Aug 24',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: f(10.8),
                    color: const Color(0xFF75675A),
                  ),
                ),
              ),
              Positioned(
                right: x(30),
                top: y(516),
                child: Icon(
                  Icons.menu_book_outlined,
                  size: x(20),
                  color: _ink,
                ),
              ),
              _divider(x, y(558)),

              _label('SPACES', x(30), y(578), f),
              Positioned(
                left: x(30),
                top: y(598),
                child: Text(
                  '3 updates',
                  style: _serif(f(15.2), FontWeight.w400),
                ),
              ),
              Positioned(
                right: x(69),
                top: y(584),
                child: SizedBox(
                  width: x(76),
                  height: x(29),
                  child: Stack(
                    children: [
                      _avatar(x, 0, const Color(0xFF855D46)),
                      _avatar(x, 19, const Color(0xFF6F4938)),
                      _avatar(x, 38, const Color(0xFF4C352B)),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: x(32),
                top: y(588),
                child: Icon(
                  Icons.chevron_right,
                  size: x(21),
                  color: _ink,
                ),
              ),

              // Bottom navigation: flush, low-profile, dark glass.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: y(79),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      color: const Color(0xFF0B0B0A).withValues(alpha: .90),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: y(9),
                height: y(55),
                child: Row(
                  children: [
                    _nav(Icons.crop_square_rounded, 0, x),
                    _nav(Icons.calendar_month_outlined, 1, x),
                    const Expanded(child: SizedBox()),
                    _nav(Icons.article_outlined, 3, x),
                    _nav(Icons.settings_outlined, 4, x),
                  ],
                ),
              ),
              Positioned(
                left: (w / 2) - x(23.5),
                bottom: y(14),
                child: GestureDetector(
                  onTap: () => setState(() => _navIndex = 2),
                  child: Container(
                    width: x(47),
                    height: x(47),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF171615),
                      border: Border.all(
                        color: _gold.withValues(alpha: .30),
                        width: .75,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .42),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: _DotGrid(
                      color: _gold.withValues(
                        alpha: _navIndex == 2 ? 1 : .84,
                      ),
                      dot: x(3.2),
                      gap: x(3.4),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _flowItem(
    IconData icon,
    String label,
    int index,
    double Function(double) f,
  ) {
    final active = _flowIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _flowIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: f(active ? 26 : 24.5),
              color: active ? _gold : const Color(0xFFD0C4B8),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: f(active ? 10.8 : 9.8),
                height: 1,
                fontWeight: FontWeight.w300,
                color: active ? _gold : const Color(0xFFD5C9BE),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _serif(double size, FontWeight weight) => TextStyle(
        fontFamily: 'serif',
        fontSize: size,
        height: 1,
        fontWeight: weight,
        color: _ink,
      );

  Widget _label(
    String text,
    double left,
    double top,
    double Function(double) f,
  ) {
    return Positioned(
      left: left,
      top: top,
      child: Text(
        text,
        style: TextStyle(
          fontSize: f(7.6),
          height: 1,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.15,
          color: const Color(0xFF685F57),
        ),
      ),
    );
  }

  Widget _divider(double Function(double) x, double top) {
    return Positioned(
      left: x(30),
      right: x(30),
      top: top,
      child: Container(
        height: .55,
        color: const Color(0xFFD2CAC1),
      ),
    );
  }

  Widget _avatar(
    double Function(double) x,
    double left,
    Color tone,
  ) {
    return Positioned(
      left: x(left),
      child: Container(
        width: x(27),
        height: x(27),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tone,
          border: Border.all(color: _ivory, width: 1.2),
        ),
        child: Icon(
          Icons.person,
          size: x(17),
          color: const Color(0xFFF4E9DD),
        ),
      ),
    );
  }

  Widget _nav(
    IconData icon,
    int index,
    double Function(double) x,
  ) {
    final active = _navIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _navIndex = index),
        child: Center(
          child: Icon(
            icon,
            size: x(active ? 20.5 : 19),
            color: _gold.withValues(alpha: active ? 1 : .72),
          ),
        ),
      ),
    );
  }
}

class _FlowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final p = Path();
    final r = s.height * .10;

    p.moveTo(r, 0);
    p.lineTo(s.width * .23, 0);
    p.cubicTo(
      s.width * .27,
      0,
      s.width * .29,
      s.height * .18,
      s.width * .37,
      s.height * .23,
    );
    p.cubicTo(
      s.width * .42,
      s.height * .26,
      s.width * .49,
      s.height * .27,
      s.width * .56,
      s.height * .27,
    );
    p.lineTo(s.width - r, s.height * .27);
    p.quadraticBezierTo(s.width, s.height * .27, s.width, s.height * .27 + r);
    p.lineTo(s.width, s.height - r);
    p.quadraticBezierTo(s.width, s.height, s.width - r, s.height);
    p.lineTo(r, s.height);
    p.quadraticBezierTo(0, s.height, 0, s.height - r);
    p.lineTo(0, r);
    p.quadraticBezierTo(0, 0, r, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DotGrid extends StatelessWidget {
  const _DotGrid({
    required this.color,
    required this.dot,
    required this.gap,
  });

  final Color color;
  final double dot;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (_) => Padding(
          padding: EdgeInsets.symmetric(vertical: gap / 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (_) => Padding(
                padding: EdgeInsets.symmetric(horizontal: gap / 2),
                child: Container(
                  width: dot,
                  height: dot,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
