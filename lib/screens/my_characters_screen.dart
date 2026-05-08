import 'package:flutter/material.dart';

import '../models/character.dart';
import '../repositories/character_repository.dart';
import 'character_details_screen.dart';
import '../widgets/character_card.dart';

class MyCharactersScreen extends StatefulWidget {
  const MyCharactersScreen({super.key, required this.repository});

  final CharacterRepository repository;

  @override
  State<MyCharactersScreen> createState() => _MyCharactersScreenState();
}

class _MyCharactersScreenState extends State<MyCharactersScreen> {
  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  void _loadCharacters() {
    _charactersFuture = widget.repository.fetchLocalCharacters();
  }

  Future<void> _deleteCharacter(Character character) async {
    final id = character.id;
    if (id == null) {
      return;
    }

    await widget.repository.deleteLocalCharacter(id);
    setState(_loadCharacters);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: _charactersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load local characters.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final characters = snapshot.data ?? [];
        if (characters.isEmpty) {
          return const Center(
            child: Text(
              'No saved characters',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(_loadCharacters);
            await _charactersFuture;
          },
          child: ListView.builder(
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
                trailing: TextButton(
                  onPressed: () => _deleteCharacter(character),
                  child: const Text('Delete'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
