import 'package:flutter/material.dart';

import 'app_background.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.currentIndex,
    this.onDestinationSelected,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final int? currentIndex;
  final ValueChanged<int>? onDestinationSelected;
  static const Color _deepPurple = Color(0xFF2B124C);
  static const Color _ravenBlue = Color(0xFF245E9F);
  static const Color _softViolet = Color(0xFFE2D2FF);
  static const Color _cardSurface = Color(0xFFFFFBFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis),
        actions: actions,
      ),
      body: AppBackground(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: currentIndex == null || onDestinationSelected == null
          ? null
          : SafeArea(
              top: false,
              child: Container(
                color: _cardSurface,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    _TextDestination(
                      label: 'Characters',
                      selected: currentIndex == 0,
                      onPressed: () => onDestinationSelected!(0),
                    ),
                    _TextDestination(
                      label: 'My Characters',
                      selected: currentIndex == 1,
                      onPressed: () => onDestinationSelected!(1),
                    ),
                    _TextDestination(
                      label: 'Archive',
                      selected: currentIndex == 2,
                      onPressed: () => onDestinationSelected!(2),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _TextDestination extends StatelessWidget {
  const _TextDestination({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor:
              selected ? AppScaffold._softViolet : Colors.transparent,
          foregroundColor:
              selected ? AppScaffold._deepPurple : AppScaffold._ravenBlue,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
