import 'package:flutter/material.dart';
import 'package:weather_app/data/repositories/location_repository.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';
import 'package:weather_app/domain/models/location_item.dart';
import 'package:weather_app/domain/models/weather_item.dart';
import 'package:weather_app/domain/usecases/get_location_items_usecase.dart';
import 'package:weather_app/domain/usecases/get_weather_items_usecase.dart';
import 'package:weather_app/util/Util.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> with TickerProviderStateMixin {
  List<LocationItem>? _locationItems;
  LocationItem? _selectedlocationItem;

  List<WeatherItem>? _weatherItems;

  // Usecase
  final GetLocationItemsUsecase _getLocationItemsUsecase =
      GetLocationItemsUsecaseImpl(LocationRepositoryImpl());

  final GetWeatherItemsUsecase _getWeatherItemsUsecase =
      GetWeatherItemsUsecaseImpl(WeatherRepositoryImpl());
  late TabController _tabController;

  @override
  void initState() {
    // _getDataWeather();
    super.initState();
    _fetchLocationItems();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _fetchLocationItems() async {
    final List<LocationItem> data = await _getLocationItemsUsecase.execute();
    setState(() {
      _locationItems = data;
      _selectedlocationItem = _locationItems?[0];
    });
  }

  void _fetchWeatherItems(String idLocation) async {
    final List<WeatherItem> data =
        await _getWeatherItemsUsecase.execute(idLocation);
    setState(() {
      _weatherItems = data;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Future<void> _fetchData() async {
  //   final response = await http.get(
  //       Uri.parse('https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json'));

  //   final List<dynamic> data = jsonDecode(response.body);
  //   setState(() {
  //     locationItems = data
  //         .map((item) => LocationItem(
  //               id: item['id'] as String,
  //               propinsi: item['propinsi'] as String,
  //               kota: item['kota'] as String,
  //               kecamatan: item['kecamatan'] as String,
  //               lat: item['lat'] as String,
  //               lon: item['lon'] as String,
  //             ))
  //         .toList();
  //   });
  // }

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
                  _locationItems == null
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: DropdownButton(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            style: TextStyle(fontSize: 20),
                            alignment: Alignment.center,
                            hint: Text('Pilih Kabupaten'),
                            dropdownColor: Color.fromARGB(255, 145, 235, 247),
                            value: _selectedlocationItem,
                            items: _locationItems?.map((item) {
                              return DropdownMenuItem<LocationItem>(
                                value: item,
                                child: Text(
                                  item.kota,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedlocationItem = value as LocationItem;
                                _fetchWeatherItems(value.id);
                              });
                            },
                          ),
                        ),
                  Center(
                    child: _selectedlocationItem != null
                        ? Text(
                            '${_selectedlocationItem?.kecamatan}',
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
                  _weatherItems == null
                      ? Text(" ")
                      : Text(
                          '${_weatherItems?[0].tempC}\u2103',
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
                    child: _weatherItems == null
                        ? Text('')
                        : Text('${_weatherItems?[1].jamCuaca}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            )),
                  ),
                  _weatherItems == null
                      ? Text('')
                      : Text('${_weatherItems?[1].cuaca}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          )),
                  Center(
                    child: _weatherItems == null
                        ? Center(child: CircularProgressIndicator())
                        : weatherIcon('${_weatherItems?[1].cuaca}') == 'null'
                            ? Text('Tidak ada ikon')
                            : Image.asset(
                                weatherIcon('${_weatherItems?[1].cuaca}'),
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
