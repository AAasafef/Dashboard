import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        left: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color(0xFF171513).withValues(alpha: 0.96),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
                color: const Color(0xFFF4EBDD),
                tooltip: 'Close Activities',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
