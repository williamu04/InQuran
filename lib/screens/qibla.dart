import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/providers/location.dart';
import 'package:mtqmnuns/services/qibla.dart';
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

  @override
  void initState() {
    super.initState();
    _initQibla();
  }

  Future<void> _initQibla() async {
    try {
      double qibla = await QiblaHelper.getQiblaDirection();
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text("Error: $_error")));
    }
    // final locationProvider = context.watch<LocationProvider>();

    // if (locationProvider.loading) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    // if (locationProvider.latitude == null ||
    //     locationProvider.longitude == null) {
    //   return const Scaffold(body: Center(child: Text("Lokasi tidak tersedia")));
    // }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // batas bawah 100
        child: Column(
          children: [
            // // Location element
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   margin: const EdgeInsets.only(bottom: 16),
            //   decoration: BoxDecoration(
            //     color: Colors.blue.shade50,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Row(
            //     children: [
            //       const Icon(Icons.location_on, color: Color(0xff672CBC)),
            //       const SizedBox(width: 8),
            //       Expanded(
            //         child: Text(
            //           locationProvider.placeName ?? "Lokasi tidak tersedia",
            //           style: const TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //           ),
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: Center(
                child: StreamBuilder<CompassEvent>(
                  stream: FlutterCompass.events,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Sensor kompas tidak tersedia");
                    }
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    double deviceHeading = snapshot.data!.heading ?? 0;

                    // Hitung selisih arah (0–360)
                    double diff = (_qiblaDirection! - deviceHeading) % 360;
                    if (diff < 0) diff += 360;

                    // Sudut relatif dalam radian
                    double angle = diff * (pi / 180);

                    // Posisi ikon target di lingkaran
                    double radius = 100;
                    double x = radius * sin(angle);
                    double y = -radius * cos(angle);

                    // Normalisasi selisih terkecil (0–180)
                    double normalizedDiff = diff;
                    if (normalizedDiff > 180) {
                      normalizedDiff = 360 - normalizedDiff;
                    }

                    // Toleransi 5°
                    bool isFacingQibla = normalizedDiff < 5;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background lingkaran gradien linear 45°
                            // Glow blur di belakang lingkaran (tanpa BackdropFilter)
                            Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color(0xff240F4F),
                                    Color(0xff863ED5),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xff672CBC,
                                    ).withOpacity(0.6),
                                    blurRadius: 40, // besar blur
                                    spreadRadius: 10, // seberapa jauh menyebar
                                  ),
                                ],
                              ),
                            ),

                            Icon(
                              LucideIcons.navigation2,
                              size: 100,
                              color: Colors.white,
                            ),
                            Transform.translate(
                              offset: Offset(x, y),
                              child: const Icon(
                                LucideIcons.locateFixed,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Text(
                            isFacingQibla
                                ? "Anda sudah menghadap ke arah kiblat"
                                : "Putar ponsel Anda hingga panah menghadap target untuk menghadap ke arah kiblat",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff3B1D77),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Caption below the compass
            // const Padding(
            //   padding: EdgeInsets.only(top: 24.0),
            //   child: Text(
            //     "Putar ponsel Anda hingga panah menghadap target Anda menghadap ke arah kiblat",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Color(0xff3B1D77),
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
