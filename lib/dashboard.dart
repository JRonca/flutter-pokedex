import 'package:flutter/material.dart';
import 'package:pokedex/database/pokemons_database.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/pokemons.dart';
import 'package:pokedex/list.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => Dashboard();
}


class Dashboard extends State<HomeScreen> {
  bool isLoading = false;
  List<Pokemon> pokemons = [];

  Future<void> getAllPokemons() async {
    setState(() => isLoading = true);

    pokemons = await PokemonsDatabase.instance.readAllPokemons();

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getAllPokemons();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXemHlRavnga8h3aFlHWs_YYQqZicznhvWW9mZVpTCtQ&s'),
              accountName: const Text('Treinador Pokemon'), 
              accountEmail: const Text('treinador@pokemon.com.br')
            ),
            ListTile(
               title: const Text('Home'),
               leading: Icon(Icons.home),
               onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,);             
               },
            ),
          ExpansionTile(
               title: const Text('Cadastros'),
               leading: const Icon(Icons.settings),
               children: [
                    ListTile(
                      title: const Text('Buscar POKEMON'),
                      leading: const Icon(Icons.location_on_outlined),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => POKEMON()));             
                      },
                    )
                  ],
            ),            
            ListTile(
               title: const Text('Logout'),
               leading: Icon(Icons.logout),
               onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')),
                    (route) => false,);             
               },
            ),                       
          ],
          ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) : _buildPokemonsList(),
    );
  }
  Widget _buildPokemonsList() {
    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        final pokemon = pokemons[index];

        return GestureDetector(
            onTap: () async {
              await getAllPokemons();
            },
            child: PokemonListTile(pokemon: pokemon));
      },
    );
  }
}
