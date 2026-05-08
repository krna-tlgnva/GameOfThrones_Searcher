import 'package:flutter/material.dart';

import '../models/character.dart';
import '../widgets/app_background.dart';

class CharacterDetailsScreen extends StatelessWidget {
  const CharacterDetailsScreen({super.key, required this.character});

  final Character character;

  static const Color _deepPurple = Color(0xFF2B124C);
  static const Color _ravenBlue = Color(0xFF245E9F);
  static const Color _cardSurface = Color(0xFFFFFBFF);
  static const Color _violetBorder = Color(0xFFD7C2FF);
  static const Color _iceText = Color(0xFFEAF2FF);

  bool get _hasImage => character.imageUrl?.isNotEmpty ?? false;

  String get _initial => character.name.isNotEmpty ? character.name[0] : '?';

  List<MapEntry<String, String>> get _details => [
        MapEntry('House / Family', character.type),
        MapEntry('Title / Role', character.ability),
        if (character.id != null)
          MapEntry('Local Record ID', character.id.toString()),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppBackground.paleLilac,
      appBar: AppBar(title: const Text('Character Details')),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _deepPurple,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _ravenBlue, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: _deepPurple.withValues(alpha: 0.18),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 58,
                      backgroundColor: _ravenBlue.withValues(alpha: 0.34),
                      backgroundImage:
                          _hasImage ? NetworkImage(character.imageUrl!) : null,
                      child: _hasImage
                          ? null
                          : Text(
                              _initial,
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: _iceText,
                              ),
                            ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      character.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _iceText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A character profile from the realm archive.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        color: _iceText.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ..._details.expand(
                (detail) => [
                  _DetailSection(title: detail.key, value: detail.value),
                  const SizedBox(height: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CharacterDetailsScreen._cardSurface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: CharacterDetailsScreen._violetBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CharacterDetailsScreen._deepPurple.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: CharacterDetailsScreen._ravenBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: CharacterDetailsScreen._deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
