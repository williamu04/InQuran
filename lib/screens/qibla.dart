import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:inquran/common/app_color.dart';
import 'package:inquran/components/top_bar_utils.dart';
import 'package:inquran/components/rounded_card.dart';
import 'package:inquran/services/qibla.dart';
import 'package:vibration/vibration.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inquran/state/location.dart';
import 'package:inquran/viewmodel/location.dart';
import 'package:provider/provider.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _qiblaDirection;
  bool _loading = true;
  String? _error;
  bool _hasVibrated = false;
  StreamSubscription<CompassEvent>? _compassSubscription; // Add this line

  @override
  void initState() {
    super.initState();
    _initQibla();
  }

  Future<void> _initQibla() async {
    try {
      final qibla = await QiblaHelper.getQiblaDirection();
      setState(() {
        _qiblaDirection = qibla;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // Add dispose method
  @override
  void dispose() {
    _compassSubscription?.cancel(); // Cancel compass subscription
    Vibration.cancel(); // Stop any ongoing vibration
    super.dispose();
  }

  // Modify the StreamBuilder to store the subscription
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      if (_error.toString().contains("Location services are disabled")) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Akses lokasi belum diaktifkan.\nSilakan aktifkan lokasi untuk melanjutkan.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    _initQibla();
                  },
                  child: const Text("Izinkan akses lokasi"),
                ),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(body: Center(child: Text("Terjadi kesalahan: $_error")));
      }
    }

    final locationVm = context.watch<LocationViewModel>();
    final placeName = switch (locationVm.state) {
      LocationSuccess(:final placeName) => placeName,
      _ => "Lokasi tidak tersedia",
    };

    return Scaffold(
      body: Column(
        children: [
          roundedCard(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: TopBarUtility.buildDefaultTopBar(
              context: context,
              title: "Pencari Kiblat",
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: // In _QiblaScreenState build method, update the location container:
                  Semantics(
                label: 'Lokasi saat ini',
                value: placeName,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          placeName,
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
          ),
          Expanded(
            child: StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                // Store the subscription when the stream is first built
                _compassSubscription ??= FlutterCompass.events?.listen((event) {
                  // Empty listener - just to maintain the subscription
                });

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Sensor kompas tidak tersedia"),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                double deviceHeading = snapshot.data!.heading ?? 0;

                // hitung selisih arah
                double diff = (_qiblaDirection! - deviceHeading) % 360;
                if (diff < 0) diff += 360;

                double angle = diff * (pi / 180);

                double radius = 120;
                double x = radius * sin(angle);
                double y = -radius * cos(angle);

                // normalisasi selisih terkecil
                double normalizedDiff = diff > 180 ? 360 - diff : diff;
                bool isFacingQibla = normalizedDiff < 5;

                // halaman tidak sedang aktif (ditutup / tertutup halaman lain)
                bool isRouteActive = ModalRoute.of(context)?.isCurrent ?? true;

                // getar sekali saat tepat kiblat
                if (isRouteActive && isFacingQibla && !_hasVibrated) {
                  Vibration.vibrate(duration: 200);
                  _hasVibrated = true;
                } else if (!isFacingQibla) {
                  _hasVibrated = false;
                }

                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: QiblaCompass(
                          angle: angle,
                          x: x,
                          y: y,
                          isFacingQibla: isFacingQibla,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: QiblaCaption(isFacingQibla: isFacingQibla),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QiblaCompass extends StatelessWidget {
  final double angle;
  final double x;
  final double y;
  final bool isFacingQibla;

  const QiblaCompass({
    super.key,
    required this.angle,
    required this.x,
    required this.y,
    required this.isFacingQibla,
  });

  @override
  Widget build(BuildContext context) {
    // Convert angle to degrees for accessibility announcement
    final degrees = (angle * (180 / pi)).round();
    final direction = getDirectionFromAngle(degrees);

    return Semantics(
      label: 'Kompas Kiblat',
      value:
          isFacingQibla
              ? 'Anda menghadap kiblat'
              : 'Kiblat berada di arah $direction, $degrees derajat',
      liveRegion: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [AppColors.darkestPurple, AppColors.purpleAccent],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          Semantics(
            label: 'Panah penunjuk arah utara',
            child: Image.asset(
              "assets/img/arrow.png",
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
          Semantics(
            label: 'Penanda arah kiblat',
            child: Transform.translate(
              offset: Offset(x, y),
              child: const Icon(
                LucideIcons.locateFixed,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDirectionFromAngle(int degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'utara';
    if (degrees >= 22.5 && degrees < 67.5) return 'timur laut';
    if (degrees >= 67.5 && degrees < 112.5) return 'timur';
    if (degrees >= 112.5 && degrees < 157.5) return 'tenggara';
    if (degrees >= 157.5 && degrees < 202.5) return 'selatan';
    if (degrees >= 202.5 && degrees < 247.5) return 'barat daya';
    if (degrees >= 247.5 && degrees < 292.5) return 'barat';
    return 'barat laut';
  }
}

class QiblaCaption extends StatelessWidget {
  final bool isFacingQibla;

  const QiblaCaption({super.key, required this.isFacingQibla});

  @override
  Widget build(BuildContext context) {
    final message =
        isFacingQibla
            ? "Anda menghadap ke arah kiblat"
            : "Putar ponsel Anda hingga panah menghadap target untuk menghadap ke arah kiblat";

    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 40, right: 40),
      child: Semantics(
        label: 'Status arah kiblat',
        value: message,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.deepPurple,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
