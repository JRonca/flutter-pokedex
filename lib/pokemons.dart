import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pokedex/database/pokemons_database.dart';
import 'package:pokedex/models/pokemon.dart';

// pesquisas: pikachu, ditto, mewtwo, psyduck, onix, bulbasaur

class POKEMON extends StatefulWidget {
  const POKEMON({super.key});

  @override
  State<POKEMON> createState() => _POKEMONState();
}

class _POKEMONState extends State<POKEMON> {
  String imagemPadrao = 'https://img.quizur.com/f/img5ecdad76f16749.58160519.png';
  final TextEditingController pokemonController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  Future<void> addPokemon() async {
    final pokemon = Pokemon(
      species: speciesController.text,
      type: typeController.text,
      imagemPadrao: imagemPadrao
    );

    await PokemonsDatabase.instance.createPokemon(pokemon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busca POKEMON'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              textField('POKEMON', pokemonController, 250),
              MaterialButton(
                minWidth: 50,
                height: 50,
                color: Colors.blue,
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: const Icon(Icons.search, color: Colors.white,  size: 24),
                onPressed: () async {
                  if (pokemonController.text.isNotEmpty) {
                    await buscarPokemon(pokemonController.text);
                  } else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('POKEMON não preenchido'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        ),
                      
                    );
                  }
                },
              ),
            ],
          ),
          Center(
          child: Image(
              image: NetworkImage(imagemPadrao),
              width: 200, // Defina a largura conforme necessário
              height: 200, // Defina a altura conforme necessário
              fit: BoxFit.cover, // Ajuste de acordo com sua necessidade
            ),
          ),
          textField('Espécie', speciesController, 0),
          textField('tipo', typeController, 0),
        ],
      ),
    );
  }
  dynamic textField(texto, controller, double tamanho){
    return  Column(
      children: [
        const SizedBox(height: 10),
        Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: (tamanho > 0) ? tamanho : null,
                decoration:
                BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ]
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: texto,
                    border: const OutlineInputBorder()
                  ),
                  ),
                )
                    ,
            ),
      ],
    );
  }

  Future<void> buscarPokemon(pokemon) async {
    try {
      Response resposta = await Dio().get('https://pokeapi.co/api/v2/pokemon/$pokemon');

      if(resposta.statusCode == 200) {
        speciesController.text = resposta.data['species']['name'].toString().toUpperCase();
        typeController.text = resposta.data['types'][0]['type']['name'].toString().toUpperCase();
        setState(() {
          imagemPadrao = resposta.data['sprites']['front_default'].toString();
        });

        await addPokemon();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pokemon registrado'))
        );
        
      } else {
        speciesController.text = '';
        typeController.text = '';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pokemon não encontrado'))
        );
      }
    }catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ERROR'))
      );
    }
  }
}