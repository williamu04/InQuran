import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/models/prayer.dart';
import 'package:mtqmnuns/services/geocode.dart';
import 'package:mtqmnuns/services/prayer.dart';

class PrayerTimeViewModel extends ChangeNotifier {
  final PrayerService service;
  PrayerTime? prayerTime;
  bool isLoading = true;
  String currentLocation = "Memuat lokasi...";
  DateTime selectedDate = DateTime.now();

  PrayerTimeViewModel(this.service);

  Future<void> loadPrayerTimes({DateTime? date}) async {
    isLoading = true;
    notifyListeners();

    final targetDate = date ?? selectedDate;
    try {
      final position = await LocationHelper.getCurrentLocation();
      final result = await service.getPrayerTimes(
        position.latitude,
        position.longitude,
        date: targetDate,
      );
      final placeName = await LocationHelper.getPlaceName(
        position.latitude,
        position.longitude,
      );

      prayerTime = result;
      currentLocation = placeName;
    } catch (_) {
      // fallback ke Jakarta
      const jakartaLat = -6.200000;
      const jakartaLon = 106.816666;
      try {
        final result = await service.getPrayerTimes(
          jakartaLat,
          jakartaLon,
          date: targetDate,
        );
        prayerTime = result;
        currentLocation = "Jakarta (default)";
      } catch (e) {
        currentLocation = "Lokasi tidak tersedia";
      }
    }

    isLoading = false;
    selectedDate = targetDate;
    notifyListeners();
  }

  void changeDate(int offset) {
    selectedDate = selectedDate.add(Duration(days: offset));
    loadPrayerTimes(date: selectedDate);
  }
}
