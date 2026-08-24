import 'package:flutter/material.dart';
import '../widgets/ciantis_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _pageColor = Color(0xFFF5F1EB);
  static const _ink = Color(0xFF2A241D);
  static const _muted = Color(0xFF81776A);
  static const _gold = Color(0xFFD7B477);

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
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageColor,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: _handleScroll,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _HeroSection(dateText: _dateText()),
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: _FlowCard(),
                ),
                const SizedBox(height: 14),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: _AgendaCard(),
                ),
                const SizedBox(height: 120),
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
                surfaceColor: _pageColor,
                onTap: (index) => setState(() => _currentIndex = index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.dateText});

  final String dateText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF53606B),
            Color(0xFF7B6757),
            Color(0xFFD18A4E),
            Color(0xFF3C3025),
          ],
          stops: [0.0, 0.38, 0.72, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 52,
            bottom: 73,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF2C7),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD27D).withValues(alpha: 0.75),
                    blurRadius: 38,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: _MountainClipper(),
              child: Container(
                height: 96,
                color: const Color(0xFF2B251F).withValues(alpha: 0.86),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 58, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good morning,\nShaverian',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      height: 1.12,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.8,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    dateText,
                    style: const TextStyle(
                      color: Color(0xFFF6EEE3),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(width: 46, height: 1.5, color: _DashboardScreenState._gold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowCard extends StatelessWidget {
  const _FlowCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF201A15),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
              color: Color(0xFFE9D7B8),
              fontSize: 11,
              letterSpacing: 1.7,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _FlowItem(Icons.wb_sunny_outlined, 'Morning', true),
              _FlowItem(Icons.light_mode_outlined, 'Afternoon', false),
              _FlowItem(Icons.wb_twilight_outlined, 'Evening', false),
              _FlowItem(Icons.dark_mode_outlined, 'Night', false),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlowItem extends StatelessWidget {
  const _FlowItem(this.icon, this.label, this.active);

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? _DashboardScreenState._gold
        : const Color(0xFFCFC4B7);
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Icon(icon, size: 29, color: color),
          const SizedBox(height: 9),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 9),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 1.5,
            width: active ? 42 : 0,
            color: _DashboardScreenState._gold,
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
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
                    letterSpacing: 1.5,
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
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          trailingText!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _DashboardScreenState._muted,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Icon(icon, size: 28, color: _DashboardScreenState._ink),
        ],
      ),
    );
  }
}

class _SpacesRow extends StatelessWidget {
  const _SpacesRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SPACES',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
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
            width: 76,
            height: 34,
            child: Stack(
              children: const [
                _SpaceAvatar(left: 0, initials: 'H'),
                _SpaceAvatar(left: 22, initials: 'S'),
                _SpaceAvatar(left: 44, initials: 'B'),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 29),
        ],
      ),
    );
  }
}

class _SpaceAvatar extends StatelessWidget {
  const _SpaceAvatar({required this.left, required this.initials});

  final double left;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF5D5146),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 5,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
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
      child: Container(height: 1, color: const Color(0xFFE3DDD5)),
    );
  }
}

class _MountainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(0, size.height * 0.62);
    path.lineTo(size.width * 0.18, size.height * 0.52);
    path.lineTo(size.width * 0.35, size.height * 0.67);
    path.lineTo(size.width * 0.58, size.height * 0.38);
    path.lineTo(size.width * 0.77, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.43);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
