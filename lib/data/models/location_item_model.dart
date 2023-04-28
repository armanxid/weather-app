class LocationItemModel {
  final String id;
  final String propinsi;
  final String kota;
  final String kecamatan;
  final String lat;
  final String lon;

  LocationItemModel(
      {required this.id,
      required this.propinsi,
      required this.kota,
      required this.kecamatan,
      required this.lat,
      required this.lon});

  factory LocationItemModel.fromJson(Map<String, dynamic> json) {
    return LocationItemModel(
        id: json['id'],
        propinsi: json['propinsi'],
        kota: json['kota'],
        kecamatan: json['kecamatan'],
        lat: json['lat'],
        lon: json['lon']);
  }
}
