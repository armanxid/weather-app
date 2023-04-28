import 'dart:convert';

// import 'package:weather_app/HomePage.dart';
import 'package:weather_app/data/models/location_item_model.dart';
import 'package:http/http.dart' as http;

abstract class LocationRepository {
  Future<List<LocationItemModel>> getLocationItems();
}

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<List<LocationItemModel>> getLocationItems() async {
    final response = await http.get(
        Uri.parse('https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => LocationItemModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }
}
