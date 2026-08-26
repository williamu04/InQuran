import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inquran/models/prayer.dart';

class PrayerService {
  Future<PrayerTime> getPrayerTimes(
    double lat,
    double lon, {
    DateTime? date,
  }) async {
    // kalau date tidak dikasih → pakai today
    final targetDate = date ?? DateTime.now();
    final timestamp = targetDate.millisecondsSinceEpoch ~/ 1000;

    final url = Uri.parse(
      'http://api.aladhan.com/v1/timings/$timestamp'
      '?latitude=$lat&longitude=$lon&method=2',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PrayerTime.fromJson(data);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
