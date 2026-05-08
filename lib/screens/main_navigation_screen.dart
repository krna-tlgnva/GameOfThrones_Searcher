import 'package:flutter/material.dart';

import '../repositories/character_repository.dart';
import '../widgets/app_scaffold.dart';
import 'archive_characters_screen.dart';
import 'create_character_screen.dart';
import 'home_screen.dart';
import 'my_characters_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.repository,
    this.onShowIntro,
  });

  final CharacterRepository repository;
  final VoidCallback? onShowIntro;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      _NavigationConfig(
        title: 'Realm Characters',
        body: HomeScreen(repository: widget.repository),
      ),
      _NavigationConfig(
        title: 'My Characters',
        body: MyCharactersScreen(repository: widget.repository),
      ),
      _NavigationConfig(
        title: 'Local Archive',
        body: ArchiveCharactersScreen(repository: widget.repository),
      ),
    ];

    final currentScreen = screens[_currentIndex];

    return AppScaffold(
      title: currentScreen.title,
      body: currentScreen.body,
      actions: _currentIndex == 0 && widget.onShowIntro != null
          ? [
              TextButton(
                onPressed: widget.onShowIntro,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('Intro'),
              ),
            ]
          : null,
      currentIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  CreateCharacterScreen(repository: widget.repository),
            ),
          );

          if (mounted) {
            setState(() {});
          }
        },
        label: const Text('Create Character'),
      ),
    );
  }
}

class _NavigationConfig {
  const _NavigationConfig({required this.title, required this.body});

  final String title;
  final Widget body;
}
