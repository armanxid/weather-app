import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/repository/weather_repository.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  DropdownItem? selectedDropdownItem;
  List<DropdownItem> dropdownItems = [];
  List? dataWeather;
  // List<Weather>? listWeather = [];
  // WeatherRepository weatherRepository = WeatherRepository();

  _getDataWeather() async {
    getJsonData(context, selectedDropdownItem?.id);
  }

  @override
  void initState() {
    _fetchData();
    // _getDataWeather();
    super.initState();
  }

  Future<void> getJsonData(BuildContext context, String? id) async {
    var urlWeather = "https://ibnux.github.io/BMKG-importer/cuaca/$id.json";
    var response = await http.get(Uri.parse(urlWeather));
    print('Weather $urlWeather');
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      dataWeather = convertDataToJson;
    });
  }

  Future<void> _fetchData() async {
    final response = await http.get(
        Uri.parse('https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json'));

    final List<dynamic> data = jsonDecode(response.body);
    setState(() {
      dropdownItems = data
          .map((item) => DropdownItem(
                id: item['id'] as String,
                propinsi: item['propinsi'] as String,
                kota: item['kota'] as String,
                kecamatan: item['kecamatan'] as String,
                lat: item['lat'] as String,
                lon: item['lon'] as String,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Center(
                child: DropdownButton<DropdownItem>(
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
                      _getDataWeather();
                    });
                  },
                ),
              ),
              Center(
                child: selectedDropdownItem != null
                    ? Text('${selectedDropdownItem!.kecamatan}')
                    : Text(''),
              ),
              SizedBox(
                height: 70,
              ),
              Center(
                child: dataWeather == null
                    ? Center(child: CircularProgressIndicator())
                    : Text(dataWeather?[2]['cuaca']),
                // child: RefreshIndicator(
                //   onRefresh: _fetchData,
                //   child: dataWeather == null
                //       ? Center(child: CircularProgressIndicator())
                //       : ListView.builder(
                //           itemCount:
                //               dataWeather == null ? 0 : dataWeather!.length,
                //           itemBuilder: (BuildContext context, int index) {
                //             return Container(
                //               padding: EdgeInsets.all(5.0),
                //               child: Column(
                //                 children: [
                //                   GestureDetector(
                //                     onTap: () {
                //                       print(dataWeather![index]["jamCuaca"]);
                //                     },
                //                     child: Padding(
                //                       padding: EdgeInsets.all(16.0),
                //                       child: Row(
                //                         children: [
                //                           SizedBox(width: 10),
                //                           Column(
                //                             children: [
                //                               Text(dataWeather![index]
                //                                       ["cuaca"] +
                //                                   " " +
                //                                   dataWeather![index]["tempC"]),
                //                               Text(dataWeather![index]["tempF"])
                //                             ],
                //                           )
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                   Divider()
                //                 ],
                //               ),
                //             );
                //           }),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownItem {
  final String id;
  final String propinsi;
  final String kota;
  final String kecamatan;
  final String lat;
  final String lon;

  DropdownItem(
      {required this.id,
      required this.propinsi,
      required this.kota,
      required this.kecamatan,
      required this.lat,
      required this.lon});
}
