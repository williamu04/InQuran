import 'package:flutter/material.dart';
import 'package:inquran/common/navigation.dart';
import 'package:inquran/components/tab_button.dart';
import 'package:inquran/components/top_bar_utils.dart';
import 'package:inquran/components/search_box.dart';
import 'package:inquran/dto/juz.dart';
import 'package:inquran/dto/surah.dart';
import 'package:inquran/state/surah_list.dart';
import 'package:inquran/viewmodel/surah_list.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      namesRoute: true,
      label: "Baca Al-Qur'an",
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            TopBarUtility.buildPurpleTitleTopbar(
              context: context,
              title: "Baca Al-Qur'an",
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SearchBox(),
                    const SizedBox(height: 20),
                    Expanded(child: SurahListContentWidget()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahListContentWidget extends StatefulWidget {
  const SurahListContentWidget({super.key});

  @override
  State<SurahListContentWidget> createState() => _SurahListContentWidgetState();
}

class _SurahListContentWidgetState extends State<SurahListContentWidget> {
  final ScrollController _surahScrollController = ScrollController();
  final ScrollController _juzScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SurahListViewModel>();

    return Column(
      children: [
        _buildTabNavigation(viewModel),
        Expanded(child: _buildTabContent()),
      ],
    );
  }

  Widget _buildTabNavigation(SurahListViewModel viewModel) {
    return Consumer<SurahListViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Expanded(
              child: TabButton(
                label: 'Surah',
                isActive: viewModel.contentType == SurahContentType.surah,
                onTap: () => viewModel.setContentType(SurahContentType.surah),
              ),
            ),
            Expanded(
              child: TabButton(
                label: 'Juz',
                isActive: viewModel.contentType == SurahContentType.juz,
                onTap: () => viewModel.setContentType(SurahContentType.juz),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabContent() {
    return Consumer<SurahListViewModel>(
      builder: (context, viewModel, child) {
        switch (viewModel.state) {
          case SurahListLoading():
            return Semantics(
              liveRegion: true,
              label: 'Memuat daftar surah',
              child: const Center(child: CircularProgressIndicator()),
            );
          case SurahListError(:var message):
            return Semantics(
              liveRegion: true,
              child: Center(child: Text("Terjadi kesalahan: $message")),
            );
          case SurahListSuccessTypeSurah(:var surahs):
            return SingleChildScrollView(
              controller: _surahScrollController,
              child: _buildSurahList(context, surahs),
            );
          case SurahListSuccessTypeJuz(:var juz):
            return SingleChildScrollView(
              controller: _juzScrollController,
              child: _buildJuzList(juz),
            );
          case SurahListSuccessEmpty():
            return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Semantics(
                liveRegion: true,
                child: Text("Tidak ditemukan."),
              ),
            );
        }
      },
    );
  }

  Widget _buildSurahList(BuildContext context, List<SurahInfoDto> surahList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 90, top: 12),
      itemCount: surahList.length,
      itemBuilder: (context, index) {
        final surah = surahList[index];
        return _buildSurahListItem(context, surah);
      },
    );
  }

  Widget _buildSurahListItem(BuildContext context, SurahInfoDto surah) {
    return Column(
      children: [
        Semantics(
          button: true,
          label:
              'Surah ${surah.nameLatin}, ${surah.place}, ${surah.totalAyah} ayat',
          hint: 'Ketuk dua kali untuk membuka surah ${surah.nameLatin}',
          excludeSemantics: true,
          child: InkWell(
            onTap: () => navigateToSurah(context, surah),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  _buildSurahNumberIcon(surah.number),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSurahInfo(surah)),
                  _buildArabicName(surah.name),
                ],
              ),
            ),
          ),
        ),
        Divider(color: Colors.grey[300], height: 1, thickness: 1),
      ],
    );
  }

  Widget _buildSurahNumberIcon(int surahNumber) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/img/star.png',
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              color: AppColors.primary,
            ),
            Text(
              '$surahNumber',
              style: const TextStyle(
                color: AppColors.deepPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahInfo(SurahInfoDto surah) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          surah.nameLatin,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.deepPurple,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              surah.place,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const Text(
              ' • ',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            Text(
              '${surah.totalAyah} Ayat',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArabicName(String arabicName) {
    return Text(
      arabicName,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Al Jazeera',
      ),
    );
  }

  Widget _buildJuzList(List<JuzInfoDto> juzList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 90, top: 12),
      itemCount: juzList.length,
      itemBuilder: (context, index) {
        final juz = juzList[index];
        return _buildJuzListItem(juz);
      },
    );
  }

  Widget _buildJuzListItem(JuzInfoDto juzInfo) {
    final isSameSurah = juzInfo.startSurahName == juzInfo.endSurahName;

    final String rangeLabel =
        isSameSurah
            ? '${juzInfo.startSurahName}, ayat ${juzInfo.startAyahNumber} sampai ${juzInfo.endAyahNumber}'
            : '${juzInfo.startSurahName} ayat ${juzInfo.startAyahNumber}, sampai ${juzInfo.endSurahName} ayat ${juzInfo.endAyahNumber}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Semantics(
        button: true,
        label: 'Juz ${juzInfo.juzNumber}, $rangeLabel',
        hint: 'Ketuk dua kali untuk membuka juz ${juzInfo.juzNumber}',
        excludeSemantics: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            navigateToJuz(context, juzInfo);
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJuzHeader(juzInfo),
                const SizedBox(height: 16.0),
                if (isSameSurah)
                  _buildSameSurahRange(juzInfo)
                else
                  _buildMultipleSurahRange(juzInfo),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJuzHeader(JuzInfoDto juzInfo) {
    return Row(
      children: [
        ExcludeSemantics(
          child: SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/img/star.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                Text(
                  '${juzInfo.juzNumber}',
                  style: const TextStyle(
                    color: AppColors.deepPurple,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Text(
          'Juz ${juzInfo.juzNumber}',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSameSurahRange(JuzInfoDto juzInfo) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              juzInfo.startSurahName,
              style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
            ),
            Text(
              'Ayat ${juzInfo.startAyahNumber} - ${juzInfo.endAyahNumber}',
              style: const TextStyle(fontSize: 12.0, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Divider(color: Colors.grey.shade300, thickness: 1.0),
      ],
    );
  }

  Widget _buildMultipleSurahRange(JuzInfoDto juzInfo) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              juzInfo.startSurahName,
              style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
            ),
            Text(
              'Ayat ${juzInfo.startAyahNumber} - ${juzInfo.startSurahTotalAyah}',
              style: const TextStyle(fontSize: 12.0, color: AppColors.primary),
            ),
          ],
        ),
        Divider(color: Colors.grey.shade300, thickness: 0.6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              juzInfo.endSurahName,
              style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
            ),
            Text(
              'Ayat 1 - ${juzInfo.endAyahNumber}',
              style: const TextStyle(fontSize: 12.0, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Divider(color: Colors.grey.shade400, thickness: 0.8),
      ],
    );
  }

  @override
  void dispose() {
    _surahScrollController.dispose();
    _juzScrollController.dispose();
    super.dispose();
  }
}
