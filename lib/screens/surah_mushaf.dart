import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:provider/provider.dart';

class MushafSurahScreen extends StatefulWidget {
  const MushafSurahScreen({super.key});

  @override
  State<MushafSurahScreen> createState() => _MushafSurahScreenState();
}

class _MushafSurahScreenState extends State<MushafSurahScreen> {
  int _retryCount = 0;

  void _retryLoadImage() {
    setState(() {
      _retryCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SurahViewModel>(
      builder: (context, vm, child) {
        final state = vm.state;

        switch (state) {
          case SurahLoading():
            return Center(child: CircularProgressIndicator());
          case SurahSuccess(:var ayahs):
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _buildHeader(ayahs.last),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: _buildMushaf(context, ayahs.last.page),
                    ),
                  ),
                  _buildNavigationWidget(context, ayahs.last),
                ],
              ),
            );

          case SurahError(:var message):
            return Center(child: Text("Error: $message"));
        }
      },
    );
  }

  Widget _buildHeader(AyahWithSurahDto s) {
    return roundedCard(
      allRounded: true,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Juz ${s.juzNumber}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFF994EF8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Page ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      s.page.toString().padLeft(3, '0'),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: Color(0xFF994EF8), thickness: 0.8, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${s.nameLatin} | ',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      s.nameIndo,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Text(
                s.surahName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14, // Reduced from 18
                  fontFamily: 'Al Jazeera',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMushaf(BuildContext context, int page) {
    final pageStr = page.toString().padLeft(3, '0');
    final imageUrl =
        "https://media.halonopal.space/static/mushaf/page/$pageStr.png";

    return Center(
      child: CachedNetworkImage(
        key: ValueKey('mushaf_${page}_$_retryCount'), // Unique key for retry
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Error loading data"),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _retryLoadImage,
                child: const Text(
                  "Retry",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigationWidget(BuildContext context, AyahWithSurahDto ayah) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => onNextPage(context, ayah.page),
                icon: const Icon(
                  LucideIcons.circleArrowLeft,
                  color: Colors.grey,
                  size: 36,
                ),
                label: Text(
                  'Next Page',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              TextButton.icon(
                iconAlignment: IconAlignment.end,
                onPressed: () => onPreviousPage(context, ayah.page),
                icon: const Icon(
                  LucideIcons.circleArrowRight,
                  color: Colors.grey,
                  size: 36,
                ),
                label: const Text(
                  'Previous Page',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                style: TextButton.styleFrom(foregroundColor: Colors.purple),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: roundedCard(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            allRounded: true,
            borderRadius: 100,
            child: Container(
              constraints: BoxConstraints(maxHeight: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navButton(
                    'Next Juz',
                    () => onNextJuz(context, ayah.surahNumber),
                  ),
                  _navButton('Next Surah', () => onNextSurah(context, ayah)),
                  _navButton(
                    'Previous Surah',
                    () => onPreviousSurah(context, ayah),
                  ),
                  _navButton(
                    'Previous Juz',
                    () => onPreviousJuz(context, ayah.surahNumber),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navButton(String text, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF994EF8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: AutoSizeText(
            text,
            style: const TextStyle(color: Colors.white),
            minFontSize: 8,
            maxFontSize: 20,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void onNextSurah(BuildContext context, AyahWithSurahDto ayahs) {
    final vm = context.read<SurahViewModel>();
    vm.loadAyahsInPageOf(ayahs.surahNumber + 1, 1);
    if (vm.state is SurahSuccess) {
      if ((vm.state as SurahSuccess).ayahs.last.page == ayahs.page &&
          context.mounted) {
        onNextPage(context, ayahs.page);
      }
    }
    _retryCount = 0;
  }

  void onPreviousSurah(BuildContext context, AyahWithSurahDto ayahs) {
    final vm = context.read<SurahViewModel>();
    vm.loadAyahsInPageOf(ayahs.surahNumber - 1, 1);
    if (vm.state is SurahSuccess) {
      if ((vm.state as SurahSuccess).ayahs.last.page == ayahs.page &&
          context.mounted) {
        onPreviousPage(context, ayahs.page);
      }
    }
    _retryCount = 0;
  }

  void onNextPage(BuildContext context, int currentPage) {
    context.read<SurahViewModel>().loadByPage(currentPage + 1);
    _retryCount = 0;
  }

  void onPreviousPage(BuildContext context, int currentPage) {
    context.read<SurahViewModel>().loadByPage(currentPage - 1);
    _retryCount = 0;
  }

  void onPreviousJuz(BuildContext context, int juz) {
    context.read<SurahViewModel>().loadPageByJuz(juz - 1);
    _retryCount = 0;
  }

  void onNextJuz(BuildContext context, int juz) {
    context.read<SurahViewModel>().loadPageByJuz(juz + 1);
    _retryCount = 0;
  }
}