import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:inquran/common/navigation.dart';
import 'package:inquran/components/top_bar_utils.dart';
import 'package:inquran/components/rounded_card.dart';
import 'package:inquran/data/local/db/app_database.dart';
import 'package:inquran/state/doa.dart';
import 'package:inquran/viewmodel/doa.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

class DoaListScreen extends StatefulWidget {
  const DoaListScreen({super.key});

  @override
  State<DoaListScreen> createState() => _DoaListScreenState();
}

final List<IconData> doaCategoryIcons = [
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

class _DoaListScreenState extends State<DoaListScreen> {
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
          child: Consumer<DoaListViewModel>(
            builder: (context, vm, _) {
              return switch (vm.state) {
                DoaListLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                DoaListError(:final message) => Center(
                  child: Text('Terjadi kesalahan: $message'),
                ),
                DoaListEmpty() => const Center(child: Text('Belum ada doa.')),
                DoaListSuccess(:final categories) => GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return DoaCategoryCard(
                      category: categories[index],
                      index: index,
                      onTap:
                          () => navigateToDoaCategory(context, categories[index]),
                    );
                  },
                ),
              };
            },
          ),
        ),
      ],
    );
  }
}

/// 🔹 Widget terpisah untuk 1 item kategori doa
class DoaCategoryCard extends StatelessWidget {
  final DoaCategoryData category;
  final int index;
  final VoidCallback onTap;

  const DoaCategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  Color _getBackgroundColor(int index) {
    final rowIndex = index ~/ 2;
    return rowIndex % 2 == 0
        ? AppColors.primary
        : AppColors.deepPurple;
  }

  IconData _getIcon(int index) {
    return index < doaCategoryIcons.length
        ? doaCategoryIcons[index]
        : LucideIcons.book;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(index);
    final iconData = _getIcon(index);

    return Semantics(
      label: "Kategori doa: ${category.nama}",
      hint: "Ketuk doa kali untuk membuka doa tentang ${category.nama}",
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
