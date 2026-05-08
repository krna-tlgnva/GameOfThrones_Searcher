import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  static const Color white = Color(0xFFFFFFFF);
  static const Color paleLilac = Color(0xFFF7F1FF);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: paleLilac,
      ),
      child: child,
    );
  }
}
