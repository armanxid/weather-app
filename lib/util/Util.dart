import 'package:flutter/cupertino.dart';

String weatherIcon(String $weatherStatus) {
  switch ($weatherStatus) {
    case "Cerah Berawan":
      return 'assets/icon/partly-cloudy.png';
    case "Berawan":
      return 'assets/icon/cloudy.png';
    case "Hujan Ringan":
      return 'assets/icon/rain.png';
    case "Cerah":
      return 'assets/icon/sun.png';
    default:
      return 'null';
  }
  // if ($weatherStatus == "Cerah Berawan") {
  //   return 'assets/icon/partly-cloudy.png';
  // } else {
  //   return $weatherStatus;
  // }
}

String getDate(String $time) {
  var $date = $time.split(' ');
  return $date[0];
}
