import 'package:flutter/foundation.dart' show immutable;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '/models/pokemon.dart';

@immutable
class PokemonsDatabase {
  static const String _databaseName = 'pokemons.db';
  static const int _databaseVersion = 1;

  // Create a singleton
  const PokemonsDatabase._privateConstructor();
  static const PokemonsDatabase instance = PokemonsDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  //! Create Database method
  Future _createDB(
    Database db,
    int version,
  ) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $pokemonsTable (
        ${PokemonsFields.id} $idType,
        ${PokemonsFields.species} $textType,
        ${PokemonsFields.type} $textType,
        ${PokemonsFields.imagemPadrao} $textType
      )
      ''');
  }

  //! C --> CRUD = Create
  Future<Pokemon> createPokemon(Pokemon pokemon) async {
    final db = await instance.database;
    final id = await db.insert(
      pokemonsTable,
      pokemon.toMap(),
    );

    return pokemon.copy(id: id);
  }

  //! R -- CURD = Read
  Future<Pokemon> readPokemon(int id) async {
    final db = await instance.database;

    final pokemonData = await db.query(
      pokemonsTable,
      columns: PokemonsFields.values,
      where: '${PokemonsFields.id} = ?',
      whereArgs: [id],
    );

    if (pokemonData.isNotEmpty) {
      return Pokemon.fromMap(pokemonData.first);
    } else {
      throw Exception('Could not find a pokemon with the given ID');
    }
  }

  // Get All Pokemons
  Future<List<Pokemon>> readAllPokemons() async {
    final db = await instance.database;

    final result =
        await db.query(pokemonsTable);

    return result.map((pokemonData) => Pokemon.fromMap(pokemonData)).toList();
  }

  //! D --> CRUD = Delete
  Future<int> deletePokemon(int id) async {
    final db = await instance.database;

    return await db.delete(
      pokemonsTable,
      where: '${PokemonsFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
