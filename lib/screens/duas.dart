import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/data/aggregate/doa.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
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
          child: TopBarUtility.buildDefaultTopBar(context:context, title: "Duas From Quran" ),  
        ),
        Expanded(
          child: FutureBuilder<List<CompleteDuaData>>(
            future: _futureDuas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Belum ada doa.'));
              }

              final duas = snapshot.data!;
              final List<DoaCategoryData> categories =
                  duas.map((dua) => dua.doaCategory).toSet().toList();

              final Map<DoaCategoryData, List<AyahData>> duaAyahByCategory = {
                for (var category in categories)
                  category: duas
                      .where((dua) => dua.doaCategory == category)
                      .map((dua) => dua.ayah)
                      .toList(),
              };

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return ListTile(
                          title: Text('Duas About'),
                          subtitle: Text(category.nama),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    title: Text("dua.title"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Arab:\n${"dua.doaArab"}',
                                          textAlign: TextAlign.right,
                                        ),
                                        const SizedBox(height: 8),
                                        Text('Latin:\n${"dua.doaLatin"}'),
                                        const SizedBox(height: 8),
                                        Text('Arti:\n${"dua.doaIndo"}'),
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
            },
          ),
        )
      ],
    );
  }
}
