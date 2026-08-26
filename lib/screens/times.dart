import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:inquran/models/prayer.dart';
import 'package:inquran/state/prayer_time.dart';
import 'package:inquran/viewmodel/prayer_time.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

class PrayerTimeScreen extends StatelessWidget {
  const PrayerTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PrayerTimeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Waktu Salat")),
      body: switch (vm.state) {
        PrayerTimeLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        PrayerTimeError() => const Center(child: Text("Gagal memuat data")),
        PrayerTimeSuccess(
          :final prayerTime,
          :final currentLocation,
          :final selectedDate,
        ) => Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Text(
                currentLocation,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              PrayerHeader(
                date: selectedDate,
                onPrev: () => vm.changeDate(-1),
                onNext: () => vm.changeDate(1),
              ),
              const SizedBox(height: 20),
              Expanded(child: PrayerList(prayerTime: prayerTime)),
            ],
          ),
        ),
      },
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
          title: "Subuh",
          time: prayerTime.fajr,
          icon: LucideIcons.cloudSun,
        ),
        PrayerCard(
          title: "Zuhur",
          time: prayerTime.dhuhr,
          icon: LucideIcons.sun,
        ),
        PrayerCard(
          title: "Asar",
          time: prayerTime.asr,
          icon: LucideIcons.sunset,
        ),
        PrayerCard(
          title: "Magrib",
          time: prayerTime.maghrib,
          icon: LucideIcons.cloudMoon,
        ),
        PrayerCard(
          title: "Isya",
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
    return Semantics(
      label: "Waktu salat $title, pukul $time",
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 7),
        color: AppColors.primary,
        child: ListTile(
          leading: Semantics(
            label: "Ikon salat $title",
            child: Icon(icon, color: AppColors.primaryLight, size: 28),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: AppColors.background,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: "Jam salat $title adalah $time",
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.deepPurple,
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
              ),
              const SizedBox(width: 12),
              Semantics(
                button: true,
                label: "Atur alarm untuk salat $title",
                child: IconButton(
                  icon: const Icon(
                    LucideIcons.alarmClockPlus,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Alarm untuk $title akan segera hadir"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
      return "Hari ini";
    } else if (target == today.subtract(const Duration(days: 1))) {
      return "Kemarin";
    } else if (target == today.add(const Duration(days: 1))) {
      return "Besok";
    } else {
      return DateFormat('EEEE', 'id').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayLabel = _getDayLabel();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: "Hari sebelumnya",
          icon: const Icon(
            LucideIcons.chevronLeft,
            size: 48,
            color: AppColors.textSecondary,
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
                color: AppColors.primary,
              ),
            ),
            Text(
              DateFormat('d MMMM yyyy').format(date),
              style: const TextStyle(fontSize: 16, color: AppColors.primaryLight),
            ),
          ],
        ),
        IconButton(
          tooltip: "Hari berikutnya",
          icon: const Icon(
            LucideIcons.chevronRight,
            size: 48,
            color: AppColors.textSecondary,
          ),
          onPressed: onNext,
        ),
      ],
    );
  }
}
