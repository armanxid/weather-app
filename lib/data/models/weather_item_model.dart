class WeatherItemModel {
  final String jamCuaca;
  final String kodeCuaca;
  final String cuaca;
  final String humidity;
  final String tempC;
  final String tempF;

  WeatherItemModel(
      {required this.jamCuaca,
      required this.kodeCuaca,
      required this.cuaca,
      required this.humidity,
      required this.tempC,
      required this.tempF});

  factory WeatherItemModel.fromJson(Map<String, dynamic> json) {
    return WeatherItemModel(
        jamCuaca: json['jamCuaca'],
        kodeCuaca: json['kodeCuaca'],
        cuaca: json['cuaca'],
        humidity: json['humidity'],
        tempC: json['tempC'],
        tempF: json['tempF']);
  }
}
