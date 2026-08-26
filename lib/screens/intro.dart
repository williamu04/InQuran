import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inquran/config/global.dart';
import 'package:inquran/routes/route.dart';
import 'package:inquran/common/app_color.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Logo dengan deskripsi TalkBack
            Semantics(
              label: "Logo aplikasi InQuran",
              child: Container(
                margin: const EdgeInsets.only(bottom: 32.0),
                child: Image.asset(
                  'assets/img/logoSplashScreen.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Judul aplikasi
            Semantics(
              header: true,
              label: "Judul aplikasi",
              child: Text(
                'InQuran',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Slogan
            Semantics(
              label: "Slogan aplikasi",
              child: Text(
                'Suarakan Niat\nDengarkan Ayat\nDekap Hidayah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDark,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Deskripsi kutipan
            Semantics(
              label:
                  'Kutipan motivasi: Read and Understand The Meaning of The Holy Verses Easily, Anytime and Anywhere.',
              child: Text(
                '"Read and Understand\nThe Meaning of The Holy Verses Easily,\nAnytime and Anywhere."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.3,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol mulai membaca
                Semantics(
                  button: true,
                  label: "Mulai membaca Al-Qur'an dalam mode biasa",
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        final isFirst = GlobalConfig().isFirstLaunch;
                        if (isFirst) {
                          await GlobalConfig().markLaunched(
                            isDisabilityMode: false,
                          );
                        }
                        if (!context.mounted) return;
                        context.go(AppRoutes.home.path);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Mulai Membaca',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Tombol mode voice command
                Semantics(
                  button: true,
                  label:
                      "Masuk ke mode voice command, cocok untuk pengguna dengan gangguan penglihatan",
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () async {
                        final isFirst = GlobalConfig().isFirstLaunch;
                        if (isFirst) {
                          await GlobalConfig().markLaunched(
                            isDisabilityMode: true,
                          );
                        }
                        if (!context.mounted) return;
                        context.go(AppRoutes.home.path);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Mode Voice Command',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
