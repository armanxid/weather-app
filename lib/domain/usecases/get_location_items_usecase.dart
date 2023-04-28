import 'package:weather_app/data/models/location_item_model.dart';
import 'package:weather_app/data/repositories/location_repository.dart';
import 'package:weather_app/domain/models/location_item.dart';

abstract class GetLocationItemsUsecase {
  Future<List<LocationItem>> execute();
}

class GetLocationItemsUsecaseImpl implements GetLocationItemsUsecase {
  final LocationRepository _repository;

  GetLocationItemsUsecaseImpl(this._repository);

  @override
  Future<List<LocationItem>> execute() async {
    final List<LocationItemModel> data = await _repository.getLocationItems();
    return data
        .map((item) => LocationItem(
            id: item.id,
            propinsi: item.propinsi,
            kota: item.kota,
            kecamatan: item.kecamatan,
            lat: item.lat,
            lon: item.lon))
        .toList();
  }
}
