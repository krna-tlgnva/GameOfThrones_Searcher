import 'package:flutter/material.dart';

import '../models/character.dart';
import '../repositories/character_repository.dart';
import 'character_details_screen.dart';
import '../widgets/character_card.dart';

class ArchiveCharactersScreen extends StatelessWidget {
  const ArchiveCharactersScreen({super.key, required this.repository});

  final CharacterRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Character>>(
      stream: repository.fetchArchivedCharacters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load saved characters.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final characters = snapshot.data ?? [];
        if (characters.isEmpty) {
          return const Center(
            child: Text(
              '',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            return CharacterCard(
              character: character,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        CharacterDetailsScreen(character: character),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
