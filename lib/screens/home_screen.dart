import 'package:flutter/material.dart';

import '../models/character.dart';
import '../repositories/character_repository.dart';
import 'character_details_screen.dart';
import '../widgets/character_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.repository});

  final CharacterRepository repository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: repository.fetchApiCharacters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load Game of Thrones characters.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final characters = snapshot.data ?? [];
        if (characters.isEmpty) {
          return const Center(
            child: Text('No Game of Thrones characters found.'),
          );
        }

        return RefreshIndicator(
          onRefresh: repository.fetchApiCharacters,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 12),
              ...characters.map(
                (character) => CharacterCard(
                  character: character,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            CharacterDetailsScreen(character: character),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
