import 'package:flutter/material.dart';
import 'package:inquran/common/app_color.dart';

/// Scrollable list of voice command examples shown inside the help popup.
class VoiceCommandHelpContent extends StatelessWidget {
  const VoiceCommandHelpContent({super.key});

  static const List<String> _examples = [
    '"Buka al fatihah" — membuka surah',
    '"Al baqarah ayat 255" — membuka surah pada ayat tertentu',
    '"Buka juz tiga puluh" — membuka juz',
    '"Buka halaman dua ratus" — membuka halaman mushaf',
    '"Halaman berikutnya" / "Halaman sebelumnya"',
    '"Surah berikutnya" / "Surah sebelumnya"',
    '"Juz berikutnya" / "Juz sebelumnya"',
    '"Koleksi doa" — membuka koleksi doa',
    '"Doa sebelum tidur" — membuka kategori doa',
    '"Waktu sholat" — membuka jadwal salat',
    '"Kiblat" — membuka pencari kiblat',
    '"Daftar surah" / "Baca al quran"',
    '"Cari ayat" / "Jelajahi"',
    '"Ayat favorit"',
    '"Beranda" — kembali ke menu utama',
    '"Mode hafalan" / "Mode mushaf" / "Mode baca normal"',
    '"Putar ayat" / "Jeda" / "Lanjutkan"',
    '"Matikan mode suara" — keluar dari mode voice command',
    '"Berhenti" — menghentikan pendengaran',
  ];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final example in _examples)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.mic,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        example,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          height: 1.4,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
