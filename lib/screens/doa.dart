import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:inquran/components/top_bar_utils.dart';
import 'package:inquran/components/rounded_card.dart';
import 'package:inquran/common/translator.dart';
import 'package:inquran/data/aggregate/doa.dart';
import 'package:inquran/state/doa.dart';
import 'package:inquran/viewmodel/doa.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

class DoaScreen extends StatefulWidget {
  final Map<String, String> queryParam;

  const DoaScreen({super.key, required this.queryParam});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  late final int categoryId;
  late final String categoryName;

  @override
  void initState() {
    super.initState();
    categoryId = int.tryParse(widget.queryParam['categoryId'] ?? '') ?? 0;
    categoryName = widget.queryParam['categoryName'] ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoaDetailViewModel>().loadDoas(categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          children: [
            // Topbar
            roundedCard(
              child: TopBarUtility.buildPurpleTitleTopbar(
                leftIcon: TopBarIconModel(
                  icon: LucideIcons.arrowLeft,
                  onPressed: () => context.pop(),
                  color: Colors.grey,
                ),
                context: context,
                title: "Koleksi Doa-Doa",
              ),
            ),

            // Konten utama
            Expanded(
              child: Consumer<DoaDetailViewModel>(
                builder: (context, vm, _) {
                  return switch (vm.state) {
                    DoaDetailLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    DoaDetailError(:final message) => Center(
                      child: Text("Terjadi kesalahan: $message"),
                    ),
                    DoaDetailEmpty() => const Center(
                      child: Text("Tidak ada doa di kategori ini."),
                    ),
                    DoaDetailSuccess(:final doas) => ListView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
                      children: [
                        // Judul kategori
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              "Tentang\n${terjemahkanKategori(categoryName)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        // List Doa
                        ...doas.map((doa) => DoaCard(doa: doa)),
                      ],
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Widget DoaCard terpisah (lebih maintainable + accessible)
class DoaCard extends StatelessWidget {
  final CompleteDoaData doa;

  const DoaCard({super.key, required this.doa});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          "Doa dari surah ${doa.surah?.nameLatin ?? ''}, ayat ${doa.ayah.ayahNumber}.",
      hint:
          "Geser untuk membaca terjemahan. Gunakan tombol play untuk mendengarkan.",
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Teks Arab
              ExcludeSemantics(
                child: Text(
                  doa.ayah.ayahText,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 28,
                    fontFamily: 'Arab Typesetting',
                    color: AppColors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 🔹 Divider
              const Divider(color: AppColors.primaryLight, thickness: 1),
              const SizedBox(height: 8),

              // 🔹 Terjemahan (dibaca TalkBack)
              Text(
                doa.ayah.indoText,
                style: const TextStyle(fontSize: 12, color: AppColors.deepPurple),
              ),
              const SizedBox(height: 8),

              // 🔹 Sumber surah
              Text(
                "[QS ${doa.surah?.nameLatin ?? ''} : ${doa.ayah.ayahNumber}]",
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
              const SizedBox(height: 12),

              // 🔹 Tombol aksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    tooltip: "Putar doa ini",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fitur ini akan segera hadir"),
                        ),
                      );
                    },
                    icon: const Icon(
                      LucideIcons.play,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  IconButton(
                    tooltip: "Bagikan doa ini",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fitur ini akan segera hadir"),
                        ),
                      );
                    },
                    icon: const Icon(
                      LucideIcons.share2,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  IconButton(
                    tooltip: "Tambahkan ke favorit",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fitur ini akan segera hadir"),
                        ),
                      );
                    },
                    icon: const Icon(
                      LucideIcons.heart,
                      color: AppColors.deepPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
