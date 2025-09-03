import 'package:flutter/material.dart';
import 'package:mtqmnuns/models/prayer.dart';
import 'package:mtqmnuns/services/geocode.dart'; // Change this line
import 'package:mtqmnuns/services/prayer.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerTimeScreen> {
  final service = PrayerService();
  PrayerTime? prayerTime;
  bool isLoading = true;
  String currentLocation = "Memuat lokasi...";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      final position = await LocationHelper.getCurrentLocation();
      final result = await service.getPrayerTimes(
        position.latitude,
        position.longitude,
      );

      // ambil nama tempat
      final placeName = await LocationHelper.getPlaceName(
        position.latitude,
        position.longitude,
      );

      setState(() {
        prayerTime = result;
        currentLocation = placeName; // tampilkan nama kota/kecamatan
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Lokasi gagal: $e");

      // fallback Jakarta
      const jakartaLat = -6.200000;
      const jakartaLon = 106.816666;
      try {
        final result = await service.getPrayerTimes(jakartaLat, jakartaLon);
        setState(() {
          prayerTime = result;
          currentLocation = "Jakarta (default)";
          isLoading = false;
        });
      } catch (e) {
        debugPrint("Gagal load fallback Jakarta: $e");
        setState(() {
          isLoading = false;
          currentLocation = "Lokasi tidak tersedia";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Jadwal Sholat")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : prayerTime == null
              ? const Center(child: Text("Gagal memuat data"))
              : Column(
                // padding: const EdgeInsets.all(16),
                children: [
                  // Box lokasi
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            currentLocation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // daftar jadwal sholat
                  Column(
                    children: [
                      PrayerCard(
                        title: "Subuh",
                        time: prayerTime!.fajr,
                        icon: Icons.wb_twilight_rounded,
                      ),
                      PrayerCard(
                        title: "Dzuhur",
                        time: prayerTime!.dhuhr,
                        icon: Icons.wb_sunny,
                      ),
                      PrayerCard(
                        title: "Ashar",
                        time: prayerTime!.asr,
                        icon: Icons.wb_sunny_outlined,
                      ),
                      PrayerCard(
                        title: "Maghrib",
                        time: prayerTime!.maghrib,
                        icon: Icons.nightlight_outlined,
                      ),
                      PrayerCard(
                        title: "Isya",
                        time: prayerTime!.isha,
                        icon: Icons.nightlight,
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}

class PrayerCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;

  const PrayerCard({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(time, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.alarm, color: Colors.grey),
              onPressed: () {
                // TODO: aksi untuk set alarm
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Alarm untuk $title belum diimplementasi"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
