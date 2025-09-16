import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/data/aggregate/doa.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

class DuasScreen extends StatelessWidget {
  final Map<String, String> queryParam;

  const DuasScreen({super.key, required this.queryParam});

  @override
  Widget build(BuildContext context) {
    final categoryId = int.tryParse(queryParam['categoryId'] ?? '');
    final categoryName = queryParam['categoryName'] ?? '';

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ), // ⬅️ padding luar
        child: Column(
          children: [
            // 🔹 Topbar
            TopBarUtility.buildPurpleTitleTopbar(
              context: context,
              title: "Duas Collection",
            ),

            // 🔹 Konten utama
            Expanded(
              child: FutureBuilder<List<CompleteDuaData>>(
                future: AppDatabase().duasDao.getDuasByCategory(
                  categoryId ?? 0,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Tidak ada doa di kategori ini."),
                    );
                  }

                  final duas = snapshot.data!;
                  return ListView(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 90,
                      left: 16,
                      right: 16,
                    ), // ⬅️ aman dari bottom bar
                    children: [
                      // 🔹 Judul kategori
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            "About \n$categoryName",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff672CBC),
                            ),
                          ),
                        ),
                      ),

                      // 🔹 List Doa
                      ...duas.map((dua) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Teks Arab
                                Text(
                                  dua.ayah.ayahText,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Arab Typesetting',
                                    color: Color(0xFF3B1D77),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Divider
                                const Divider(
                                  color: Color(0xFF994EF8),
                                  thickness: 1,
                                ),
                                const SizedBox(height: 8),

                                // Arti
                                Text(
                                  dua.ayah.indoText,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF3B1D77),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Sumber Surah
                                Text(
                                  "Surah ${dua.surah?.nameLatin ?? '-'} verse ${dua.ayah.ayahNumber}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff672CBC),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Tombol aksi
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Color(0xFF3B1D77),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share,
                                        color: Color(0xFF3B1D77),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.bookmark_border,
                                        color: Color(0xFF3B1D77),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
