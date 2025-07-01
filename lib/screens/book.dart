import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/search_box.dart';
import 'package:mtqmnuns/config/route.dart';
import 'package:mtqmnuns/viewmodel/book_viewmodel.dart';
import 'package:provider/provider.dart';


class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 36),
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 4),
          searchBox(context),
          SizedBox(height: 20),
          Expanded(child: SurahWidget()),
        ],
      ),
    );
  }
}

class SurahWidget extends StatefulWidget {
  const SurahWidget({super.key});

  @override
  _SurahWidgetState createState() => _SurahWidgetState();
}

class _SurahWidgetState extends State<SurahWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<BookViewModel>();

    return Column(
      children: [
        // This stays fixed
        surahNavContainer(viewModel),

        // This scrolls
        Expanded(
          child: SingleChildScrollView(
            child: surahContainer(),
          ),
        ),
      ],
    );
  }


  Widget surahNavContainer(BookViewModel viewModel) {
    return Consumer<BookViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => viewModel.switchMode(SurahViewMode.surah),
                    child: Text(
                      'Surah',
                      style: TextStyle(
                        color:
                            viewModel.currentMode == SurahViewMode.surah
                                ? Color(0xFF672CBC)
                                : Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    color:
                        viewModel.currentMode == SurahViewMode.surah
                            ? Color(0xFF672CBC)
                            : Colors.grey.shade200,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => viewModel.switchMode(SurahViewMode.juz),
                    child: Text(
                      'Juz',
                      style: TextStyle(
                        color:
                            viewModel.currentMode == SurahViewMode.juz
                                ? Color(0xFF672CBC)
                                : Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    color:
                        viewModel.currentMode == SurahViewMode.juz
                            ? Color(0xFF672CBC)
                            : Colors.grey.shade200,
                  ),
                ],
              ),
            ),
            SizedBox(height: 75),
          ],
        );
      }
    );

  }


  Widget surahContainer() {
    return Consumer<BookViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.currentMode == SurahViewMode.surah) {
          return surahViewMode();
        } else {
          return juzViewMode();
        }
      },
    );
  }


  Widget surahViewMode() {
    return Consumer<BookViewModel>(
      builder: (context, viewModel, _) {
        final surahList = viewModel.filteredSurahs;

        if (surahList.isEmpty) {
          return const Center(child: Text("No Surah data available"));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 90),
          itemCount: surahList.length,
          itemBuilder: (context, index) {
            final surah = surahList[index];
            final verseCount = viewModel.getVerseCount(surah.id);

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    AppRoutes.surah.title = 'Reading ${surah.nameLatin}';
                    context.push(Uri(
                      path: AppRoutes.surah.path,
                      queryParameters: {
                        'id': '${surah.id}',
                        'ayah': '1',
                      },
                    ).toString());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        SizedBox(
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
                                color: Color(0xFF672CBC),
                              ),
                              Text(
                                '${surah.id}',
                                style: TextStyle(
                                  color: Color(0xFF3B1D77),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),

                        // Surah Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                surah.nameLatin,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3B1D77),
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    surah.place,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7C8BA0),
                                    ),
                                  ),
                                  Text(
                                    ' • ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7C8BA0),
                                    ),
                                  ),
                                  Text(
                                   '$verseCount Verse${verseCount > 1 ? 's' : ''}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7C8BA0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Arabic Name
                        Text(
                          surah.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF672CBC),
                            fontFamily: 'Al Jazeera'
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey[300], height: 1, thickness: 1),
              ],
            );
          },
        );
      },
    );
  }
  Widget juzViewMode() {
    return Consumer<BookViewModel>(
      builder: (context, viewModel, _) {
        final juzList = viewModel.filteredJuz;

        if (juzList.isEmpty) {
          return const Center(child: Text("No Juz data available"));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 90),
          itemCount: juzList.length,
          itemBuilder: (context, index) {
            final juz = juzList[index];
            final startSurah = juz['startSurah'];
            final endSurah = juz['endSurah'];
            final startAyah = juz['startAyah'];
            final endAyah = juz['endAyah'];
            final sameSurah = startSurah?.nameLatin == endSurah?.nameLatin;

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
                      Row(
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
                                  '${juz['juz']}',
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
                            'Juz ${juz['juz']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Conditional rendering
                      if (sameSurah) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${startSurah?.nameLatin}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'Verse ${startAyah?.ayahNumber} - ${endAyah?.ayahNumber}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF672CBC),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Divider(color: Colors.grey.shade300, thickness: 1.0),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${startSurah?.nameLatin}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'Verse ${startAyah?.ayahNumber} - ${startSurah?.totalAyah}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF672CBC),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey.shade300, thickness: 0.6),
                        // const SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${endSurah?.nameLatin}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'Verse 1 - ${endAyah?.ayahNumber}',
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
                    ],
                  ),
                ),
              // Same rendering code as before
            );
          },
        );
      },
    );
  }
}
