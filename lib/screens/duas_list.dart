import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/navigation.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/data/aggregate/doa.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/common/translator.dart';

class DuasListScreen extends StatefulWidget {
  const DuasListScreen({super.key});

  @override
  State<DuasListScreen> createState() => _DuasListScreenState();
}

final List<IconData> duaCategoryIcons = [
  LucideIcons.baby,
  LucideIcons.moonStar,
  LucideIcons.signpostBig,
  LucideIcons.heartPlus,
  LucideIcons.doorOpen,
  LucideIcons.gem,
  LucideIcons.heartHandshake,
  LucideIcons.clover,
  LucideIcons.smilePlus,
  LucideIcons.shieldCheck,
  LucideIcons.key,
  LucideIcons.handshake,
  LucideIcons.bed,
  LucideIcons.bicepsFlexed,
];

class _DuasListScreenState extends State<DuasListScreen> {
  late final AppDatabase _db;
  late Future<List<CompleteDuaData>> _futureDuas;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase(); // langsung inisialisasi database
    _futureDuas = _db.duasDao.getAllCompleteDuas(); // ambil data
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        roundedCard(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: TopBarUtility.buildDefaultTopBar(
            context: context,
            title: "Koleksi Doa-Doa",
          ),
        ),
        Expanded(
          child: FutureBuilder<List<CompleteDuaData>>(
            future: _futureDuas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Belum ada doa.'));
              }

              final duas = snapshot.data!;
              final List<DoaCategoryData> categories =
                  duas.map((dua) => dua.doaCategory).toSet().toList();

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2, // biar proporsional
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  final rowIndex = index ~/ 2;
                  final bgColor =
                      rowIndex % 2 == 0
                          ? const Color(0xff672CBC)
                          : const Color(0xff3B1D77);

                  final iconData =
                      index < duaCategoryIcons.length
                          ? duaCategoryIcons[index]
                          : LucideIcons
                              .book; // fallback kalau list kurang panjang

                  return GestureDetector(
                    onTap: () {
                      navigateToDuaCategory(context, category);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ICON kiri
                          const SizedBox(width: 6),
                          Icon(
                            iconData,
                            color: Colors.white,
                            size: 36, // biar proporsional 2 baris teks
                          ),
                          const SizedBox(width: 12),

                          // TEKS kanan (2 baris)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Doa tentang",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  terjemahkanKategori(category.nama),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
