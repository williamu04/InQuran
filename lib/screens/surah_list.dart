import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/search_box.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/models/juz.dart';
import 'package:mtqmnuns/models/surah.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/viewmodel/surah_list.dart';
import 'package:provider/provider.dart';

enum SurahContentType { surah, juz }

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      height: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 4),
          searchBox(context),
          const SizedBox(height: 20),
          const Expanded(child: SurahListContentWidget()),
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
  SurahContentType _activeTabType = SurahContentType.surah;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SurahListViewModel>();

    return Column(
      children: [
        // Fixed tab navigation
        _buildTabNavigation(viewModel),
        
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: _buildTabContent(),
          ),
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
                isActive: _activeTabType == SurahContentType.surah,
                onTap: () => _switchTab(SurahContentType.surah, viewModel),
              ),
            ),
            Expanded(
              child: _buildTabButton(
                label: 'Juz',
                contentType: SurahContentType.juz,
                isActive: _activeTabType == SurahContentType.juz,
                onTap: () => _switchTab(SurahContentType.juz, viewModel),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onTap,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          height: 3,
          color: isActive ? activeColor : Colors.grey.shade200,
        ),
      ],
    );
  }

  void _switchTab(SurahContentType contentType, SurahListViewModel viewModel) {
    setState(() {
      _activeTabType = contentType;
    });
    viewModel.setContentFilter(contentType);
  }

  Widget _buildTabContent() {
    return Consumer<SurahListViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Padding(
          padding: EdgeInsets.only(top: 20),
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        }
        
        return _activeTabType == SurahContentType.surah
            ? _buildSurahList()
            : _buildJuzList();
      },
    );
  }

  Widget _buildSurahList() {
    return Consumer<SurahListViewModel>(
      builder: (context, viewModel, _) {
        final surahList = viewModel.filteredSurahs;

        if (surahList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("No Surah data available")
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 90, top: 20),
          itemCount: surahList.length,
          itemBuilder: (context, index) {
            final surah = surahList[index];
            return _buildSurahListItem(surah, viewModel);
          },
        );
      },
    );
  }

  Widget _buildSurahListItem(SurahWithVerse surahVerse, SurahListViewModel viewModel) {
    return Column(
      children: [
        InkWell(
          onTap: () => _navigateToSurah(surahVerse.surah),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                _buildSurahNumberIcon(surahVerse.surah.id),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSurahInfo(surahVerse.surah, surahVerse.verse),
                ),
                _buildArabicName(surahVerse.surah.name),
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

  Widget _buildSurahInfo(SurahData surah, int verseCount) {
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
              '$verseCount Verse${verseCount > 1 ? 's' : ''}',
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

  void _navigateToSurah(SurahData surah) {
    AppRoutes.surah.title = 'Reading ${surah.nameLatin}';
    context.push(Uri(
      path: AppRoutes.surah.path,
      queryParameters: {
        'id': '${surah.id}',
        'ayah': '1',
      },
    ).toString());
  }

  Widget _buildJuzList() {
    return Consumer<SurahListViewModel>(
      builder: (context, viewModel, _) {
        final juzList = viewModel.filteredJuz;

        if (juzList.isEmpty) {
          return const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("No Juz data available")
            );
        }

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
      },
    );
  }

Widget _buildJuzListItem(JuzInfo juzInfo) {
  final isSameSurah = juzInfo.startSurah.nameLatin == juzInfo.endSurah.nameLatin;

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

  Widget _buildJuzHeader(JuzInfo juzInfo) {
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

  Widget _buildSameSurahRange(JuzInfo juzInfo) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              juzInfo.startSurah.nameLatin,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Verse ${juzInfo.startAyah.ayahNumber} - ${juzInfo.endAyah.ayahNumber}',
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

  Widget _buildMultipleSurahRange(JuzInfo juzInfo) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              juzInfo.startSurah.nameLatin,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Verse ${juzInfo.startAyah.ayahNumber} - ${juzInfo.startSurah.totalAyah}',
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
              juzInfo.endSurah.nameLatin,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Verse 1 - ${juzInfo.endAyah.ayahNumber}',
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
}