import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/screens/surah_mushaf.dart';
import 'package:mtqmnuns/screens/surah_normal.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:provider/provider.dart';


class SurahScreen extends StatefulWidget {
  final Map<String, String> queryParam;
  const SurahScreen({super.key,required this.queryParam});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  String title = '';
  LoadType? loadType;
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final int? startSurahId = int.tryParse(widget.queryParam['startSurahId'] ?? '');
      final int? startSurahAyah = int.tryParse(widget.queryParam['startSurahAyah'] ?? '');
      final int? endSurahId = int.tryParse(widget.queryParam['endSurahId'] ?? '');
      final int? endSurahAyah = int.tryParse(widget.queryParam['endSurahAyah'] ?? '');
      final String? loadTypeParam = widget.queryParam['loadType'];

      if (loadTypeParam == 'juz') {
        loadType = LoadType.juz;
      } else if (loadTypeParam == 'surah') {
        loadType = LoadType.surah;
      }

      if (startSurahId == null || startSurahAyah == null || endSurahId == null || endSurahAyah == null || loadType == null) {
        throw ArgumentError('Invalid or missing query parameters for SurahScreen');
      }

      if (!mounted) return;
      context.read<SurahDetailViewModel>().loadSurah(
        startSurahId,
        startSurahAyah,
        endSurahId,
        endSurahAyah,
      );

      setState(() {
        title = "Reading Quran";
        isLoading = false; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: TopBarUtility.buildPurpleTitleTopbar(
            context: context,
            title: title,
          ),
        ),
        Expanded(
          child: Consumer<GlobalConfig>(
            builder: (context, config, _) {
              if (config.quranMode == QuranMode.mushaf) {
                return const MushafSurahScreen();
              } else if(config.quranMode == QuranMode.normal){
                return NormalSurahScreen(loadType: loadType!);
              } else {
                return NormalSurahScreen(loadType: loadType!, memorize: true,);
              }
            },
          ),
        ),
      ],
    );
  }
}
