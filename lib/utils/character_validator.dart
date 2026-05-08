class CharacterValidator {
  const CharacterValidator._();

  static String? validateName(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'Please enter a name.';
    }
    if (normalized.length < 2) {
      return 'Name must contain at least 2 characters.';
    }
    return null;
  }

  static String? validateTitleOrSkill(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'Please enter a title or skill.';
    }
    if (normalized.length < 3) {
      return 'Title or skill must contain at least 3 characters.';
    }
    return null;
  }

  static String normalizeInput(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
