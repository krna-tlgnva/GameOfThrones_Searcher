import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';

class ApiService {
  static final Uri _charactersUri = Uri.parse(
    'https://thronesapi.com/api/v2/Characters',
  );

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(_charactersUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch API characters.');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded.map((item) {
      final json = item as Map<String, dynamic>;
      final family = (json['family'] ?? '').toString().trim();
      final title = (json['title'] ?? '').toString().trim();
      final firstName = (json['firstName'] ?? '').toString().trim();
      final lastName = (json['lastName'] ?? '').toString().trim();
      final fullName = (json['fullName'] ?? '').toString().trim();

      final name = [
        fullName,
        [firstName, lastName].where((value) => value.isNotEmpty).join(' '),
      ].firstWhere(
        (value) => value.isNotEmpty,
        orElse: () => 'Unknown Character',
      );

      return Character(
        name: name,
        type: family.isNotEmpty ? family : 'The Realm',
        ability: title.isNotEmpty ? title : 'Noble',
        imageUrl: (json['imageUrl'] ?? '').toString().trim(),
      );
    }).toList();
  }
}
