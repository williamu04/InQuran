import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/navigation.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/data/aggregate/doa.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

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

class DuasListScreen extends StatefulWidget {
  const DuasListScreen({super.key});

  @override
  State<DuasListScreen> createState() => _DuasListScreenState();
}

class _DuasListScreenState extends State<DuasListScreen> {
  late final AppDatabase _db;
  late Future<List<DoaCategoryData>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _futureCategories = _db.duasDao.getDistinctCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        roundedCard(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: TopBarUtility.buildDefaultTopBar(
            context: context,
            title: "Duas From Quran",
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
              return DuaCategoryGrid(categories: categories);
            },
          ),
        ),
      ],
    );
  }
}

/// --- GRID WIDGET ---
class DuaCategoryGrid extends StatelessWidget {
  final List<DoaCategoryData> categories;

  const DuaCategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
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
        return DuaCategoryCard(category: categories[index], index: index);
      },
    );
  }
}

/// --- CARD WIDGET ---
class DuaCategoryCard extends StatelessWidget {
  final DoaCategoryData category;
  final int index;

  const DuaCategoryCard({
    super.key,
    required this.category,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final rowIndex = index ~/ 2;
    final bgColor =
        rowIndex % 2 == 0 ? const Color(0xff672CBC) : const Color(0xff3B1D77);

    final iconData =
        index < duaCategoryIcons.length
            ? duaCategoryIcons[index]
            : LucideIcons.book;

    return GestureDetector(
      onTap: () => navigateToDuaCategory(context, category),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
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
                  const Text(
                    "Duas About",
                    style: TextStyle(color: Colors.white70, fontSize: 10),
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
    );
  }
}
