import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DropdownItem? selectedDropdownItem;
  List<DropdownItem> dropdownItems = [];

  Future<void> fetchWeatherData() async {
    final response = await http.get(
        Uri.parse("https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json"));
    final data = jsonDecode(response.body);

    setState(() {
      List<DropdownItem> dropdownItems = (jsonDecode(response.body) as List)
          .map((item) => DropdownItem(
                id: item['id'] as int,
                propinsi: item['propinsi'] as String,
                kota: item['kota'] as String,
                kecamatan: item['kecamatan'] as String,
                lat: item['lat'] as double,
                lon: item['lon'] as double,
              ))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                DropdownButton<DropdownItem>(
                  value: selectedDropdownItem,
                  items: dropdownItems.map((item) {
                    return DropdownMenuItem<DropdownItem>(
                      value: item,
                      child: Text(item.kota),
                    );
                  }).toList(),
                  onChanged: (item) {
                    setState(() {
                      selectedDropdownItem = item;
                    });
                  },
                )
              ],
            )),
      ),
    );
  }
}

class DropdownItem {
  final int id;
  final String propinsi;
  final String kota;
  final String kecamatan;
  final double lat;
  final double lon;

  DropdownItem(
      {required this.id,
      required this.propinsi,
      required this.kota,
      required this.kecamatan,
      required this.lat,
      required this.lon});
}
