import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/util/Util.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> with TickerProviderStateMixin {
  DropdownItem? selectedDropdownItem;
  List<DropdownItem> dropdownItems = [];
  List? dataWeather;
  late TabController _tabController;
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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getJsonData(BuildContext context, String? id) async {
    var urlWeather = "https://ibnux.github.io/BMKG-importer/cuaca/$id.json";
    var response = await http.get(Uri.parse(urlWeather));
    print('Weather $urlWeather');
    print(dropdownItems.first);
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
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(255, 99, 64, 255),
                  Color.fromARGB(255, 143, 87, 255),
                  Color.fromARGB(255, 174, 134, 253),
                ], // Gradient from https://learnui.design/tools/gradient-generator.html
                tileMode: TileMode.mirror,
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: DropdownButton<DropdownItem>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      style: TextStyle(fontSize: 20),
                      alignment: Alignment.center,
                      hint: Text('Pilih Kabupaten'),
                      dropdownColor: Color.fromARGB(255, 145, 235, 247),
                      value: selectedDropdownItem,
                      items: dropdownItems.map((item) {
                        return DropdownMenuItem<DropdownItem>(
                          value: item,
                          child: Text(
                            item.kota,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
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
                        ? Text(
                            '${selectedDropdownItem!.kecamatan}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          )
                        : Text(''),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  dataWeather == null
                      ? Text(" ")
                      : Text(
                          '${dataWeather?[1]['tempC']}\u2103',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 100),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: dataWeather == null
                        ? Text('')
                        : Text(dataWeather?[1]['jamCuaca'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            )),
                  ),
                  dataWeather == null
                      ? Text('')
                      : Text(dataWeather?[1]['cuaca'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          )),
                  Center(
                    child: dataWeather == null
                        ? Center(child: CircularProgressIndicator())
                        : Image.asset(
                            weatherIcon(dataWeather?[1]['cuaca']),
                            width: 150,
                            height: 150,
                          ),
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: <Widget>[
                            Tab(
                              text: 'Hari ini',
                            ),
                            Tab(
                              text: 'Besok',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
