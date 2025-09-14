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

  @override
  void initState() {
    super.initState();
      Future.microtask(() {
        final int? startSurahId = int.tryParse(widget.queryParam['startSurahId'] ?? '');
        final int? startSurahAyah = int.tryParse(widget.queryParam['startSurahAyah'] ?? '');
        final int? endSurahId = int.tryParse(widget.queryParam['endSurahId'] ?? '');
        final int? endSurahAyah = int.tryParse(widget.queryParam['endSurahAyah'] ?? '');
        final String? loadType = widget.queryParam['loadType'];
        if (loadType == 'juz') {
          this.loadType = LoadType.juz;
        } else if (loadType == 'surah') {
          this.loadType = LoadType.surah;
        }
        if (startSurahId == null || startSurahAyah == null || endSurahId == null || endSurahAyah == null) {
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
      });
    });
  }

  void changeTitle(String newTitle) {
    if (!mounted) return;
    setState(() {
      title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lt = loadType;
    if (lt == null) {
      return Text("Load Type Parameter are required");
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
              } else {
                return NormalSurahScreen(loadType: lt);
              }
            },
          ),
        ),
      ],
    );
  }
}
