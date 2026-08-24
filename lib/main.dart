import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

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
