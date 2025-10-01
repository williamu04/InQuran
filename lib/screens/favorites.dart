import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/data/aggregate/surah.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/dto/favorites.dart';
import 'package:mtqmnuns/state/favorites.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/viewmodel/favorites.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          children: [
            // 🔹 Topbar
            TopBarUtility.buildPurpleTitleTopbar(
              leftIcon: TopBarIconModel(
                icon: LucideIcons.arrowLeft,
                onPressed: () => context.pop(),
                color: Colors.grey,
              ),
              context: context,
              title: "Ayat Favorit",
            ),

            // 🔹 Konten utama
            Expanded(
              child: Consumer<FavoritesViewModel>(
                builder: (context, favVm, child) {
                  final state = favVm.state;

                  switch (state) {
                    case FavoritesLoadLoading():
                      return const Center(child: CircularProgressIndicator());

                    case FavoritesLoadUnauthenticated():
                      return const Center(
                        child: Text("Silakan login untuk melihat favorit."),
                      );

                    case FavoritesLoadError(:final message):
                      return Center(child: Text("Error: $message"));

                    case FavoritesLoaded(:final favorites):
                      if (favorites.isEmpty) {
                        return const Center(
                          child: Text("Belum ada ayat favorit."),
                        );
                      }

                      // 🔹 Ambil ayat dari DB lokal berdasarkan list favorites
                      return FutureBuilder<List<AyahWithSurah>>(
                        future: db.ayahDao.getAyahsFromFavorites(favorites),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text("Belum ada ayat favorit."),
                            );
                          }

                          final ayahs = snapshot.data!;
                          return ListView(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 90,
                              left: 16,
                              right: 16,
                            ),
                            children: [
                              // 🔹 Judul
                              // const Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 16.0),
                              //   child: Center(
                              //     child: Text(
                              //       "Ayat Favorit",
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(
                              //         fontSize: 36,
                              //         fontWeight: FontWeight.bold,
                              //         color: Color(0xff672CBC),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              // 🔹 List Favorit
                              ...ayahs.map((ayah) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Teks Arab
                                        Text(
                                          ayah.ayah.ayahText,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontFamily: 'Arab Typesetting',
                                            color: Color(0xFF3B1D77),
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        const Divider(
                                          color: Color(0xFF994EF8),
                                          thickness: 1,
                                        ),
                                        const SizedBox(height: 8),

                                        // Terjemahan
                                        Text(
                                          ayah.ayah.indoText,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF3B1D77),
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // Sumber Surah
                                        Text(
                                          "[QS ${ayah.surah.nameLatin} : ${ayah.ayah.ayahNumber}]",
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
                                              onPressed: () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Fitur ini akan segera hadir",
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                LucideIcons.play,
                                                color: Color(0xFF3B1D77),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Fitur ini akan segera hadir",
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                LucideIcons.share2,
                                                color: Color(0xFF3B1D77),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                final favorite = FavoriteDto(
                                                  ayah.surah.id,
                                                  ayah.ayah.ayahNumber,
                                                );

                                                final favVm =
                                                    context
                                                        .read<
                                                          FavoritesViewModel
                                                        >();
                                                final result = await favVm
                                                    .deleteFavorite(favorite);

                                                switch (result) {
                                                  case Success():
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Berhasil dihapus dari favorit",
                                                        ),
                                                      ),
                                                    );
                                                    // refresh UI
                                                    (context as Element)
                                                        .reassemble();
                                                    break;
                                                  case Failure(:final reason):
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Gagal hapus: $reason",
                                                        ),
                                                      ),
                                                    );
                                                }
                                              },
                                              icon: const Icon(
                                                LucideIcons.trash2,
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
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
