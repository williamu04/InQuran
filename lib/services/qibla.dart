import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:inquran/services/geocode.dart';

class QiblaHelper {
  static const double _kaabahLat = 21.4225;
  static const double _kaabahLng = 39.8262;

  static double _toRadians(double degree) => degree * pi / 180;
  static double _toDegrees(double radian) => radian * 180 / pi;

  /// Hitung arah kiblat dari lokasi user (0–360 derajat)
  static Future<double> getQiblaDirection() async {
    Position pos = await LocationHelper.getCurrentLocation();
    return _calculateQiblaDirection(pos.latitude, pos.longitude);
  }

  static double _calculateQiblaDirection(double userLat, double userLng) {
    double lat1 = _toRadians(userLat);
    double lon1 = _toRadians(userLng);
    double lat2 = _toRadians(_kaabahLat);
    double lon2 = _toRadians(_kaabahLng);

    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);

    return (_toDegrees(bearing) + 360) % 360;
  }
}
