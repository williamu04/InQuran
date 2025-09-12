import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/models/prayer.dart';
import 'package:mtqmnuns/providers/location.dart';
import 'package:mtqmnuns/screens/login.dart';
import 'package:mtqmnuns/services/geocode.dart'; // Change this line
import 'package:mtqmnuns/services/prayer.dart';
import 'package:provider/provider.dart';

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
    return Column(
      children: [
        roundedCard(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: TopBarUtility.buildDefaultTopBar(context: context, title: "Prayeer Times")
        ),
        Expanded(
          child: _buildMainContent(context)
        )
      ],
    );

  }

  Scaffold _buildMainContent(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    if (locationProvider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (locationProvider.latitude == null ||
        locationProvider.longitude == null) {
      return const Scaffold(body: Center(child: Text("Lokasi tidak tersedia")));
    }

    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : prayerTime == null
              ? const Center(child: Text("Gagal memuat data"))
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Box lokasi
                    Container(
                      // padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        // color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // "Current" button
                          ElevatedButton.icon(
                            // icon: const Icon(
                            //   Icons.my_location,
                            //   size: 18,
                            //   color: Color(0xff672CBC),
                            // ),
                            label: const Text(
                              "Current",
                              style: TextStyle(color: Color(0xff7C8BA0)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffF3F4F6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await context
                                  .read<LocationProvider>()
                                  .loadLocation();
                              loadData();
                            },
                          ),
                          const SizedBox(width: 12),
                          // Location display as button
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                // TODO: Implement location search/adjust dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Fitur pencarian lokasi belum diimplementasi",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Color(0xff672CBC),
                                    width: 0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        locationProvider.placeName ??
                                            "Lokasi tidak tersedia",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // const Icon(
                                    //   Icons.edit_location_alt,
                                    //   size: 20,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add TODAY and date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Today",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff672CBC),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('d MMMM yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff994EF8),
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                    // daftar jadwal sholat
                    Column(
                      children: [
                        PrayerCard(
                          title: "Fajr",
                          time: prayerTime!.fajr,
                          icon: Icons.wb_twilight_rounded,
                        ),
                        PrayerCard(
                          title: "Dzuhr",
                          time: prayerTime!.dhuhr,
                          icon: Icons.wb_sunny,
                        ),
                        PrayerCard(
                          title: "Asr",
                          time: prayerTime!.asr,
                          icon: Icons.wb_sunny_outlined,
                        ),
                        PrayerCard(
                          title: "Maghrib",
                          time: prayerTime!.maghrib,
                          icon: Icons.nightlight_outlined,
                        ),
                        PrayerCard(
                          title: "Isha",
                          time: prayerTime!.isha,
                          icon: Icons.nightlight,
                        ),
                      ],
                    ),
                  ],
                ),
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
      color: Color(0xff672CBC),
      child: ListTile(
        leading: Icon(icon, color: Color(0xff994EF8), size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: Color(0xffF5F9FE),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xff3B1D77),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 80,
              height: 40,
              alignment: Alignment.center,

              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.alarm_add, color: Colors.white),
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
