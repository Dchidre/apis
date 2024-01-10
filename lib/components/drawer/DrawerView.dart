
import 'package:exa_chircea/FbObjects/fbUser.dart';
import 'package:exa_chircea/components/drawer/optionTile.dart';
import 'package:exa_chircea/components/drawer/userInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Singletone/DataHolder.dart';
import '../../Singletone/HttpAdmin.dart';
import '../../Singletone/HttpAdmin.dart';
import 'header.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  bool _isCollapsed = false;

  void _showPokemonInfoDialog(BuildContext context, Map<String, dynamic> pokemonData) {
    List<String> abilities = [];

    // Verificar si el diccionario contiene la clave 'abilities'
    if (pokemonData.containsKey('abilities')) {
      // Obtener la lista de habilidades
      List<dynamic> abilitiesList = pokemonData['abilities'];

      // Extraer los nombres de las habilidades
      abilities = abilitiesList
          .map<String>((ability) => ability['ability']['name'])
          .toList();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${pokemonData['name']}'),
              Text('Habilidades: ${abilities.join(', ')}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doApiPokemon() {
    TextEditingController _pokemonNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar Pokémon'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _pokemonNameController,
                decoration: InputDecoration(labelText: 'Nombre del Pokémon'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Buscar'),
              onPressed: () async {
                String pokemonName = _pokemonNameController.text.trim().toLowerCase();
                if (pokemonName.isNotEmpty) {
                  Navigator.of(context).pop(); // Cerrar el diálogo de búsqueda

                  Map<String, dynamic> pokemonData =
                  await DataHolder().httpAdmin.fetchPokemonData(pokemonName);
                  _showPokemonInfoDialog(context, pokemonData);
                }
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> doChuckNorris() async {
    String chuckNorrisJoke = await DataHolder().httpAdmin.fetchChuckNorrisJoke();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Broma de Chuck Norris: $chuckNorrisJoke'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 300),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(20, 20, 20, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              header(isColapsed: _isCollapsed),
              const Divider(
                color: Colors.grey,
              ),
              optionTile(
                fAction: () {
                  Navigator.of(context).popAndPushNamed('/homeView');
                },
                isCollapsed: _isCollapsed,
                icon: Icons.home_outlined,
                title: 'Home',
                infoCount: 0,
              ),
              const Divider(color: Colors.grey),
              optionTile(
                fAction: () {
                  Navigator.of(context).popAndPushNamed('/changeProfileView');
                },
                isCollapsed: _isCollapsed,
                icon: Icons.person,
                title: 'Profile',
                infoCount: 0,
              ),
              const Divider(color: Colors.grey),
              //apis
              optionTile(
                fAction: () {doApiPokemon();},
                isCollapsed: _isCollapsed,
                icon: Icons.ac_unit_outlined,
                title: 'API1 - Pokemon',
                infoCount: 0,
              ),
              const Divider(color: Colors.grey),
              //fin apis
              //apis
              optionTile(
                fAction: () { doChuckNorris();
                },
                isCollapsed: _isCollapsed,
                icon: Icons.ac_unit_outlined,
                title: 'API2 - Chuck Norris',
                infoCount: 0,
              ),
              const Divider(color: Colors.grey),
              //fin apis
              //apis
              optionTile(
                fAction: () {
                },
                isCollapsed: _isCollapsed,
                icon: Icons.ac_unit_outlined,
                title: 'API1',
                infoCount: 0,
              ),
              const Divider(color: Colors.grey),
              //fin apis
              const Spacer(),
              optionTile(
                fAction: () {
                  Navigator.of(context).pushNamed('/settingsView');
                },
                isCollapsed: _isCollapsed,
                icon: Icons.settings,
                title: 'Settings',
                infoCount: 0,
              ),
              const SizedBox(height: 10),
              userInfo(
                isCollapsed: _isCollapsed,
              ),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}