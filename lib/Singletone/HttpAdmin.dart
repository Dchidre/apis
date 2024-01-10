import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HttpAdmin {
  HttpAdmin();

  Future<Map<String, dynamic>> fetchPokemonData(String pokemonName) async {
    var url = Uri.https('pokeapi.co', '/api/v2/pokemon/$pokemonName');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al obtener datos del Pokémon');
    }
  }

  Future<String> fetchChuckNorrisJoke() async {
    var url = Uri.https('api.chucknorris.io', '/jokes/random');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse['value'];
    } else {
      throw Exception('Error al obtener la broma de Chuck Norris');
    }
  }
}