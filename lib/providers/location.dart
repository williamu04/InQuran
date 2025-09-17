import 'package:flutter/material.dart';
import 'package:mtqmnuns/services/geocode.dart';

class LocationProvider with ChangeNotifier {
  String? placeName;
  double? latitude;
  double? longitude;
  bool loading = true;

  Future<void> loadLocation() async {
    try {
      final position = await LocationHelper.getCurrentLocation();
      final name = await LocationHelper.getPlaceName(
        position.latitude,
        position.longitude,
      );

      latitude = position.latitude;
      longitude = position.longitude;
      placeName = name;
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      placeName = "Lokasi tidak tersedia";
      notifyListeners();
    }
  }
}
