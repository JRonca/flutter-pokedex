import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonListTile extends StatefulWidget {
  const PokemonListTile({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  State<PokemonListTile> createState() => _PokemonListTileState();
}

class _PokemonListTileState extends State<PokemonListTile> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: CupertinoListTile(
          leading: ClipRRect(
            child: Image(
              image: NetworkImage(widget.pokemon.imagemPadrao),
              width: 100, // Defina a largura conforme necessário
              height: 100, // Defina a altura conforme necessário
              fit: BoxFit.cover, // Ajuste de acordo com sua necessidade
            ),
          ),
          title: Text(
            widget.pokemon.species,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.pokemon.type,
            maxLines: 3,
          ),
          // trailing: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     widget.pokemon.imagemPadrao,
          //   ),
          // ),
        ),
      ),
    );
  }
}
