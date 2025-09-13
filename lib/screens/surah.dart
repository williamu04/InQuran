import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/screens/surah_mushaf.dart';
import 'package:mtqmnuns/screens/surah_normal.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:provider/provider.dart';


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

