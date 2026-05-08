import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.character,
    this.trailing,
    this.onTap,
  });

  final Character character;
  final Widget? trailing;
  final VoidCallback? onTap;
  static const Color _deepPurple = Color(0xFF2B124C);
  static const Color _violetBorder = Color(0xFFD7C2FF);
  static const Color _cardSurface = Color(0xFFFFFBFF);
  static const Color _mutedText = Color(0xFF59476F);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          color: _cardSurface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _violetBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: _deepPurple.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onTap: onTap,
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: _deepPurple.withValues(alpha: 0.12),
            backgroundImage:
                character.imageUrl != null && character.imageUrl!.isNotEmpty
                    ? NetworkImage(character.imageUrl!)
                    : null,
            child: character.imageUrl == null || character.imageUrl!.isEmpty
                ? Text(
                    character.name.isNotEmpty ? character.name[0] : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _deepPurple,
                    ),
                  )
                : null,
          ),
          title: Text(
            character.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _deepPurple,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${character.type} • ${character.ability}',
              style: const TextStyle(
                fontSize: 16,
                color: _mutedText,
              ),
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
