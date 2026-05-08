class Character {
  const Character({
    this.id,
    required this.name,
    required this.type,
    required this.ability,
    this.imageUrl,
  });

  final int? id;
  final String name;
  final String type;
  final String ability;
  final String? imageUrl;

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int?,
      name: (json['name'] ?? 'Unknown Character') as String,
      type: (json['type'] ?? 'Unknown Type') as String,
      ability: (json['ability'] ?? 'Unknown Ability') as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'ability': ability,
      'imageUrl': imageUrl,
    };
  }

  Character copyWith({
    int? id,
    String? name,
    String? type,
    String? ability,
    String? imageUrl,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      ability: ability ?? this.ability,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
