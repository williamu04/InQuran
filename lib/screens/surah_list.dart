import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/navigation.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/search_box.dart';
import 'package:mtqmnuns/dto/juz.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/state/surah_list.dart';
import 'package:mtqmnuns/viewmodel/surah_list.dart';
import 'package:provider/provider.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        children: [
          TopBarUtility.buildPurpleTitleTopbar(context:context, title: "The Holy Quran"),  
          Expanded( 
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  SearchBox(),
                  const SizedBox(height: 20),
                  Expanded( 
                    child: SurahListContentWidget(),
                  ),
                ],
              ),
            ),
          )
        ],
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
        Expanded( 
          child: _buildTabContent(),
        ),
      ],
    );
  }

  Widget _buildTabNavigation(SurahListViewModel viewModel) {
    return Consumer<SurahListViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Expanded(
              child: _buildTabButton(
                label: 'Surah',
                contentType: SurahContentType.surah,
                isActive: viewModel.contentType == SurahContentType.surah,
                onTap: () => viewModel.setContentType(SurahContentType.surah),
              ),
            ),
            Expanded(
              child: _buildTabButton(
                label: 'Juz',
                contentType: SurahContentType.juz,
                isActive: viewModel.contentType == SurahContentType.juz,
                onTap: () => viewModel.setContentType(SurahContentType.juz),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabButton({
    required String label,
    required SurahContentType contentType,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    const activeColor = Color(0xFF672CBC);
    final inactiveColor = Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white, 
          border: Border(
            bottom: BorderSide(
              color: isActive ? activeColor : Colors.grey.shade200,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return Consumer<SurahListViewModel>(
      builder: (context, viewModel, child) {
        switch (viewModel.state) {
          case SurahListLoading():
            return Center(
              child: CircularProgressIndicator()
            );
          case SurahListError(:var message):
            return Center(
                child: Text("Error: $message")
              );
          case SurahListSuccessTypeSurah(:var surahs):
            return SingleChildScrollView( 
                controller: _surahScrollController,
                child: _buildSurahList(context, surahs));
          case SurahListSuccessTypeJuz(:var juz):
            return SingleChildScrollView( 
                controller: _juzScrollController,
                child: _buildJuzList(juz));
          case SurahListSuccessEmpty():
            return Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("No Result Found"));
        }
      },
    );
  }

  Widget _buildSurahList(BuildContext context, List<SurahInfoDto> surahList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 90, top: 20),
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
        InkWell(
          onTap: () => navigateToSurah(context, surah),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                _buildSurahNumberIcon(surah.number),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSurahInfo(surah),
                ),
                _buildArabicName(surah.name),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey[300], height: 1, thickness: 1),
      ],
    );
  }

  Widget _buildSurahNumberIcon(int surahNumber) {
    return SizedBox(
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
            color: const Color(0xFF672CBC),
          ),
          Text(
            '$surahNumber',
            style: const TextStyle(
              color: Color(0xFF3B1D77),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
            color: Color(0xFF3B1D77),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              surah.place,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7C8BA0),
              ),
            ),
            const Text(
              ' • ',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7C8BA0),
              ),
            ),
            Text(
              '${surah.totalAyah} Verse',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7C8BA0),
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
        color: Color(0xFF672CBC),
        fontFamily: 'Al Jazeera',
      ),
    );
  }

  Widget _buildJuzList(List<JuzInfoDto> juzList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 90, top: 20),
      itemCount: juzList.length,
      itemBuilder: (context, index) {
        final juz = juzList[index];
        return _buildJuzListItem(juz);
      },
    );
  }

  Widget _buildJuzListItem(JuzInfoDto juzInfo) {
    final isSameSurah = juzInfo.startSurahName == juzInfo.endSurahName;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
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
    );
  }

  Widget _buildJuzHeader(JuzInfoDto juzInfo) {
    return Row(
      children: [
        SizedBox(
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
                  color: Color(0xFF3B1D77),
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Verse ${juzInfo.startAyahNumber} - ${juzInfo.endAyahNumber}',
              style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFF672CBC),
              ),
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
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Verse ${juzInfo.startAyahNumber} - ${juzInfo.startSurahTotalAyah}',
              style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFF672CBC),
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey.shade300, thickness: 0.6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              juzInfo.endSurahName,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Verse 1 - ${juzInfo.endAyahNumber}',
              style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFF672CBC),
              ),
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