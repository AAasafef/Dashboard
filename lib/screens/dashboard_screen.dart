import 'package:flutter/material.dart';
import '../widgets/ciantis_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _ink = Color(0xFF18130F);
  static const _muted = Color(0xFF6F665D);
  static const _gold = Color(0xFFE0B971);
  static const _navSurface = Color(0xFF151310);

  int _currentIndex = 0;
  bool _navVisible = true;
  double _lastOffset = 0;

  bool _handleScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final offset = notification.metrics.pixels;
      if (offset <= 4 && !_navVisible) {
        setState(() => _navVisible = true);
      } else if (offset > _lastOffset + 3 && _navVisible) {
        setState(() => _navVisible = false);
      } else if (offset < _lastOffset - 3 && !_navVisible) {
        setState(() => _navVisible = true);
      }
      _lastOffset = offset;
    }
    return false;
  }

  String _dateText() {
    final now = DateTime.now();
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final appWidth = width > 430 ? 430.0 : width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3EFEA),
      body: Center(
        child: SizedBox(
          width: appWidth,
          child: Stack(
            children: [
              Positioned.fill(child: _SunsetBackdrop()),
              NotificationListener<ScrollNotification>(
                onNotification: _handleScroll,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    _HeroText(dateText: _dateText()),
                    const SizedBox(height: 102),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: _FlowCard(),
                    ),
                    const SizedBox(height: 14),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: _AgendaCard(),
                    ),
                    const SizedBox(height: 135),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: CiantisBottomNav(
                    currentIndex: _currentIndex,
                    visible: _navVisible,
                    surfaceColor: _navSurface,
                    imageBackground: true,
                    onTap: (index) => setState(() => _currentIndex = index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SunsetBackdrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF44515D),
            Color(0xFF665E58),
            Color(0xFFB46F3C),
            Color(0xFF6B412A),
            Color(0xFF231D18),
          ],
          stops: [0.0, 0.23, 0.43, 0.61, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 70,
            top: 335,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF4C6),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD27B).withValues(alpha: 0.85),
                    blurRadius: 34,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 355,
            child: CustomPaint(
              size: const Size(double.infinity, 180),
              painter: _LandscapePainter(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 432,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF5B402E).withValues(alpha: 0.25),
                    const Color(0xFF151412).withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.dateText});
  final String dateText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 74, 24, 0),
        child: SizedBox(
          height: 356,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good morning,\nShaverian',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  height: 1.13,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.7,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 19),
              Text(
                dateText,
                style: const TextStyle(
                  color: Color(0xFFF2EAE1),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 29),
              Container(width: 42, height: 1.4, color: _DashboardScreenState._gold),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowCard extends StatefulWidget {
  const _FlowCard();

  @override
  State<_FlowCard> createState() => _FlowCardState();
}

class _FlowCardState extends State<_FlowCard> {
  int selected = 0;

  static const items = [
    (Icons.wb_sunny_outlined, 'Morning'),
    (Icons.light_mode_outlined, 'Afternoon'),
    (Icons.wb_twilight_outlined, 'Evening'),
    (Icons.dark_mode_outlined, 'Night'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      padding: const EdgeInsets.fromLTRB(20, 20, 18, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF17130F).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TODAY'S FLOW",
            style: TextStyle(
              color: Color(0xFFEAD7B5),
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final active = selected == index;
                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => setState(() => selected = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: EdgeInsets.only(top: active ? 4 : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            height: active ? 34 : 30,
                            alignment: Alignment.center,
                            child: Icon(
                              item.$1,
                              size: active ? 30 : 27,
                              color: active
                                  ? _DashboardScreenState._gold
                                  : const Color(0xFFC9BFB4),
                            ),
                          ),
                          SizedBox(height: active ? 11 : 9),
                          Text(
                            item.$2,
                            style: TextStyle(
                              color: active
                                  ? _DashboardScreenState._gold
                                  : const Color(0xFFC9BFB4),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            height: active ? 2 : 0,
                            width: active ? 44 : 0,
                            margin: const EdgeInsets.only(bottom: 1),
                            color: _DashboardScreenState._gold,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 17),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EDE7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          _AgendaRow(
            eyebrow: 'NEXT APPOINTMENT',
            title: '10:00 AM   |   Strategy Call',
            icon: Icons.calendar_today_outlined,
          ),
          _Divider(),
          _AgendaRow(
            eyebrow: 'SCHOOL ASSIGNMENT',
            title: 'Brand Positioning Draft',
            trailingText: 'Due Aug 24',
            icon: Icons.menu_book_outlined,
          ),
          _Divider(),
          _SpacesRow(),
        ],
      ),
    );
  }
}

class _AgendaRow extends StatelessWidget {
  const _AgendaRow({
    required this.eyebrow,
    required this.title,
    required this.icon,
    this.trailingText,
  });

  final String eyebrow;
  final String title;
  final IconData icon;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.45,
                  color: _DashboardScreenState._muted,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        color: _DashboardScreenState._ink,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                  if (trailingText != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        trailingText!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _DashboardScreenState._muted,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Icon(icon, size: 29, color: _DashboardScreenState._ink),
      ],
    );
  }
}

class _SpacesRow extends StatelessWidget {
  const _SpacesRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SPACES',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.45,
                  color: _DashboardScreenState._muted,
                ),
              ),
              SizedBox(height: 9),
              Text(
                '3 updates',
                style: TextStyle(
                  fontSize: 17,
                  color: _DashboardScreenState._ink,
                  fontFamily: 'serif',
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          height: 34,
          child: Stack(
            children: const [
              _SpaceAvatar(left: 0, tone: Color(0xFF8E684C)),
              _SpaceAvatar(left: 22, tone: Color(0xFF6F4F39)),
              _SpaceAvatar(left: 44, tone: Color(0xFF4F392C)),
            ],
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right_rounded, size: 29, color: _DashboardScreenState._ink),
      ],
    );
  }
}

class _SpaceAvatar extends StatelessWidget {
  const _SpaceAvatar({required this.left, required this.tone});
  final double left;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tone,
          border: Border.all(color: const Color(0xFFF2EDE7), width: 1.4),
        ),
        child: const Icon(Icons.person_rounded, size: 20, color: Color(0xFFEAD9C8)),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(height: 1, color: const Color(0xFFD9D1C8)),
    );
  }
}

class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final water = Paint()..color = const Color(0xFF4B4036).withValues(alpha: 0.55);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.47, size.width, size.height * 0.53), water);

    final mountain = Paint()..color = const Color(0xFF251F1B);
    final path = Path()
      ..moveTo(0, size.height * 0.48)
      ..lineTo(size.width * 0.17, size.height * 0.44)
      ..lineTo(size.width * 0.31, size.height * 0.56)
      ..lineTo(size.width * 0.50, size.height * 0.34)
      ..lineTo(size.width * 0.66, size.height * 0.27)
      ..lineTo(size.width * 0.83, size.height * 0.36)
      ..lineTo(size.width, size.height * 0.30)
      ..lineTo(size.width, size.height * 0.62)
      ..lineTo(0, size.height * 0.62)
      ..close();
    canvas.drawPath(path, mountain);

    final reflection = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFD27A).withValues(alpha: 0.8),
          const Color(0xFFFFD27A).withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(size.width * 0.64, size.height * 0.48, 28, size.height * 0.48));
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.70, size.height * 0.71),
        width: 28,
        height: size.height * 0.42,
      ),
      reflection,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
