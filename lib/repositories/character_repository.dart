import '../models/character.dart';
import '../services/api_service.dart';
import '../services/local_service.dart';

class CharacterRepository {
  const CharacterRepository({
    required this.apiService,
    required this.localCharacterService,
  });

  final ApiService apiService;
  final LocalCharacterService localCharacterService;

  Future<List<Character>> fetchApiCharacters() {
    return apiService.fetchCharacters();
  }

  Future<List<Character>> fetchLocalCharacters() {
    return localCharacterService.getCharacters();
  }

  Stream<List<Character>> fetchArchivedCharacters() {
    return Stream.fromFuture(fetchLocalCharacters());
  }

  Future<SaveCharacterResult> saveCharacter(Character character) async {
    final savedCharacter = await localCharacterService.createCharacter(
      character,
    );

    return SaveCharacterResult(character: savedCharacter);
  }

  Future<void> deleteLocalCharacter(int id) {
    return localCharacterService.deleteCharacter(id);
  }

  bool get isLocalOnly => true;
}

class SaveCharacterResult {
  const SaveCharacterResult({
    required this.character,
  });

  final Character character;
}
