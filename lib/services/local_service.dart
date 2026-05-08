import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/character.dart';

class LocalCharacterService {
  static const _databaseName = 'character_builder.db';
  static const _databaseVersion = 1;
  static const _tableName = 'local_characters';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            ability TEXT NOT NULL,
            imageUrl TEXT
          )
        ''');
      },
    );
  }

  Future<Character> createCharacter(Character character) async {
    final db = await database;
    final id = await db.insert(_tableName, character.toJson()..remove('id'));
    return character.copyWith(id: id);
  }

  Future<List<Character>> getCharacters() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'id DESC');
    return maps.map(Character.fromJson).toList();
  }

  Future<void> deleteCharacter(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
