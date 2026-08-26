import 'package:inquran/models/prayer.dart';

sealed class PrayerTimeState {}

class PrayerTimeLoading extends PrayerTimeState {}

class PrayerTimeError extends PrayerTimeState {
  final String message;
  PrayerTimeError(this.message);
}

class PrayerTimeSuccess extends PrayerTimeState {
  final PrayerTime prayerTime;
  final String currentLocation;
  final DateTime selectedDate;

  PrayerTimeSuccess({
    required this.prayerTime,
    required this.currentLocation,
    required this.selectedDate,
  });
}