import 'package:inquran/services/geocode.dart';
import 'package:inquran/services/prayer.dart';
import 'package:inquran/state/prayer_time.dart';
import 'package:inquran/state/stateful_viewmodel.dart';

class PrayerTimeViewModel extends StatefulViewModel<PrayerTimeState> {
  final PrayerService service;
  DateTime selectedDate = DateTime.now();

  PrayerTimeViewModel(this.service) : super(PrayerTimeLoading());

  Future<void> loadPrayerTimes({DateTime? date}) async {
    setState(PrayerTimeLoading());

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

      selectedDate = targetDate;
      setState(
        PrayerTimeSuccess(
          prayerTime: result,
          currentLocation: placeName,
          selectedDate: targetDate,
        ),
      );
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
        selectedDate = targetDate;
        setState(
          PrayerTimeSuccess(
            prayerTime: result,
            currentLocation: "Jakarta (default)",
            selectedDate: targetDate,
          ),
        );
      } catch (e) {
        setState(PrayerTimeError("Lokasi tidak tersedia"));
      }
    }
  }

  void changeDate(int offset) {
    selectedDate = selectedDate.add(Duration(days: offset));
    loadPrayerTimes(date: selectedDate);
  }
}