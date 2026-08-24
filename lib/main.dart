import 'package:flutter/material.dart';
import 'widgets/ciantis_bottom_nav.dart';

void main() {
  runApp(const CiantisDashboardApp());
}

class CiantisDashboardApp extends StatelessWidget {
  const CiantisDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CIANTIS Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F1EB),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color _pageColor = Color(0xFFF5F1EB);

  int _currentIndex = 0;
  bool _navVisible = true;
  double _lastOffset = 0;

  bool _handleScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final offset = notification.metrics.pixels;

      if (offset <= 4) {
        if (!_navVisible) setState(() => _navVisible = true);
      } else if (offset > _lastOffset + 3) {
        if (_navVisible) setState(() => _navVisible = false);
      } else if (offset < _lastOffset - 3) {
        if (!_navVisible) setState(() => _navVisible = true);
      }

      _lastOffset = offset;
    }
    return false;
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
              padding: const EdgeInsets.only(bottom: 100),
              children: const [
                // Intentionally empty for now. Dashboard content comes next.
                SizedBox(height: 1100),
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
                onTap: (index) {
                  setState(() => _currentIndex = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
