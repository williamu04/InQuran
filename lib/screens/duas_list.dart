import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/navigation.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

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
  late Future<List<DoaCategoryData>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _futureCategories = _db.duasDao.getDuasCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        roundedCard(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: TopBarUtility.buildDefaultTopBar(
            context: context,
            title: "Koleksi Doa-Doa",
          ),
        ),
        Expanded(
          child: FutureBuilder<List<DoaCategoryData>>(
            future: _futureCategories,
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

              final categories = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return DuaCategoryCard(
                    category: categories[index],
                    index: index,
                    onTap:
                        () => navigateToDuaCategory(context, categories[index]),
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

/// 🔹 Widget terpisah untuk 1 item kategori doa
class DuaCategoryCard extends StatelessWidget {
  final DoaCategoryData category;
  final int index;
  final VoidCallback onTap;

  const DuaCategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  Color _getBackgroundColor(int index) {
    final rowIndex = index ~/ 2;
    return rowIndex % 2 == 0
        ? const Color(0xff672CBC)
        : const Color(0xff3B1D77);
  }

  IconData _getIcon(int index) {
    return index < duaCategoryIcons.length
        ? duaCategoryIcons[index]
        : LucideIcons.book;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(index);
    final iconData = _getIcon(index);

    return Semantics(
      label: "Kategori doa: ${category.nama}",
      hint: "Ketuk dua kali untuk membuka doa tentang ${category.nama}",
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 6),
              Icon(iconData, color: Colors.white, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ExcludeSemantics(
                      // ⛔ teks dekoratif tidak dibaca TalkBack
                      child: Text(
                        "Doa tentang",
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.nama,
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
      ),
    );
  }
}
