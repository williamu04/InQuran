import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/models/prayer.dart';
import 'package:mtqmnuns/providers/location.dart';
import 'package:mtqmnuns/screens/login.dart';
import 'package:mtqmnuns/services/geocode.dart';
import 'package:mtqmnuns/services/prayer.dart';
import 'package:provider/provider.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  final service = PrayerService();
  PrayerTime? prayerTime;
  bool isLoading = true;
  String currentLocation = "Memuat lokasi...";
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _changeDate(int offset) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: offset));
      isLoading = true;
    });
    loadData();
  }

  void loadData() async {
    try {
      final position = await LocationHelper.getCurrentLocation();
      final result = await service.getPrayerTimes(
        position.latitude,
        position.longitude,
        date: selectedDate,
      );

      final placeName = await LocationHelper.getPlaceName(
        position.latitude,
        position.longitude,
      );

      setState(() {
        prayerTime = result;
        currentLocation = placeName;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Lokasi gagal: $e");

      const jakartaLat = -6.200000;
      const jakartaLon = 106.816666;
      try {
        final result = await service.getPrayerTimes(
          jakartaLat,
          jakartaLon,
          date: selectedDate,
        );
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
          child: TopBarUtility.buildDefaultTopBar(
            context: context,
            title: "Prayer Times",
          ),
        ),
        Expanded(child: _buildMainContent(context)),
      ],
    );
  }

  Scaffold _buildMainContent(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : prayerTime == null
              ? const Center(child: Text("Gagal memuat data"))
              : Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    PrayerLocationBox(
                      locationProvider: locationProvider,
                      onReload: () async {
                        setState(() => isLoading = true);
                        await context.read<LocationProvider>().loadLocation();
                        loadData();
                      },
                    ),
                    const SizedBox(height: 20),
                    PrayerHeader(
                      date: selectedDate,
                      onPrev: () => _changeDate(-1),
                      onNext: () => _changeDate(1),
                    ),
                    const SizedBox(height: 20),
                    Expanded(child: PrayerList(prayerTime: prayerTime!)),
                  ],
                ),
              ),
    );
  }
}

class PrayerHeader extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const PrayerHeader({
    super.key,
    required this.date,
    required this.onPrev,
    required this.onNext,
  });

  String _getDayLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return "Today";
    } else if (target == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    } else if (target == today.add(const Duration(days: 1))) {
      return "Tomorrow";
    } else {
      return DateFormat('EEEE').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayLabel = _getDayLabel();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            LucideIcons.chevronLeft,
            size: 48,
            color: Color(0xff7C8BA0),
          ),
          onPressed: onPrev,
        ),
        Column(
          children: [
            Text(
              dayLabel,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xff672CBC),
                // letterSpacing: 2,
              ),
            ),
            Text(
              DateFormat('d MMMM yyyy').format(date),
              style: const TextStyle(fontSize: 16, color: Color(0xff994EF8)),
            ),
          ],
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            LucideIcons.chevronRight,
            size: 48,
            color: Color(0xff7C8BA0),
          ),
          onPressed: onNext,
        ),
      ],
    );
  }
}

class PrayerLocationBox extends StatelessWidget {
  final LocationProvider locationProvider;
  final VoidCallback onReload;

  const PrayerLocationBox({
    super.key,
    required this.locationProvider,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          label: const Text(
            "Current",
            style: TextStyle(color: Color(0xff7C8BA0)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffF3F4F6),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onPressed: onReload,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fitur pencarian lokasi belum diimplementasi"),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      locationProvider.placeName ?? "Lokasi tidak tersedia",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PrayerList extends StatelessWidget {
  final PrayerTime prayerTime;

  const PrayerList({super.key, required this.prayerTime});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PrayerCard(
          title: "Fajr",
          time: prayerTime.fajr,
          icon: LucideIcons.cloudSun,
        ),
        PrayerCard(
          title: "Dzuhr",
          time: prayerTime.dhuhr,
          icon: LucideIcons.sun,
        ),
        PrayerCard(
          title: "Asr",
          time: prayerTime.asr,
          icon: LucideIcons.sunset,
        ),
        PrayerCard(
          title: "Maghrib",
          time: prayerTime.maghrib,
          icon: LucideIcons.cloudMoon,
        ),
        PrayerCard(
          title: "Isha",
          time: prayerTime.isha,
          icon: LucideIcons.moonStar,
        ),
      ],
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
      margin: const EdgeInsets.symmetric(vertical: 7),
      color: const Color(0xff672CBC),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xff994EF8), size: 28),
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
              // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xff3B1D77),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 100,
              height: 30,
              alignment: Alignment.center,
              child: Text(
                time,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(LucideIcons.alarmClockPlus, color: Colors.white),
              onPressed: () {
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
