import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_app/utils/character_validator.dart';

void main() {
  group('CharacterValidator', () {
    test('rejects empty and too short names', () {
      expect(
        CharacterValidator.validateName('   '),
        'Please enter a name.',
      );
      expect(
        CharacterValidator.validateName('A'),
        'Name must contain at least 2 characters.',
      );
    });

    test('accepts valid names and titles', () {
      expect(CharacterValidator.validateName('Arya Stark'), isNull);
      expect(CharacterValidator.validateTitleOrSkill('No One'), isNull);
    });

    test('normalizes extra whitespace in user input', () {
      expect(
        CharacterValidator.normalizeInput('  Jon    Snow  '),
        'Jon Snow',
      );
    });
  });
}
