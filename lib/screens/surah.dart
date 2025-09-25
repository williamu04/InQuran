import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/screens/surah_mushaf.dart';
import 'package:mtqmnuns/screens/surah_normal.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:provider/provider.dart';
import 'package:mtqmnuns/services/accessibility.dart';

class SurahScreen extends StatefulWidget {
  final Map<String, String> queryParam;
  const SurahScreen({super.key, required this.queryParam});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  String title = '';
  LoadType? loadType;
  bool isLoading = true;
  bool _announced = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final int? startSurahId = int.tryParse(
        widget.queryParam['startSurahId'] ?? '',
      );
      final int? startSurahAyah = int.tryParse(
        widget.queryParam['startSurahAyah'] ?? '',
      );
      final int? endSurahId = int.tryParse(
        widget.queryParam['endSurahId'] ?? '',
      );
      final int? endSurahAyah = int.tryParse(
        widget.queryParam['endSurahAyah'] ?? '',
      );
      final String? loadTypeParam = widget.queryParam['loadType'];

      if (loadTypeParam == 'juz') {
        loadType = LoadType.juz;
      } else if (loadTypeParam == 'surah') {
        loadType = LoadType.surah;
      }

      if (startSurahId == null ||
          startSurahAyah == null ||
          endSurahId == null ||
          endSurahAyah == null ||
          loadType == null) {
        throw ArgumentError(
          'Invalid or missing query parameters for SurahScreen',
        );
      }

      if (!mounted) return;
      final quranMode = context.read<GlobalConfig>().quranMode;
      if (quranMode == QuranMode.normal || quranMode == QuranMode.memorize) {
        context.read<SurahDetailViewModel>().loadSurah(
          startSurahId,
          startSurahAyah,
          endSurahId,
          endSurahAyah,
        );
      }

      setState(() {
        title = "Membaca Al-Qur'an";
        isLoading = false;
      });

      // Announce surah name after data loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _announced) return;
        final vm = context.read<SurahDetailViewModel>();
        if (vm.state is SurahSuccess) {
          final success = vm.state as SurahSuccess;
          if (success.ayahs.isNotEmpty) {
            final nameLatin = success.ayahs.first.nameLatin;
            setState(() {
              title = 'Surat $nameLatin';
            });
            try {
              final acc = context.read<AccessibilityService>();
              acc.announce(context, 'Halaman surat $nameLatin');
              _announced = true;
            } catch (_) {}
          }
        }
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
            leftIcon: TopBarIconModel(
              icon: LucideIcons.arrowLeft,
              onPressed: () => context.pop(),
              color: Colors.grey,
            ),
            context: context,
            title: title,
          ),
        ),
        Expanded(
          child: Consumer<GlobalConfig>(
            builder: (context, config, _) {
              if (config.quranMode == QuranMode.mushaf) {
                return const MushafSurahScreen();
              } else if (config.quranMode == QuranMode.normal) {
                return NormalSurahScreen(loadType: loadType!);
              } else {
                return NormalSurahScreen(loadType: loadType!, memorize: true);
              }
            },
          ),
        ),
      ],
    );
  }
}
