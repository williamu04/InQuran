import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:inquran/components/top_bar_utils.dart';
import 'package:inquran/data/aggregate/surah.dart';
import 'package:inquran/dto/favorites.dart';
import 'package:inquran/state/favorites.dart';
import 'package:inquran/state/success_or_fail.dart';
import 'package:inquran/viewmodel/favorites.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      namesRoute: true,
      label: 'Ayat Favorit',
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            children: [
              const FavoriteAppBar(),
              Expanded(
                child: Consumer<FavoritesViewModel>(
                  builder: (context, favVm, _) {
                    return switch (favVm.state) {
                      FavoritesLoadLoading() => Semantics(
                        liveRegion: true,
                        label: 'Memuat ayat favorit',
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      FavoritesLoadError(:final message) => Semantics(
                        liveRegion: true,
                        child: _Message(
                          text: "Terjadi kesalahan: $message",
                        ),
                      ),
                      FavoritesLoaded(:final ayahs) =>
                        ayahs.isEmpty
                            ? Semantics(
                              liveRegion: true,
                              child: const _Message(
                                text: "Belum ada ayat favorit.",
                              ),
                            )
                            : FavoriteList(ayahs: ayahs),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteAppBar extends StatelessWidget {
  const FavoriteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TopBarUtility.buildPurpleTitleTopbar(
      leftIcon: TopBarIconModel(
        icon: LucideIcons.arrowLeft,
        onPressed: () => context.pop(),
        color: Colors.grey,
        semanticLabel: 'Kembali',
      ),
      context: context,
      title: "Ayat Favorit",
    );
  }
}

class FavoriteList extends StatelessWidget {
  final List<AyahWithSurah> ayahs;
  const FavoriteList({super.key, required this.ayahs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 90, left: 4, right: 4),
      itemCount: ayahs.length,
      itemBuilder: (_, i) => FavoriteCard(ayah: ayahs[i]),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final AyahWithSurah ayah;
  const FavoriteCard({super.key, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final favVm = context.read<FavoritesViewModel>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks Arab (dikecualikan dari TalkBack, terjemahan yang dibacakan)
            ExcludeSemantics(
              child: Text(
                ayah.ayah.ayahText,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 32,
                  fontFamily: 'Arab Typesetting',
                  color: AppColors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 8),

            const Divider(color: AppColors.primaryLight, thickness: 1),
            const SizedBox(height: 8),

            // Terjemahan
            Text(
              ayah.ayah.indoText,
              style: const TextStyle(fontSize: 12, color: AppColors.deepPurple),
            ),
            const SizedBox(height: 8),

            // Sumber Surah
            Text(
              "[QS ${ayah.surah.nameLatin} : ${ayah.ayah.ayahNumber}]",
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
            ),

            const SizedBox(height: 12),

            // Tombol aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionIcon(
                  icon: LucideIcons.play,
                  semanticLabel: 'Putar ayat ${ayah.ayah.ayahNumber}',
                  onPressed: () => _showComingSoon(context),
                ),
                _ActionIcon(
                  icon: LucideIcons.share2,
                  semanticLabel: 'Bagikan ayat ${ayah.ayah.ayahNumber}',
                  onPressed: () => _showComingSoon(context),
                ),
                _ActionIcon(
                  icon: LucideIcons.trash2,
                  semanticLabel: 'Hapus ayat ${ayah.ayah.ayahNumber} dari favorit',
                  onPressed: () async {
                    final favorite = FavoriteDto(
                      ayah.surah.id,
                      ayah.ayah.ayahNumber,
                    );
                    final result = await favVm.deleteFavorite(favorite);
                    if (!context.mounted) return;
                    switch (result) {
                      case Success():
                        _showSnack(context, "Berhasil dihapus dari favorit");
                        break;
                      case Failure(:final reason):
                        _showSnack(context, "Gagal hapus: $reason");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;
  const _ActionIcon({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: semanticLabel,
      icon: Icon(icon, color: AppColors.deepPurple),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;
  const _Message({required this.text});

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(text, textAlign: TextAlign.center));
}

void _showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

void _showComingSoon(BuildContext context) {
  _showSnack(context, "Fitur ini akan segera hadir");
}
