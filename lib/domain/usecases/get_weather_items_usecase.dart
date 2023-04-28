import 'package:weather_app/data/models/weather_item_model.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';
import 'package:weather_app/domain/models/weather_item.dart';

abstract class GetWeatherItemsUsecase {
  Future<List<WeatherItem>> execute(String idLocation);
}

class GetWeatherItemsUsecaseImpl implements GetWeatherItemsUsecase {
  final WeatherRepository _repository;

  GetWeatherItemsUsecaseImpl(this._repository);

  @override
  Future<List<WeatherItem>> execute(String idLocation) async {
    final List<WeatherItemModel> data =
        await _repository.getWeatherItems(idLocation);
    return data
        .map((item) => WeatherItem(
            jamCuaca: item.jamCuaca,
            kodeCuaca: item.kodeCuaca,
            cuaca: item.cuaca,
            humidity: item.humidity,
            tempC: item.tempC,
            tempF: item.tempF))
        .toList();
  }
}
