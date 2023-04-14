import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherRepository {
  final _baseUrl = "https://ibnux.github.io/BMKG-importer/cuaca/501233.json";

  Future getDataWeather() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<Weather> weather = it.map((e) => Weather.fromJson(e)).toList();
        return weather;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
