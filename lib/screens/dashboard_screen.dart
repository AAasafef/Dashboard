import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/ciantis_bottom_nav.dart';
import 'activities_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _gold = Color(0xFFE3BF80);
  static const _cream = Color(0xFFF2ECE5);
  static const _ink = Color(0xFF1D1814);

  int _currentIndex = 0;
  int _flowIndex = 0;
  bool _navVisible = true;
  bool _searchOpen = false;
  bool _activityOpen = false;
  bool _notificationsOpen = false;
  double _lastOffset = 0;
  final _searchController = TextEditingController();

  static const _photo =
      'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=1200&q=90';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification n) {
    if (n is ScrollUpdateNotification) {
      final y = n.metrics.pixels;
      if (y > _lastOffset + 4 && _navVisible) {
        setState(() => _navVisible = false);
      } else if (y < _lastOffset - 4 && !_navVisible) {
        setState(() => _navVisible = true);
      }
      if (y <= 2 && !_navVisible) setState(() => _navVisible = true);
      _lastOffset = y;
    }
    return false;
  }

  String _dateText() {
    final n = DateTime.now();
    const w = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const m = [
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
    return '${w[n.weekday - 1]}, ${m[n.month - 1]} ${n.day}';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final desktop = c.maxWidth > 700;
        final phoneWidth = desktop ? 390.0 : c.maxWidth;
        final phoneHeight =
            desktop ? (c.maxHeight - 24).clamp(720.0, 844.0) : c.maxHeight;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F0EB),
          body: Center(
            child: SizedBox(
              width: phoneWidth,
              height: phoneHeight,
              child: ClipRect(
                child: GestureDetector(
                  onHorizontalDragEnd: (d) {
                    if ((d.primaryVelocity ?? 0) < -250 &&
                        !_searchOpen &&
                        !_notificationsOpen) {
                      setState(() => _activityOpen = true);
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        _photo,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) => const ColoredBox(
                          color: Color(0xFF544A42),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x55000000),
                              Color(0x00000000),
                              Color(0x22000000),
                              Color(0xB8000000),
                            ],
                            stops: [0, .28, .62, 1],
                          ),
                        ),
                      ),
                      NotificationListener<ScrollNotification>(
                        onNotification: _handleScroll,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            _topArea(),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: _flowCard(),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: _agendaCard(),
                            ),
                            const SizedBox(height: 118),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          minimum: EdgeInsets.zero,
                          child: CiantisBottomNav(
                            currentIndex: _currentIndex,
                            visible: _navVisible,
                            surfaceColor: const Color(0xFF171512),
                            imageBackground: true,
                            onTap: (i) => setState(() => _currentIndex = i),
                          ),
                        ),
                      ),
                      // NOTE: CiantisBottomNav is a universal, reusable
                      // component. Any future light-surface screen (e.g.
                      // Calendar, Notes, Settings) should pass
                      // imageBackground: false and that screen's surface
                      // color — the nav will automatically render as the
                      // ivory "Option 1 — Minimal" pill with warm bronze
                      // outline icons, matching the reference exactly.
                      if (_searchOpen) _searchOverlay(),
                      if (_activityOpen) _activitiesPanel(),
                      if (_notificationsOpen) _notificationsPanel(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topArea() {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 425,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _glassIcon(
                    Icons.search_rounded,
                    () => setState(() => _searchOpen = true),
                  ),
                  _glassIcon(
                    Icons.notifications_none_rounded,
                    () => setState(() => _notificationsOpen = true),
                  ),
                ],
              ),
              const SizedBox(height: 74),
              const Text(
                'Good morning,\nShaverian',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  height: 1.12,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'serif',
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _dateText(),
                style: const TextStyle(
                  color: Color(0xFFF3EAE0),
                  fontSize: 16,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 27),
              Container(width: 44, height: 1.5, color: _gold),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            color: Colors.black.withValues(alpha: .12),
            child: Icon(
              icon,
              color: const Color(0xFFF6EBDD),
              size: 21,
            ),
          ),
        ),
      ),
    );
  }

  Widget _flowCard() {
    const items = [
      (Icons.wb_sunny_outlined, 'Morning'),
      (Icons.light_mode_outlined, 'Afternoon'),
      (Icons.wb_twilight_outlined, 'Evening'),
      (Icons.dark_mode_outlined, 'Night'),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: 172,
          padding: const EdgeInsets.fromLTRB(20, 19, 16, 10),
          color: const Color(0xFF17130F).withValues(alpha: .88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "TODAY'S FLOW",
                style: TextStyle(
                  color: Color(0xFFEBD8BA),
                  fontSize: 11,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: List.generate(items.length, (i) {
                    final active = _flowIndex == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _flowIndex = i),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          transform: Matrix4.translationValues(
                            0,
                            active ? 7 : 0,
                            0,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                items[i].$1,
                                color: active
                                    ? _gold
                                    : const Color(0xFFC9BFB4),
                                size: active ? 31 : 27,
                              ),
                              SizedBox(height: active ? 10 : 8),
                              Text(
                                items[i].$2,
                                style: TextStyle(
                                  color: active
                                      ? _gold
                                      : const Color(0xFFC9BFB4),
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: active ? 2 : 0,
                                width: active ? 42 : 0,
                                color: _gold,
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
        ),
      ),
    );
  }

  Widget _agendaCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cream.withValues(alpha: .97),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: const Column(
        children: [
          _AgendaRow(
            'NEXT APPOINTMENT',
            '10:00 AM   |   Strategy Call',
            Icons.calendar_today_outlined,
          ),
          _ThinDivider(),
          _AgendaRow(
            'SCHOOL ASSIGNMENT',
            'Brand Positioning Draft',
            Icons.menu_book_outlined,
            trailing: 'Due Aug 24',
          ),
          _ThinDivider(),
          _SpacesRow(),
        ],
      ),
    );
  }

  Widget _searchOverlay() {
    final q = _searchController.text.trim().toLowerCase();
    final all = [
      'Strategy Call',
      'Science Quiz',
      'Brand Positioning Draft',
      'CIANTIS Hub',
      'Science Notes',
      'Science Project',
    ];
    final shown = q.isEmpty
        ? all.take(4).toList()
        : all.where((e) => e.toLowerCase().contains(q)).toList();

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          color: Colors.black.withValues(alpha: .42),
          padding: const EdgeInsets.fromLTRB(18, 54, 18, 90),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search CIANTIS...',
                        hintStyle:
                            const TextStyle(color: Colors.white60),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        suffixIcon: q.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: .12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchOpen = false);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  q.isEmpty ? 'RECENT' : 'TOP RESULTS',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...shown.map(
                (e) => Container(
                  margin: const EdgeInsets.only(bottom: 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .22),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        color: _gold,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activitiesPanel() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * .88,
            height: double.infinity,
            child: ActivitiesScreen(
              onClose: () => setState(() => _activityOpen = false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notificationsPanel() => _sidePanel(
        title: 'Notifications',
        onClose: () => setState(() => _notificationsOpen = false),
        child: const Column(
          children: [
            _Notice('CIANTIS Hub', '2 new updates', '2m ago'),
            _Notice('Strategy Call', 'Meeting starts in 15 min', '15m ago'),
            _Notice('Science Quiz', 'Due tomorrow', '1h ago'),
            _Notice(
              'Study Session',
              "Don't forget your study session",
              '2h ago',
            ),
          ],
        ),
      );

  Widget _sidePanel({
    required String title,
    required VoidCallback onClose,
    required Widget child,
  }) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.sizeOf(context).width * .88,
            height: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2C2B2D).withValues(alpha: .96),
                  const Color(0xFF151515).withValues(alpha: .98),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .35),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(child: child),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AgendaRow extends StatelessWidget {
  const _AgendaRow(this.eyebrow, this.title, this.icon, {this.trailing});

  final String eyebrow;
  final String title;
  final IconData icon;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  color: Color(0xFF6F665D),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        color: _DashboardScreenState._ink,
                      ),
                    ),
                  ),
                  if (trailing != null)
                    Text(
                      trailing!,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 12,
                        color: Color(0xFF6F665D),
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
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Divider(height: 1, color: Color(0xFFD9D1C8)),
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
                  letterSpacing: 1.5,
                  color: Color(0xFF6F665D),
                ),
              ),
              SizedBox(height: 9),
              Text(
                '3 updates',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 17,
                  color: _DashboardScreenState._ink,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 84,
          height: 34,
          child: Stack(
            children: const [
              _Avatar(0, Color(0xFF8E684C)),
              _Avatar(23, Color(0xFF6E4E39)),
              _Avatar(46, Color(0xFF4D382C)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, size: 29),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.left, this.color);

  final double left;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: _DashboardScreenState._cream,
            width: 1.4,
          ),
        ),
        child: const Icon(
          Icons.person_rounded,
          size: 19,
          color: Color(0xFFEBD9C8),
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.title, this.subtitle, this.time);

  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0x22FFFFFF)),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: _DashboardScreenState._gold,
            size: 19,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Color(0x73FFFFFF),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
