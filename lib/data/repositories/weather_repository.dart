import 'dart:convert';

import 'package:weather_app/data/models/weather_item_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRepository {
  Future<List<WeatherItemModel>> getWeatherItems(String idLocation);
}

class WeatherRepositoryImpl implements WeatherRepository {
  late String idLocation;

  @override
  Future<List<WeatherItemModel>> getWeatherItems(String idLocation) async {
    final response = await http.get(Uri.parse(
        'https://ibnux.github.io/BMKG-importer/cuaca/$idLocation.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => WeatherItemModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }
}
