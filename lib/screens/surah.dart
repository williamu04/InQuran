import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


class SurahScreen extends StatefulWidget {
  final int? surahId;
  final String? surahName;
  const SurahScreen({super.key, this.surahId, this.surahName});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SurahDetailViewModel>().loadSurah(widget.surahId);
    });
  }

  @override
  void didUpdateWidget(covariant SurahScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahId != widget.surahId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SurahDetailViewModel>().loadSurah(widget.surahId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: TopBarUtility.buildPurpleTitleTopbar(context:context, title: "Reading ${widget.surahName ?? ''}"),
        ),
        Expanded(
          child: Consumer<GlobalConfig>(
          builder: (context, config, _) {
            if (config.quranMode == QuranMode.mushaf) {
              return const MushafSurahScreen();
            } else {
              return const NormalSurahScreen();
            }
          },
        )
        )
      ],
    ) ;
  }
}


class NormalSurahScreen extends StatelessWidget {
  const NormalSurahScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<SurahDetailViewModel>(
      builder: (context, vm, child) {
        final state = vm.state;

        switch (state) {
          case SurahLoading():
            return Center(child: CircularProgressIndicator());
          case SurahError(:var message):
            return Center(child: Text("Error: $message")); 
          case SurahSuccess(:var surahWithAyahData):
            return _buildSurah(surahWithAyahData);
        }
      },
    );
  }

  Widget _buildSurah(SurahWithAyahDto surahWithAyahs) {
    final ayahList = surahWithAyahs.ayahs;

    return ListView.builder(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 64),
      itemCount: ayahList.length + 1, // +1 untuk header di atas
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SurahHeaderCard(
              name: surahWithAyahs.arabname,
              nameLatin: surahWithAyahs.nameLatin,
              nameIndo: surahWithAyahs.nameIndo,
              showBasmallah: surahWithAyahs.number != 1 && surahWithAyahs.number != 9,
            ),
          );
        }

        final ayah = ayahList[index - 1]; // karena index 0 dipakai untuk header

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ayah Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF672CBC),
                        radius: 16,
                        child: Text(
                          '${ayah.number}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(LucideIcons.play),
                        iconSize: 20,
                        color: const Color(0xFF672CBC),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.share),
                        iconSize: 20,
                        color: const Color(0xFF672CBC),
                        onPressed: () {
                          final text =
                              'Surah ${surahWithAyahs.nameLatin}, Ayat ${ayah.number}:\n\n'
                              '${ayah.arabText}\n\n${ayah.translationText}';
                          SharePlus.instance.share(ShareParams(text: text));
                        },
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.bookmark),
                        iconSize: 20,
                        color: const Color(0xFF672CBC),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ayah.arabText,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3B1D77),
                      fontFamily: 'Arab Typesetting',
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  ayah.translationText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3B1D77),
                  ),
                ),
                const SizedBox(height: 8.0),
                Divider(color: Colors.grey.shade400, thickness: 0.8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SurahHeaderCard extends StatelessWidget {
  final String nameLatin;
  final String name;
  final String nameIndo;
  final bool showBasmallah;

  const SurahHeaderCard({
    super.key,
    required this.nameLatin,
    required this.name,
    required this.nameIndo,
    this.showBasmallah = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF994EF8), Color(0xFF240F4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Latin Name & Arabic Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Kolom: Latin + Indo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameLatin,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 4),
                      Text(
                        nameIndo,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
    
                // Nama Arab
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Al Jazeera',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(thickness: 0.5, color: Color(0xFF994EF8)),
            const SizedBox(height: 16),

            // Basmallah
            if (showBasmallah)
              Center(
                child: Image.asset(
                  'assets/img/basmala.png',
                  height: 64, // sesuaikan ukuran
                  fit: BoxFit.contain,
                ),
              ),

          ],
        ),
      ),
    );
  }
}


class MushafSurahScreen extends StatelessWidget {
  const MushafSurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SurahDetailViewModel>(
      builder: (context, vm, child) {
        final state = vm.state;

        switch (state) {
          case SurahLoading():
            return Center(child: CircularProgressIndicator());
          case SurahError(:var message):
            return Center(child: Text("Error: $message")); 
          case SurahSuccess(:var surahWithAyahData):
            return _buildSurah(surahWithAyahData);
        }
      },
    );
  }

  Widget _buildSurah(SurahWithAyahDto s) {
    return Padding(
      padding: EdgeInsetsGeometry.only(
        left: 20,
        right: 20,
        bottom: 107,
      ),
      child: Column(
        children: [
          _buildHeader(s),
          Expanded(child:_buildMushaf())
        ],
      ),
    );
  }

  Widget _buildHeader(SurahWithAyahDto s) {
    return roundedCard(
      allRounded: true,
      padding: EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Juz 1",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xFF994EF8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      "Page ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "001",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: Color(0xFF994EF8), thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${s.nameLatin} | ',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    s.nameIndo,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Text(
                s.arabname,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Al Jazeera',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMushaf() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        debugPrint("Mushaf size → width: $width, height: $height");

        return Container(
          color: Colors.blue,
          width: width,
          height: height,
        );
      },
    ),
    );
  }

  
}
