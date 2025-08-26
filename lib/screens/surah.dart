import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/models/surah.dart';
import 'package:share_plus/share_plus.dart';

class SurahScreen extends StatelessWidget {
  const SurahScreen({super.key, required this.state});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final surahId = int.tryParse(state.uri.queryParameters['id'] ?? '');

    return FutureBuilder<SurahWithAyahs?>(
      future: AppDatabase().surahDao.getSurahWithAyahs(surahId ?? 1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } 

        if (!snapshot.hasData) {
          return Center(child: Text('No data found for Surah $surahId'));
        }

        final data = snapshot.data;

        final surah = data?.surah;
        final ayahList = data?.ayahs;

        if (surah == null || ayahList == null || ayahList.isEmpty) {
          return Center(child: Text('No Ayahs found for Surah $surahId'));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 64),
          itemCount: ayahList.length + 1, // +1 untuk header di atas
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SurahHeaderCard(
                  name: surah.name,
                  nameLatin: surah.nameLatin,
                  nameIndo: surah.nameIndo,
                  showBasmallah: surah.id != 1 && surah.id != 9,
                ),
              );
            }

            final ayah =
                ayahList[index - 1]; // karena index 0 dipakai untuk header

            return Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ayah Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F9FE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF672CBC),
                            radius: 16,
                            child: Text(
                              '${ayah.ayahNumber}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(LucideIcons.play),
                            iconSize: 20,
                            color: const Color(0xFF672CBC),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.share),
                            iconSize: 20,
                            color: const Color(0xFF672CBC),
                            onPressed: () {
                              final text =
                                  'Surah ${surah.nameLatin}, Ayat ${ayah.ayahNumber}:\n\n'
                                  '${ayah.ayahText}\n\n${ayah.indoText}';
                              SharePlus.instance.share(ShareParams(text: text));
                            },
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.bookmark),
                            iconSize: 20,
                            color: const Color(0xFF672CBC),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ayah.ayahText,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF3B1D77),
                          fontFamily: 'Arab Typesetting',
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ayah.indoText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3B1D77),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Divider(color: Colors.grey.shade400, thickness: 0.8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


class SurahHeaderCard extends StatelessWidget {
  final String nameLatin;
  final String name;
  final String nameIndo;
  final bool showBasmallah;

  const SurahHeaderCard({
    super.key,
    required this.nameLatin,
    required this.name,
    required this.nameIndo,
    this.showBasmallah = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF994EF8), Color(0xFF240F4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Latin Name & Arabic Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Kolom: Latin + Indo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameLatin,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 4),
                      Text(
                        nameIndo,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
    
                // Nama Arab
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Al Jazeera',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(thickness: 0.5, color: Color(0xFF994EF8)),
            const SizedBox(height: 16),

            // Basmallah
            if (showBasmallah)
              Center(
                child: Image.asset(
                  'assets/img/basmala.png',
                  height: 64, // sesuaikan ukuran
                  fit: BoxFit.contain,
                ),
              ),

          ],
        ),
      ),
    );
  }
}
