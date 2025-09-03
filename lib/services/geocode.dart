import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  // fungsi ambil lokasi koordinat
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // fungsi konversi koordinat ke nama lokasi
  static Future<String> getPlaceName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // bisa pilih detail apa yang mau ditampilkan
        return "${place.subAdministrativeArea}, ${place.administrativeArea}";
      } else {
        return "${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}";
      }
    } catch (e) {
      return "${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}";
      // return "Lokasi tidak diketahui";
    }
  }
}
