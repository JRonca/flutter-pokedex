import 'package:flutter/foundation.dart' show immutable;

const String pokemonsTable = 'pokemons';

class PokemonsFields {
  static final List<String> values = [
    id,
    species,
    type,
    imagemPadrao,
  ];

  static const id = 'id';
  static const species = 'species';
  static const type = 'type';
  static const imagemPadrao = 'imagemPadrao';
}

@immutable
class Pokemon {
  final int? id;
  final String species;
  final String type;
  final String imagemPadrao;

  const Pokemon({
    this.id,
    required this.species,
    required this.type,
    required this.imagemPadrao,
  });

  Pokemon copy({
    int? id,
    String? species,
    String? type,
    String? imagemPadrao,
  }) =>
      Pokemon(
        id: id ?? this.id,
        species: species ?? this.species,
        type: type ?? this.type,
        imagemPadrao: imagemPadrao ?? this.imagemPadrao,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      PokemonsFields.id: id,
      PokemonsFields.species: species,
      PokemonsFields.type: type,
      PokemonsFields.imagemPadrao: imagemPadrao,
    };
  }

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map[PokemonsFields.id] != null ? map[PokemonsFields.id] as int : null,
      species: map[PokemonsFields.species] as String,
      type: map[PokemonsFields.type] as String,
      imagemPadrao: map[PokemonsFields.imagemPadrao] as String
    );
  }
}
